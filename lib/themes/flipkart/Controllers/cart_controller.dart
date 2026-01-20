import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Nexus/api/cart/nexusAddtoCart.dart';
import 'package:one_click_builder/themes/Nexus/api/cart/nexusCart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;




/// ================= RESULT ENUM =================
enum CartAddResult {
  success,
  alreadyExists,
  notLoggedIn,
  error,
}

class CartController extends GetxController {
var isLoading = false.obs;
  var isAddingToCart = false.obs; // ✅ MISSING (NOW ADDED)
  var cart = Rxn<CartResponse>();
    var isLoggedIn = false.obs;


  Future<void> checkLogin() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  debugPrint("🔑 TOKEN FROM PREFS: $token");

  isLoggedIn.value = token != null && token.isNotEmpty;
}


  /// ================= LOAD CART =================
Future<void> loadCart(String vendorId) async {
  try {
    isLoading.value = true;

    final response = await CartService.fetchCart(vendorId);
    cart.value = response;

    debugPrint("✅ Cart loaded: ${response.items.length} items");
  } catch (e) {
    debugPrint("❌ Cart error: $e");
    cart.value = CartResponse(
      totalPrice: 0,
      totalQuantity: 0,
      items: [],
    );
  } finally {
    isLoading.value = false;
  }
}


  /// ================= ADD TO CART =================


  /// ================= QUANTITY =================
  void increaseQty(int index) {
    cart.update((c) {
      if (c == null) return;
      c.items[index].quantity++;
      _recalculateTotal(c);
    });
  }

  void decreaseQty(int index) {
    cart.update((c) {
      if (c == null) return;
      if (c.items[index].quantity > 1) {
        c.items[index].quantity--;
        _recalculateTotal(c);
      }
    });
  }

  /// ================= DELETE ITEM =================
  Future<void> removeItem({
    required String cartId,
    required String vendor_id,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) return;

    final url =
        'https://api.1clickbuilder.com/api/cart/remove-item/$cartId/$vendor_id';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );
    print(" cart delete api called ");


    print(" ${response.body}");
        print(" ${response.statusCode}");


    if (response.statusCode == 200) {
      cart.update((c) {
        if (c == null) return;
        c.items.removeWhere((e) => e.cartItemId == cartId);
        _recalculateTotal(c);
      });


      Get.snackbar(
      'Success',
      'Item removed from cart',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
    }
  }

  /// ================= TOTAL =================
  void _recalculateTotal(CartResponse c) {
    c.totalPrice = c.items.fold(
      0.0,
      (sum, item) => sum + (item.sellingPrice * item.quantity),
    );
  }
}
