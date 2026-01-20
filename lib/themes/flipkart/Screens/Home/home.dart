import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/BestSellerScreen/nexusBestSeller.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/Category/CategoryList.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProduct/nexusNewArrival.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/banners.dart';
import 'package:one_click_builder/themes/flipkart/Screens/Home/Category/CategoryList.dart';

class FlipkartHome extends StatefulWidget {
  const FlipkartHome({super.key});

  @override
  State<FlipkartHome> createState() => _FlipkartHomeState();
}

class _FlipkartHomeState extends State<FlipkartHome> {

  @override
void initState() {
  super.initState();
  Get.put(NexusVendorController(), permanent: true);
}

  @override
  Widget build(BuildContext context) {
    return    Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            BannerScreen(),
            SizedBox(
              height: 40,
            ),
            FlipkartCategoryScreen(),
            SizedBox(
              height: 40,
            ),
            NewArrivalSection(),
            SizedBox(
              height: 40,
            ),
            BestSellerScreen(),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
