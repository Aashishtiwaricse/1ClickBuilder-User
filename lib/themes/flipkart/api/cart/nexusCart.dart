import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartService {
  static const String _baseUrl =
      '${NexusAppConstant.baseUrl}${NexusAppConstant.catUrl}';

  /// 🔹 FETCH CART BY VENDOR ID
  static Future<CartResponse> fetchCart(String vendorId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      await prefs.clear();

      Get.snackbar(
        'Session Expired',
        'Please login again',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      throw Exception('SessionExpired');
    }

    final url = Uri.parse('$_baseUrl/$vendorId');

    print("🛒 Cart API called");

    final response = await http.get(
      url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );

    print("📦 Cart Response: ${response.body}");
    print("📦 Status Code: ${response.statusCode}");

    final body = json.decode(response.body);

    /// 🔴 TOKEN EXPIRED / INVALID
    if (body['error'] != null &&
        body['error']['error'] == 'FailedToAuthenticate') {
      await prefs.clear();

      Get.snackbar(
        'Session Expired',
        'Please login again',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      throw Exception('SessionExpired');
    }

    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Cart API failed');
    }

    double total = 0;
    int quantity = 0;
    List<CartItem> items = [];

    final data = body['data'];

    /// ✅ CASE 1: data is LIST
    if (data is List) {
      items = data.map<CartItem>((e) {
        final item = CartItem.fromJson(e);
        total += item.sellingPrice * item.quantity;
        quantity += item.quantity;
        return item;
      }).toList();
    }

    /// ✅ CASE 2: data is MAP
    else if (data is Map) {
      final List listItems = data['items'] ?? [];

      items = listItems.map<CartItem>((e) {
        final item = CartItem.fromJson(e);
        total += item.sellingPrice * item.quantity;
        quantity += item.quantity;
        return item;
      }).toList();
    }

    return CartResponse(
      totalPrice: total,
      totalQuantity: quantity,
      items: items,
    );
  }
}

/// 🔹 RESPONSE HOLDER
class CartResponse {
  double totalPrice;
  final int totalQuantity;
  final List<CartItem> items;

  CartResponse({
    required this.totalPrice,
    required this.totalQuantity,
    required this.items,
  });
}

/// 🔹 CART ITEM MODEL
class CartItem {
  final String cartItemId;
  final String productId;
  int quantity;
  final double sellingPrice;
  final double mrpPrice;
  final double discountingPrice;
  final String? selectedColor;
  final String? selectedSize;
  final String image;
  final String productName;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.quantity,
    required this.sellingPrice,
    required this.mrpPrice,
    required this.discountingPrice,
    this.selectedColor,
    this.selectedSize,
    required this.image,
    required this.productName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      sellingPrice:
          double.tryParse(json['sellingPrice']?.toString() ?? '0') ?? 0.0,
      mrpPrice:
          double.tryParse(json['mrpPrice']?.toString() ?? '0') ?? 0.0,
      discountingPrice:
          double.tryParse(json['discountingPrice']?.toString() ?? '0') ?? 0.0,
      selectedColor: json['selectedColor'],
      selectedSize: json['selectedSize'],
      image: (json['image'] is String && json['image'].toString().isNotEmpty)
          ? json['image']
          : '',
      productName: json['productName']?.toString() ?? '',
    );
  }
}
