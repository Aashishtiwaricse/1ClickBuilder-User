import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_click_builder/themes/Nexus/Screens/profile/screens/OrdersReturnsScreen.dart';
import 'package:one_click_builder/themes/Nexus/api/cart/create_order_service.dart';

class CheckoutForm extends StatefulWidget {
  final dynamic cartCtrl;
  final dynamic vendorCtrl;

  const CheckoutForm({
    super.key,
    required this.cartCtrl,
    required this.vendorCtrl,
  });

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final zipCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();


  String? state, city;
  String? country = "India"; // default country
  String? paymentMethod;

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
    return DraggableScrollableSheet(
      initialChildSize: 0.99,
      maxChildSize: 0.99,
      minChildSize: 0.80,
      builder: (_, controller) {
        return Padding(
 padding: EdgeInsets.only(
    bottom: MediaQuery.of(context).viewInsets.bottom, // 👈 moves UI up with keyboard
  ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Form(
                key: _formKey,
                child: ListView(
                  controller: controller,
                  children: [
                    Center(
                      child: Container(
                        height: 5,
                        width: 60,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
          
                    const Text(
                      "Your Addresses",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
          
                    const SizedBox(height: 20),
          
                    // ------------------ Country -------------------
          // ------------------ COUNTRY (TOP) ------------------
          // ------------------ COUNTRY DROPDOWN (ONLY INDIA) ------------------
          
                    const Text(
                      "Country/Region",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
          
                    const SizedBox(height: 6),
          
                    DropdownButtonFormField<String>(
                      value: country,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.pink.shade300, width: 1.5),
                        ),
                      ),
          
                      // Dropdown items (ONLY INDIA)
                      items: [
                        const DropdownMenuItem(
                          value: "India",
                          child: Text(
                            "India",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
          
                      onChanged: (value) {
                        setState(() => country = value);
                      },
                    ),
          
                    const SizedBox(height: 20),
          
                    const SizedBox(height: 15),
          
                    // ------------------ Full Name -------------------
                    _input(nameCtrl, "Full name (First and Last name)"),
          
                    // ------------------ Mobile -------------------
                    IntlPhoneField(
                      initialCountryCode: 'IN',
                      decoration: InputDecoration(
                        labelText: 'Mobile number',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.pink.shade300, width: 1.5),
                        ),
                      ),
                      disableLengthCheck: true,
                      onChanged: (phone) {},
                      validator: (phone) {
                        if (phone == null || phone.number.isEmpty) {
                          return "Mobile number required";
                        }
                        if (phone.number.length != 10) {
                          return "Enter valid 10-digit number";
                        }
                        return null;
                      },
                      onSaved: (phone) => mobileCtrl.text = phone?.number ?? "",
                    ),
          
                    const SizedBox(height: 15),
          
                    // ------------------ House No -------------------
                    _input(streetCtrl,
                        "Flat, House no., Building, Company, Apartment"),
          
                    // ------------------ Area -------------------
                    _input(emailCtrl, "Area, Street, Sector, Village"),
          
                    // ------------------ Landmark -------------------
          
                    // ------------------ PIN + Town Row -------------------
                    Row(
                      children: [
                        Expanded(
                          child: _input(zipCtrl, "Pincode",
                              keyboard: TextInputType.number, validator: (v) {
                            if (v == null || v.isEmpty) return "Required";
                            if (v.length != 6) return "Invalid pincode";
                            return null;
                          }),
                        ),
                        const SizedBox(width: 10),
   Expanded(
  child: _input(
    cityCtrl,
    "Town/City",
    validator: (v) {
      if (v == null || v.trim().isEmpty) {
        return "City required";
      }
      return null;
    },
  ),
),


                      ],
                    ),
          
                    const SizedBox(height: 10),
                    const Text("State/Union Territory",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
          
                    Container(
                      width: double.infinity, // ensures full width
                      child: DropdownButtonFormField<String>(
                        value: state,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.pink.shade300, width: 1.5),
                          ),
                        ),
                        isExpanded: true, // important to prevent overflow
                        items: [
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
                          "Manipur",
                          "Meghalaya",
                          "Mizoram",
                          "Nagaland",
                          "Odisha",
                          "Punjab",
                          "Rajasthan",
                          "Sikkim",
                          "Tamil Nadu",
                          "Telangana",
                          "Tripura",
                          "Uttar Pradesh",
                          "Uttarakhand",
                          "West Bengal",
                          "Andaman and Nicobar Islands",
                          "Chandigarh",
                          "Dadra and Nagar Haveli and Daman & Diu",
                          "Delhi",
                          "Jammu and Kashmir",
                          "Ladakh",
                          "Lakshadweep",
                          "Puducherry"
                        ]
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => state = value);
                        },
                        validator: (v) =>
                            v == null ? "Please select a state/UT" : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Payment Method",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
          
                    Container(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        value: paymentMethod, // e.g., a variable you define
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.pink.shade300, width: 1.5),
                          ),
                        ),
                        isExpanded: true,
                        items: [
                          "Cash on Delivery", // ✅ New option added
          
                          // add more options here if needed
                        ]
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => paymentMethod = value);
                        },
                        validator: (v) =>
                            v == null ? "Please select a payment method" : null,
                      ),
                    ),
          
                    const SizedBox(height: 25),
          
                    // ------------------ Button -------------------
                    ElevatedButton(
                      onPressed: isLoading ? null : _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF28BA8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "PLACE ORDER",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  Widget _input(
    TextEditingController ctrl,
    String label, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        validator: validator ??
            (v) => v == null || v.isEmpty ? "$label required" : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade700),
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    print("📞 FINAL MOBILE: ${mobileCtrl.text}");

    if (!_formKey.currentState!.validate()) return;

if (country == null || state == null || cityCtrl.text.isEmpty) {

      Get.snackbar("Error", "Please select Country, State & City");
      return;
    }
    // 🔥 THIS LINE IS MANDATORY
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

  // 🔥 TAKE SNAPSHOT BEFORE CART RELOAD (IMPORTANT)
  final itemsToDelete = List.from(widget.cartCtrl.cart.value.items);

  Future.microtask(() async {
    print("🔥 Starting delete process… total: ${itemsToDelete.length}");

    for (var item in itemsToDelete) {
      print("🗑️ Removing ${item.cartItemId}");

      await widget.cartCtrl.removeItem1(
        cartItemId: item.cartItemId,
        VendorId: vendorId,
      );
    }

    print("♻️ Reloading cart…");
    await widget.cartCtrl.loadCart(vendorId);

    print("✅ Cart cleared successfully");
  });

  // Navigate
  Get.back();
  Get.off(() => OrdersReturnScreen());
}


  }
}
