import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/GlobalSplash/Model/model.dart';
import 'package:one_click_builder/themes/Fuzzy/view/screen/splash_screen.dart';
import 'package:one_click_builder/themes/Nexus/Main/main.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Streamline/streamline.dart';
import 'package:one_click_builder/themes/flipkart/Main/main.dart';

class GlobalSplash extends StatefulWidget {
  const GlobalSplash({Key? key}) : super(key: key);

  @override
  State<GlobalSplash> createState() => _GlobalSplashState();
}

class _GlobalSplashState extends State<GlobalSplash> {
  @override
  void initState() {
    super.initState();
    fetchThemeAndNavigate();
  }
Future<void> fetchThemeAndNavigate() async {
  try {
    final response = await http.get(
      Uri.parse(
        "https://api.1clickbuilder.com/api/logo/logo/nexus-preview.1clickbuilder.com/",
      ),
    );

    debugPrint("STATUS: ${response.statusCode}");
    debugPrint("BODY global: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final Map<String, dynamic> data = body['data'];

      final LogoModel logoModel = LogoModel.fromJson(data);

      debugPrint("THEME 👉 ${logoModel.currentTheme}");

      final vendorController =
          Get.put(NexusVendorController(), permanent: true);

      vendorController.setVendorData(
        vendor: logoModel.vendorId ?? '',
        logo: logoModel.logoUrl ?? '',
      );

      if (!mounted) return;

      /// ✅ POST FRAME NAVIGATION (CRITICAL FIX)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        switch (logoModel.currentTheme) {
          case "streamline":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => Streamline(logoData: logoModel),
              ),
            );
            break;

          case "apex":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => FuzzySplashScreen(),
              ),
            );
            break;

          case "nexus":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => NexusMain(),
              ),
            );
            break;

          default:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => NexusMain(),
              ),
            );
        }
      });
    } else {
      showError();
    }
  } catch (e, stack) {
    debugPrint("ERROR: $e");
    debugPrint("STACK: $stack");
    showError();
  }
}



  // Future<void> fetchThemeAndNavigate() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse(
  //           "https://api.1clickbuilder.com/api/logo/logo/nexus-preview.1clickbuilder.com/"),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       /// ✅ DEFINE MODEL FIRST
  //       /// ✅ DECODE RESPONSE
  //       final Map<String, dynamic> jsonData =
  //           jsonDecode(response.body) as Map<String, dynamic>;

  //       /// ✅ CREATE MODEL
  //       final LogoModel logoModel = LogoModel.fromJson(jsonData);

  //       /// ✅ REGISTER CONTROLLER
  //       final vendorController =
  //           Get.put(NexusVendorController(), permanent: true);

  //       /// ✅ SAVE DATA HERE
  //       vendorController.setVendorData(
  //         vendor: logoModel.vendorId ?? '',
  //         logo: logoModel.logoUrl ?? '',
  //       );

  //       // SAVE vendorId USING GETX

  //       //  debugPrint("Theme: ${logoData.currentTheme}");

  //       if (!mounted) return;

  //       print("hhhhhhhhhhhh${logoModel.currentTheme}");

  //       switch (logoModel.currentTheme) {
  //         case "streamline":
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (_) => Streamline(logoData: logoModel)),
  //           );
  //           break;

  //         case "apex":
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (_) => FuzzySplashScreen()),
  //           );
  //           break;

  //         case "nexus":
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (_) => NexusMain()),
  //           );
  //           break;

  //         default:
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (_) => FuzzySplashScreen()),
  //           );
  //       }
  //     } else {
  //       showError();
  //     }
  //   } catch (e) {
  //     debugPrint("API Error: $e");
  //     showError();
  //   }
  // }

  void showError() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => FuzzySplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
  child: Image.asset(
    'assets/loader_hd.gif',
    width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

    fit: BoxFit.contain,
  ),
)
,
    );
  }
}
