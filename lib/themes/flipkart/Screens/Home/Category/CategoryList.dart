import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:one_click_builder/themes/Nexus/Modules/Categories/category.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/Category/allCategories.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/Category/allSubCategory/allSubCategory.dart';
import 'package:one_click_builder/themes/Nexus/api/Categoryalist/categoryList.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Nexus/api/Categoryalist/categoryList.dart';
import 'package:shimmer/shimmer.dart';

class FlipkartCategoryScreen extends StatefulWidget {
  const FlipkartCategoryScreen({super.key});

  @override
  State<FlipkartCategoryScreen> createState() => _FlipkartCategoryScreenState();
}

class _FlipkartCategoryScreenState extends State<FlipkartCategoryScreen>
    with TickerProviderStateMixin {
  final NexusCategoryApiService apiService = NexusCategoryApiService();
  final vendorController = Get.find<NexusVendorController>();

  bool loading = true;
  List categories = [];

  TabController? _tabController;
  late Worker _vendorWorker;

  @override
  void initState() {
    super.initState();

    final vendorId = vendorController.vendorId.value;
    if (vendorId.isNotEmpty) {
      loadCategories(vendorId);
    }

    _vendorWorker = ever<String>(
      vendorController.vendorId,
      (vendorId) {
        if (vendorId.isNotEmpty) {
          loadCategories(vendorId);
        }
      },
    );
  }

  Future<void> loadCategories(String vendorId) async {
    setState(() => loading = true);

    try {
      final response = await apiService.fetchCategories(vendorId);
      if (!mounted) return;

      categories = response?.data?.categories ?? [];

      _tabController?.dispose();
      _tabController = TabController(length: categories.length, vsync: this);

      setState(() => loading = false);
    } catch (e) {
      debugPrint("Category API error: $e");
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _vendorWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return  SizedBox(
        height: 120,
        child: Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),),
      );
    }

    if (categories.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text("No categories")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔥 CATEGORY TAB BAR
        SizedBox(
          height: 110,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 3,
            labelPadding: const EdgeInsets.symmetric(horizontal: 12),
            tabs: List.generate(categories.length, (index) {
              final item = categories[index];

              return Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          item.imageUrl ?? "",
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.category),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              );
            }),
          ),
        ),

        /// 🔥 TAB VIEW (CATEGORY DATA)
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: TabBarView(
            controller: _tabController,
            children: List.generate(categories.length, (index) {
              final category = categories[index];

              return AllSubCategory(
                subcategoryId: vendorController.vendorId.value,
                subcategoryName: category.name.toString(),
              );
            }),
          ),
        ),
      ],
    );
  }
}
