import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/HomeCategoryTab.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/flipkartBanners.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/BestSellerScreen/nexusBestSeller.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/NexusProduct/nexusNewArrival.dart';
import 'package:one_click_builder/themes/Flipkart/api/BestSeller/NexusBestSeller.dart';
import 'package:one_click_builder/themes/Flipkart/api/Categoryalist/categoryList.dart';
import 'package:one_click_builder/themes/Flipkart/api/NexusProduct/nexusProduct.dart';
import 'package:one_click_builder/themes/Flipkart/api/banners/bannersApi.dart';


class FlipkartHome extends StatefulWidget {
  const FlipkartHome({super.key});

  @override
  State<FlipkartHome> createState() => _FlipkartHomeState();
}

class _FlipkartHomeState extends State<FlipkartHome> {
  final bannerApi = NexusBannerApiService();
  final categoryApi = FlipkartCategoryApiService();
  final newApi = ProductService();
  final bestApi = BestSellerService();
  @override
  void initState() {
    super.initState();
    Get.put(FlipkartVendorController(), permanent: true);
      final vendorController =
      Get.put(FlipkartVendorController(), permanent: true);

  vendorController.loadVendorFromStorage();
  }

 Future<void> _refreshHome() async {
    final vendorId = Get.find<FlipkartVendorController>().vendorId.value;

    print("🔄 Pull-to-Refresh: Fetching all Home APIs again…");

    await bannerApi.getBannerList(vendorId);

    await categoryApi.fetchCategories(vendorId);
    await newApi.getProducts(vendorId);
    await bestApi.getBestSellerProducts(vendorId);

    // UI will refresh itself since data updates inside widgets
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        color: Colors.blue, // optional
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
  children: [

    /// 🔥 BANNERS
    //FlipkartBannerScreen(),
    const SizedBox(height: 10),

    /// 🔥 CATEGORY TABS (LIKE FLIPKART)
    const HomeCategoryTabs(),

    /// 🔥 OTHER HOME SECTIONS (OPTIONAL)
    const SizedBox(height: 20),
    NewArrivalSection(),
    const SizedBox(height: 20),
    BestSellerScreen(),
    const SizedBox(height: 40),
  ],
),

        ),
      ),
    );
  }
}
