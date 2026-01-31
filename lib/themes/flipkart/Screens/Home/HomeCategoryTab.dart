import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/flipkartBanners.dart';
import 'package:one_click_builder/themes/Flipkart/api/Categoryalist/categoryList.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategoryTabs extends StatefulWidget {
  const HomeCategoryTabs({super.key});

  @override
  State<HomeCategoryTabs> createState() => _HomeCategoryTabsState();
}

class _HomeCategoryTabsState extends State<HomeCategoryTabs> {
  final api = FlipkartCategoryApiService();
  final vendorController = Get.find<FlipkartVendorController>();

  List categories = [];
  bool loading = true;

@override
void initState() {
  super.initState();

  // ✅ 1. Call immediately if vendorId already exists
  final id = vendorController.vendorId.value;
  if (id.isNotEmpty) {
    print("✅ VendorId already available: $id");
    _loadCategories();
  }

  // ✅ 2. Listen for future changes
  ever<String>(vendorController.vendorId, (id) {
    if (id.isNotEmpty) {
      print("🔁 VendorId updated: $id");
      _loadCategories();
    }
  });
}



Future<void> _loadCategories() async {
  final vendorId = vendorController.vendorId.value;
  print("🟡 CATEGORY vendorId = $vendorId");

  if (vendorId.isEmpty) return;

  setState(() {
    loading = true;
  });

  final res = await api.fetchCategories(vendorId);

  categories = res?.data?.categories ?? [];

  setState(() {
    loading = false;
  });
}



  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(height: 50, color: Colors.white),
      );
    }

    if (categories.isEmpty) return const SizedBox();

    return DefaultTabController(
      length: categories.length,
      child: Column(
        children: [

          /// 🔥 TOP CATEGORY TABS
          Container(
            height: 60,
            color: Colors.white,
            child: TabBar(
              isScrollable: true,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              tabs: categories.map<Tab>((c) {
                return Tab(
                  icon: c.imageUrl != null && c.imageUrl!.isNotEmpty
                      ? Image.network(c.imageUrl!, height: 22)
                      : const Icon(Icons.category, size: 18),
                  text: c.name,
                );
              }).toList(),
            ),
          ),

          /// 🔥 TAB CONTENT
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: TabBarView(
              children: categories.map<Widget>((c) {
                return Column(
                  children: [
                                        const SizedBox(height: 10),

                    FlipkartBannerScreen(),
                    const SizedBox(height: 10),
                    Text(
                      c.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    /// Load products by category here
                    Expanded(
                      child: Center(
                        child: Text("Products for ${c.name}"),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
