import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:one_click_builder/GlobalSplash/globalSplash.dart';
import 'package:one_click_builder/themes/Fuzzy/view/screen/dashboard_screens/wishlist_screen.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/homepage/category_provider.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/homepage/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/authentication/login_provider.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/authentication/registration_provider.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/cart/cart_controller.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/dashboard/dashboard_provider.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/homepage/appdrawer_provider.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/homepage/banner_provider.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/homepage/product_list_provider.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/product_detail_provider.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/sub_categery_provider.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/subcategory_product_provider.dart';
import 'package:one_click_builder/themes/Fuzzy/controller/userprofile_provider.dart';
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
import 'package:one_click_builder/themes/Fuzzy/service/checkout_api.dart';
import 'package:one_click_builder/themes/Fuzzy/service/home/best_selling_product_api.dart';
import 'package:one_click_builder/themes/Fuzzy/service/wishlist_api.dart';

import 'package:one_click_builder/themes/Fuzzy/view/screen/splash_screen.dart';
import 'package:one_click_builder/themes/Vector/view/screen/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()..loadCategories()),
        ChangeNotifierProvider(create: (_) => SubCategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => BestSellingProductProvider()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => ProductDetailProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ProductListController()..loadProducts()),
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ChangeNotifierProvider(create: (_) => SubCategoryProjectProvider()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget homeScreen;

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
