import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:one_click_builder/themes/Amazon/utility/app_constant.dart';

import '../../NexusVendorId/vendorid.dart';


class RegisterController extends GetxController {
  final NexusVendorController vendorCtrl = Get.find();

  RxBool isLoading = false.obs;

  /// Register API Call
  Future<void> registerUser({
    required String first,
    required String last,
    required String mobile,
    required String password,
    required String confirm,
    String? email,
  }) async {
    isLoading.value = true;

    final body = {
      "firstName": first,
      "lastName": last,
      "email": email == "" ? null : email,
      "mobile": mobile,
      "password": password,
      "confirmPassword": confirm,
      "vendorId": vendorCtrl.vendorId.value
    };

    final response = await http.post(
      Uri.parse("${AmzAppConstant.baseUrl}/api/user/customer-register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    isLoading.value = false;

    final data = jsonDecode(response.body);

    /// success codes 200 or 201
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        data["error"] == null) {
      
      Get.snackbar(
        "Success",
        data["data"]["message"] ?? "Registered Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      /// Navigate to sign in screen and CLEAR ROUTE STACK
      Future.delayed(Duration(seconds: 1), () {
        Get.offAll(() => AmzSignInScreen());
      });

    } else {
      Get.snackbar(
        "Error",
        data["error"]?["message"] ?? "Registration Failed",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }
}
