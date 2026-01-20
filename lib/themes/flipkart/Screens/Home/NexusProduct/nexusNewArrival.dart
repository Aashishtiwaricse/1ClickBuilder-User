import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:one_click_builder/themes/Nexus/Modules/NexusProducts/NexusProduct.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProduct/NexusProductCard.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProduct/viewallProductr.dart';
import 'package:one_click_builder/themes/Nexus/api/NexusProduct/nexusProduct.dart';
import 'package:shimmer/shimmer.dart';



class NewArrivalSection extends StatefulWidget {
  const NewArrivalSection({super.key});

  @override
  State<NewArrivalSection> createState() => _NewArrivalSectionState();
}

class _NewArrivalSectionState extends State<NewArrivalSection> {
  ProductListResponse? response;
  bool loading = false;

  final NexusVendorController vendorController =
      Get.find<NexusVendorController>();

  Worker? _vendorWorker;
  String? _lastVendorId;

  @override
  void initState() {
    super.initState();

    // Try loading immediately if vendorId already exists
    _tryLoad(vendorController.vendorId.value);

    // Listen ONLY when vendorId actually changes
    _vendorWorker = ever<String>(
      vendorController.vendorId,
      (vendorId) => _tryLoad(vendorId),
    );
  }

  void _tryLoad(String vendorId) {
    if (vendorId.isEmpty) return;
    if (vendorId == _lastVendorId) return;

    _lastVendorId = vendorId;
    _loadProducts(vendorId);
  }

  Future<void> _loadProducts(String vendorId) async {
    setState(() => loading = true);

    try {
      final res = await ProductService().getProducts(vendorId);
      if (!mounted) return;

      setState(() {
        response = res;
        loading = false;
      });
    } catch (e) {
      debugPrint("Product API error: $e");
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _vendorWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final vendorId = vendorController.vendorId.value;

      // ⏳ Vendor not ready yet
      if (vendorId.isEmpty) {
        return  SizedBox(
          height: 420,
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

      return SizedBox(
        height: 370,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(height: 10),
            Expanded(
              child: loading
                  ?  Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),)
                  : _productList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _productList() {
    final items = response?.products ?? [];

    if (items.isEmpty) {
      return const Center(child: Text("No products available"));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 16),
      itemBuilder: (context, index) {
        return SizedBox(
          width: 220,
        //  height: 100,
          child: NexusProductCard(product: items[index].product!),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "New Arrivals",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              if (response == null) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ViewAllProductsScreen(products: response!.products),
                ),
              );
            },
            child: const Text(
              "View More >",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
