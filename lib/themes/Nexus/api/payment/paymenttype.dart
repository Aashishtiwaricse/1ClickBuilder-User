import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';




class PaymentService {
  Future<List<String>> getDeliveryTypes(String vendorId) async {
    final url =
        "https:///api/payment-gateway/delivery-type/$vendorId";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Cache-Control": "no-cache",
          "Pragma": "no-cache",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 304) {
        if (response.body.isEmpty) {
          // 304 may return empty body
          return ["cod"]; // fallback default
        }

        final jsonData = json.decode(response.body);
        final types = (jsonData["data"]?["deliveryType"] != null)
            ? List<String>.from(jsonData["data"]["deliveryType"])
            : ["cod"]; // fallback default

        return types;
      } else {
        return ["cod"]; // fallback default
      }
    } catch (e) {
      print("❌ Error: $e");
      return ["cod"]; // fallback default
    }
  }
}
