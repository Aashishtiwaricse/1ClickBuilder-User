import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/product/productController.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/BestSellerScreen/flipkartBestSeller.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/FlipkartProduct/flipkartNewArrival.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/NexusProductById/productById.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/flipkartBanners.dart';
import 'package:one_click_builder/themes/Flipkart/api/Categoryalist/categoryList.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategoryTabs extends StatefulWidget {
  const HomeCategoryTabs({super.key});

  @override
  State<HomeCategoryTabs> createState() => _HomeCategoryTabsState();
}

class _HomeCategoryTabsState extends State<HomeCategoryTabs>
    with SingleTickerProviderStateMixin {
  final api = FlipkartCategoryApiService();
  final vendorController = Get.find<FlipkartVendorController>();
  final ProductController productCtrl = Get.find<ProductController>();

  List categories = [];
  bool loading = true;
  late TabController _tabController;

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
    if (vendorId.isEmpty) return;

    setState(() => loading = true);

    final res = await api.fetchCategories(vendorId);
    categories = res?.data?.categories ?? [];

    if (categories.isNotEmpty) {
      _tabController = TabController(
        length: categories.length,
        vsync: this,
      );

      // 🔥 LOAD FIRST CATEGORY BY DEFAULT
      productCtrl.loadProducts(
        vendorId: vendorId,
        search: categories.first.name.toString(),
      );

      _tabController.addListener(() {
        if (_tabController.indexIsChanging) return;

        final selectedCategory = categories[_tabController.index];
        productCtrl.loadProducts(
          vendorId: vendorId,
          search: selectedCategory.name.toString(),
        );
      });
    }

    setState(() => loading = false);
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

    return Column(
      children: [
        Container(
            height: 80, // 👈 keep this
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              splashFactory: NoSplash.splashFactory, // 🚫 no ripple
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              dividerColor: Colors.transparent,

              // 🔵 Flipkart blue
              labelColor: const Color(0xFF2874F0),
              unselectedLabelColor: Colors.grey.shade600,

              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),

              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 3,
                  color: Color(0xFF2874F0),
                ),
                insets: EdgeInsets.symmetric(horizontal: 14),
              ),

              labelPadding: const EdgeInsets.symmetric(horizontal: 14),

              tabs: categories.map<Tab>((c) {
                return Tab(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              Colors.grey.shade100, // neutral bg like Flipkart
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: c.imageUrl != null
                            ? Image.network(c.imageUrl!, height: 24)
                            : const Icon(Icons.category, size: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        c.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
            )),
            Container(
  height: 1,
  color: const Color(0xFFE0E0E0), // Flipkart light grey
),


        /// 🔥 TAB CONTENT
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: TabBarView(
            controller: _tabController,
            children: categories.map<Widget>((c) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlipkartBannerScreen(),
                      ),
                    ),
                    Obx(() {
                      if (productCtrl.loading.value) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (_, __) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (productCtrl.products.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: Text("No products found")),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        itemCount: productCtrl.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 165, // ⭐ controls card height exactly
                        ),
                        itemBuilder: (_, index) {
                          final product = productCtrl.products[index].product;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductByIdScreen(
                                      productId: product!.id.toString()),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xffF3F6FB),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      product?.images?.first.image ??
                                          product?.product_image ??
                                          '',
                                      height: 95,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    product?.productName ??
                                        product?.title ??
                                        '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    NewArrivalSection(),
                    const SizedBox(height: 20),
                    BestSellerScreen(),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
