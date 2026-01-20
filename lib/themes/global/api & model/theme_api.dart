import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/global/api%20&%20model/theme_model.dart';

// class ThemeService {
//   static const String baseUrl = "https://api.1clickbuilder.com/api/logo/logo/";

//   static Future<ThemeModel?> getThemeData(String domain) async {
//     try {
//       final url = Uri.parse("$baseUrl$domain");

//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         return ThemeModel.fromJson(json.decode(response.body));
//       } else {
//         print("Error: ${response.statusCode}");
//         return null;
//       }

//     } catch (e) {
//       print("Exception: $e");
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/global/api & model/theme_model.dart';

class ThemeService {
  static const String baseUrl = "https://api.1clickbuilder.com/api/logo/logo/";

  static Future<ThemeModel?> getThemeData(String domain) async {
    try {
      final url = Uri.parse("$baseUrl$domain");

      final response = await http.get(url);

      print("📡 API URL: $url");
      print("📥 Raw API Response: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ API Request Successful");
        return ThemeModel.fromJson(json.decode(response.body));
      } else {
        print("❌ Error Status Code: ${response.statusCode}");
        print("❌ Error Response Body: ${response.body}");
        return null;
      }

    } catch (e) {
      print("🔥 Exception Thrown: $e");
      return null;
    }
  }
}

