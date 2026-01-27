import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:one_click_builder/GlobalSplash/globalSplash.dart';
import 'package:one_click_builder/themes/Fuzzy/view/screen/dashboard_screens/wishlist_screen.dart';

import 'package:one_click_builder/themes/Fuzzy/data/AddressData/shipping_address.dart';
import 'package:one_click_builder/themes/Fuzzy/data/Help/about_us_screen.dart';
import 'package:one_click_builder/themes/Fuzzy/data/Help/api/cancellation_screen.dart';
import 'package:one_click_builder/themes/Fuzzy/data/Help/api/privacy_screen.dart';
import 'package:one_click_builder/themes/Fuzzy/data/Help/help_screen.dart';
import 'package:one_click_builder/themes/Fuzzy/data/Help/language_screen.dart';
import 'package:one_click_builder/themes/Fuzzy/data/Help/retrun_screen.dart';
import 'package:one_click_builder/themes/Fuzzy/data/Help/terms_condition_screen.dart';
import 'package:one_click_builder/themes/Fuzzy/data/OrderHistory/order_history.dart';
import 'package:one_click_builder/themes/Fuzzy/data/currency/currency_screen.dart';
import 'package:one_click_builder/themes/Fuzzy/data/payment/payment_screen.dart';
import 'package:one_click_builder/themes/Fuzzy/data/setting/setting_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /// Load theme-specific splash screen
    

    return GetMaterialApp(
      title: 'One Click Builder User',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      routes: {
        '/orderHistory': (context) => const OrderHistory(),
        '/wishlist': (context) => const WishlistScreen(),
        '/payment': (context) => PaymentScreen(),
        '/shippingDetails': (context) => ShippingDetailsScreen(),
        '/language': (context) => const LanguageScreen(),
        '/currency': (context) => const CurrencyScreen(),
        '/setting': (context) => const SettingScreen(),
        '/termsCondition': (context) => const TermsConditionScreen(),
        '/retrunScreen': (context) => const ReturnScreen(),
        '/cancelScreen': (context) => const CancellationScreen(),
        '/aboutUs': (context) => const AboutUsScreen(),
        '/privacyScreen': (context) => const PrivacyScreen(),
        '/help': (context) => const HelpScreen(),
      },
      home: const GlobalSplash(),
    );
  }
}
