import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_click_builder/themes/Amazon/Screens/profile/screens/OrdersReturnsScreen.dart';
import 'package:one_click_builder/themes/Amazon/api/cart/create_order_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AmzCheckoutForm extends StatefulWidget {
  final dynamic cartCtrl;
  final dynamic vendorCtrl;

  const AmzCheckoutForm({
    super.key,
    required this.cartCtrl,
    required this.vendorCtrl,
  });

  @override
  State<AmzCheckoutForm> createState() => _AmzCheckoutFormState();
}

class _AmzCheckoutFormState extends State<AmzCheckoutForm> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final zipCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();

  String? country = "India";
  String? state;
  String? paymentMethod = "Cash on Delivery";
  bool isLoading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    mobileCtrl.dispose();
    emailCtrl.dispose();
    zipCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF3F3F3),
      
        // 🔝 AMAZON STYLE APPBAR
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text(
            "Checkout",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
      
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 🚚 DELIVERY ADDRESS
              _sectionCard(
                title: "Delivering to",
                child: Column(
                  children: [
                    _input(nameCtrl, "Full name"),
      
                    _input(
                      mobileCtrl,
                      "Mobile Number",
                      keyboard: TextInputType.phone,
                    ),
      
                    _input(streetCtrl, "House / Street"),
                    _input(cityCtrl, "City"),
                    _input(
                      zipCtrl,
                      "Pincode",
                      keyboard: TextInputType.number,
                    ),
      
                    const SizedBox(height: 10),
      
                    DropdownButtonFormField<String>(
                      value: country,
                      decoration: _inputDecoration(hint: "Country / Region"),
                      items: const [
                        DropdownMenuItem(value: "India", child: Text("India")),
                      ],
                      onChanged: (v) => setState(() => country = v),
                    ),
      
                    const SizedBox(height: 12),
      
                    DropdownButtonFormField<String>(
                      value: state,
                      isExpanded: true,
                      decoration: _inputDecoration(hint: "State / Union Territory"),
                      items: _indianStates
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setState(() => state = v),
                      validator: (v) => v == null ? "Please select state" : null,
                    ),
                  ],
                ),
              ),
      
      
              const SizedBox(height: 14),
      
              // 💳 PAYMENT
              _sectionCard(
                title: "Payment Method",
                child: DropdownButtonFormField<String>(
                  value: paymentMethod,
                  items: const [
                    DropdownMenuItem(
                      value: "Cash on Delivery",
                      child: Text("Cash on Delivery"),
                    ),
                  ],
                  onChanged: (v) => setState(() => paymentMethod = v),
                  decoration: _inputDecoration(),
                ),
              ),
      
              const SizedBox(height: 100),
            ],
          ),
        ),
      
        // 🟡 AMAZON STYLE BOTTOM BUTTON
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD814),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: isLoading ? null : _placeOrder,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                "Continue",
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _input(
      TextEditingController controller,
      String hint, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (v) =>
        v == null || v.trim().isEmpty ? "Required" : null,
        decoration: _inputDecoration(hint: hint),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xffF7F7F7),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  // ---------------- ORDER ----------------

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (country == null || state == null || cityCtrl.text.isEmpty) {
      Get.snackbar("Error", "Please select Country, State & City");
      return;
    }

    _formKey.currentState!.save();

    final cart = widget.cartCtrl.cart.value;

    final orderItems = cart.items.map<Map<String, dynamic>>((e) {
      return {
        "product_id": e.productId,
        "productImageId": e.productImageId,
        "quantity": e.quantity,
        "price": e.sellingPrice,
      };
    }).toList();

    final billing = {
      "name": nameCtrl.text.trim(),
      "mobile_number": mobileCtrl.text.trim(),
      "country": country,
      "state": state,
      "city": cityCtrl.text.trim(),
      "zip_code": zipCtrl.text.trim(),
      "street_address": streetCtrl.text.trim(),
    };

    final shipping = {
      ...billing,
      "email": emailCtrl.text.trim(),
    };

    setState(() => isLoading = true);

    final success = await CreateOrderService.createOrder(
      vendorId: widget.vendorCtrl.vendorId.value,
      paymentMethod: paymentMethod ?? "COD",
      shippingMethod: "Express",
      orderItems: orderItems,
      billingAddress: billing,
      shippingAddress: shipping,
    );

    setState(() => isLoading = false);

    if (success) {
      final vendorId = widget.vendorCtrl.vendorId.value;
      final itemsToDelete =
      List.from(widget.cartCtrl.cart.value.items);

      for (var item in itemsToDelete) {
        await widget.cartCtrl.removeItem1(
          cartItemId: item.cartItemId,
          VendorId: vendorId,
        );
      }

      await widget.cartCtrl.loadCart(vendorId);

      Get.back();
      Get.off(() => OrdersReturnScreen());
    }
  }
}

// ---------------- STATES ----------------

final List<String> _indianStates = [
  "Andhra Pradesh",
  "Arunachal Pradesh",
  "Assam",
  "Bihar",
  "Chhattisgarh",
  "Goa",
  "Gujarat",
  "Haryana",
  "Himachal Pradesh",
  "Jharkhand",
  "Karnataka",
  "Kerala",
  "Madhya Pradesh",
  "Maharashtra",
  "Punjab",
  "Rajasthan",
  "Tamil Nadu",
  "Telangana",
  "Uttar Pradesh",
  "Uttarakhand",
  "West Bengal",
  "Delhi",
  "Jammu and Kashmir",
  "Ladakh",
  "Puducherry",
];
