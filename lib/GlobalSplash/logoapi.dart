import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/GlobalSplash/Model/model.dart';

class LogoService {
  static Future<LogoModel> getLogoData() async {
    final url = Uri.parse(
      
      "https://api.1clickbuilder.com/api/logo/logo/nexus-preview.1clickbuilder.com"
      
      );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return LogoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Try after SomeTime");
    }
  }
}
