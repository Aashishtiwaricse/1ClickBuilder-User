import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/cart_controller.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/api/cart/nexusCart.dart';
import 'package:shimmer/shimmer.dart';
import '../Home/SiginScreen/signinScreen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final vendorCtrl = Get.find<NexusVendorController>();
  final CartController cartCtrl = Get.find<CartController>();
  String _safeImage(String? url) {
    if (url == null || url.trim().isEmpty) {
      return 'https://via.placeholder.com/150';
    }
    return url;
  }

  @override
  void initState() {
    super.initState();

    cartCtrl.checkLogin().then((_) {
      if (cartCtrl.isLoggedIn.value) {
        final vendorId = vendorCtrl.vendorId.value;

        if (vendorId.isNotEmpty) {
          cartCtrl.loadCart(vendorId);
          debugPrint("🛒 Cart API called");
        } else {
          debugPrint("❌ Vendor ID empty");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// ❌ NOT LOGGED IN (TOKEN MISSING)
      if (!cartCtrl.isLoggedIn.value) {
        return _notLoggedInUI();
      }

      /// ⏳ LOADING (ONLY AFTER LOGIN)
      if (cartCtrl.isLoading.value) {
        return  Scaffold(
          body: Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),),
        );
      }

      final cart = cartCtrl.cart.value;

      /// 🛒 EMPTY CART (LOGGED IN)
      if (cart == null || cart.items.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: const Text("My Cart")),
          body: _emptyCartUI(),
        );
      }

      /// ✅ CART WITH ITEMS
      return Scaffold(
              backgroundColor: const Color(0xffF6F6F6),

        appBar: AppBar(title: const Text("My Cart")),
        body: Column(
          children: [
            Expanded(child: _cartList(cart)),
            _orderSummary(cart),
          ],
        ),
      );
    });
  }

  /// ================= CART LIST =================
  Widget _cartList(CartResponse cart) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: cart.items.length,
      itemBuilder: (_, index) {
        final item = cart.items[index];
        final vendorId = vendorCtrl.vendorId.value;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.network(
                      _safeImage(item.image),
                      height: 80,
                      width: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 80,
                          width: 60,
                          child: Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        cartCtrl.removeItem(
                          cartId: item.cartItemId,
                          vendor_id: vendorId,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹${item.sellingPrice}"),
                    Row(
                      children: [
                        _qtyBtn(
                            Icons.remove, () => cartCtrl.decreaseQty(index)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(item.quantity.toString()),
                        ),
                        _qtyBtn(Icons.add, () => cartCtrl.increaseQty(index)),
                      ],
                    ),
                    Text(
                      "₹${(item.sellingPrice * item.quantity).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ================= ORDER SUMMARY =================
  Widget _orderSummary(CartResponse cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _summaryRow("Subtotal", cart.totalPrice),
          const SizedBox(height: 6),
          _summaryRow("Total", cart.totalPrice, bold: true),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              _showCheckoutForm();
            },
            child: const Text("PROCEED TO CHECKOUT"),
          ),
        ],
      ),
    );
  }

  void _showCheckoutForm() {
    final _formKey = GlobalKey<FormState>();
    final firstNameCtrl = TextEditingController();
    final lastNameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final postalCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String? selectedCountry;
    String? selectedState;
    String? selectedCity;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Information",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: firstNameCtrl,
                            decoration: const InputDecoration(
                                labelText: "First Name *"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "First name required";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: lastNameCtrl,
                            decoration:
                                const InputDecoration(labelText: "Last Name *"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Last name required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: emailCtrl,
                            decoration: const InputDecoration(
                                labelText: "Email Address *"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email required";
                              }
                              if (!GetUtils.isEmail(value)) {
                                return "Enter valid email";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: phoneCtrl,
                            decoration: const InputDecoration(
                                labelText: "Phone Number *"),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Phone required";
                              }
                              if (!GetUtils.isPhoneNumber(value)) {
                                return "Enter valid phone number";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCountry,
                      hint: const Text("Select a country"),
                      items: ["India", "USA", "UK"]
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => selectedCountry = val,
                      validator: (value) {
                        if (value == null) return "Select country";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedState,
                            hint: const Text("Select a state"),
                            items: ["State 1", "State 2"]
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) => selectedState = val,
                            validator: (value) {
                              if (value == null) return "Select state";
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCity,
                            hint: const Text("Select City"),
                            items: ["City 1", "City 2"]
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) => selectedCity = val,
                            validator: (value) {
                              if (value == null) return "Select city";
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: streetCtrl,
                            decoration:
                                const InputDecoration(labelText: "Street"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: postalCtrl,
                            decoration: const InputDecoration(
                                labelText: "Postal Code *"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Postal code required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: noteCtrl,
                      decoration:
                          const InputDecoration(labelText: "Write note"),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process checkout
                          Get.back();
                          Get.snackbar("Success", "Order placed successfully!");
                        }
                      },
                      child: const Text("Place Order"),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// ================= HELPERS =================
  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _summaryRow(String title, double value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          "₹${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  /// ================= STATES =================
  Widget _notLoggedInUI() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 80),
            const SizedBox(height: 16),
            const Text("You are not logged in"),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => NexusSignInScreen()),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCartUI() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 100),
            child: Image.asset("assets/shopingcart.gif", height: 160),
          ),
          const SizedBox(height: 18),
          const Text("Your cart is empty"),
          const SizedBox(height: 18),

          // ElevatedButton(
          //   onPressed: Get.back,
          //   child: const Text("Continue Shopping"),
          // ),
        ],
      ),
    );
  }
}
