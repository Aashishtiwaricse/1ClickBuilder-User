import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/BestSellerScreen/AmzBestSeller.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/Category/CategoryList.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/AmzProduct/AmzNewArrival.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/banners.dart';
import 'package:one_click_builder/themes/Amazon/api/BestSeller/AmzBestSeller.dart';
import 'package:one_click_builder/themes/Amazon/api/Categoryalist/categoryList.dart';
import 'package:one_click_builder/themes/Amazon/api/AmzProduct/AmzProduct.dart';
import 'package:one_click_builder/themes/Amazon/api/banners/bannersApi.dart';

import '../../NexusVendorId/vendorid.dart';



class AmzHome extends StatefulWidget {
  const AmzHome({super.key});

  @override
  State<AmzHome> createState() => _AmzHomeState();
}

class _AmzHomeState extends State<AmzHome> {
  final bannerApi = AmzBannerApiService();
  final categoryApi = AmzCategoryApiService();
  final newApi = ProductService();
  final bestApi = BestSellerService();
  @override
  void initState() {
    super.initState();
    Get.put(NexusVendorController(), permanent: true);
  }

 Future<void> _refreshHome() async {
    final vendorId = Get.find<NexusVendorController>().vendorId.value;

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
              BannerScreen(),
              const SizedBox(height:20),
              AmzCategoryScreen(),
             const SizedBox(height:20),
              NewArrivalSection(),
              const SizedBox(height:20),
              AmzBestSellerScreen(),
                        const SizedBox(height: 10)
            //  const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
