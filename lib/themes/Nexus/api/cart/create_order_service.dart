import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Fuzzy/utility/plugin_list.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CreateOrderService {
  static const String _url =
      "https://api.1clickbuilder.com/api/order/create-order";
static Future<bool> createOrder({
  required String vendorId,
  required String paymentMethod,
  required String shippingMethod,
  required List<Map<String, dynamic>> orderItems,
  required Map<String, dynamic> billingAddress,
  required Map<String, dynamic> shippingAddress,
  double discount = 0,
  double ship = 0,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final body = {
      "order": {
        "vendor_id": vendorId,
        "payment_method": paymentMethod.toUpperCase(), // FIXED
        "shipping_method": shippingMethod,
        "status": "Pending",
        "discount": discount,
        "ship": ship,
      },
      "orderItems": orderItems.map((item) => {
        "product_id": item["product_id"],
        "productImageId": item["productImageId"],
        "quantity": item["quantity"],
        "price": item["price"],
      }).toList(),
      "billingAddress": billingAddress,
      "shippingAddress": shippingAddress,
    };

    final res = await http.post(
      Uri.parse(_url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        if (token != null) "Authorization": "$token",
      },
      body: jsonEncode(body),
    );

    print("📡 STATUS: ${res.statusCode}");
    print("📦 BODY: ${res.body}");

   if (res.statusCode == 200 || res.statusCode == 201) {
      Get.snackbar("Success", "Order placed successfully!");

  return true;
} else {
  Get.snackbar(
    "Order Failed",
    "Unable to place order. Please try again.",
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
  );
  return false;
}

  } 
  
  
catch (e) {
  Get.snackbar(
    "Error",
    "Something went wrong. Please try again.",
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
  );
  return false;
}

}

}
