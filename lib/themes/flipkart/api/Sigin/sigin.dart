import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NexusAuthService {

  Future<bool> login(String email, String password) async {
    try {
      print("📤 Login API: ${NexusAppConstant.baseUrl}${NexusAppConstant.loginUrl}");
      print("📤 Request Body: { email: $email, password: ****** }");

      final response = await http.post(
        Uri.parse(
          "${NexusAppConstant.baseUrl}${NexusAppConstant.loginUrl}",
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Raw Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);

        if (decoded['error'] == null && decoded['data'] != null) {
          final data = decoded['data'];
          final user = data['user'];

          final prefs = await SharedPreferences.getInstance();

          await prefs.setString('user_id', data['id']);
          await prefs.setString('token', data['token']);
          await prefs.setString('refresh_token', data['refreshToken']);
          await prefs.setString('name', user['firstName']);
          await prefs.setString('email', user['email']);
          await prefs.setString('mobile', user['mobile'] ?? '');
          await prefs.setString(
              'profile_picture', user['profilePicture'] ?? '');
          await prefs.setString('role', user['role']);

          print("💾 Login success — user saved");
          print("🆔 user_id: ${data['id']}");

                    print("🆔 token: ${data['token']}");
          print("👤 role: ${user['role']}");

          return true;
        } else {
          print("⚠️ API error: ${decoded['error']}");
        }
      } else {
        print("❌ Login failed — status: ${response.statusCode}");
      }

      return false;
    } catch (e, stack) {
      print("❌ Exception during login: $e");
      print("📛 StackTrace: $stack");
      return false;
    }
  }
}
