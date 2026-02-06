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
  bool _apiRunning = false;

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
    if (_apiRunning) return; // ✅ stop parallel calls
    _apiRunning = true;

    setState(() => loading = true);

    try {
      final res = await ProductService().getProducts(vendorId);
      if (!mounted) return;

      if (res != null && res.products.isNotEmpty) {
        setState(() => response = res);
      }
    } catch (e) {
      debugPrint("❌ Product API error: $e");
    } finally {
      if (mounted) setState(() => loading = false);
      _apiRunning = false;
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
        return SizedBox(
          height: 420,
          child: Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 120,
                height: 20,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
      return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    _header(context),
    const SizedBox(height: 10),
    loading ? _shimmerList() : _productList(),
  ],
);

  //     return SizedBox(
  // height: MediaQuery.of(context).size.height < 700 ? 310 : 380,

  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _header(context),
  //           const SizedBox(height: 10),
  //           Expanded(
  //             child: loading ? _shimmerList() : _productList(),
  //           ),
  //         ],
  //       ),
  //     );
    });
  }

// Widget _shimmerList() {
//   return ListView.separated(
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     scrollDirection: Axis.horizontal,
//     itemCount: 5,
//     separatorBuilder: (_, __) => const SizedBox(width: 16),
//     itemBuilder: (_, __) {
//       return SizedBox(
//         width: 220,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(18),
//           ),
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image shimmer
//               Container(
//                 height: 120,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               const SizedBox(height: 8),

//               // Title shimmer
//               Container(
//                 height: 12,
//                 width: 140,
//                 color: Colors.grey.shade300,
//               ),
//               const SizedBox(height: 6),

//               // Price shimmer
//               Container(
//                 height: 14,
//                 width: 100,
//                 color: Colors.grey.shade300,
//               ),
//               const SizedBox(height: 10),

//               // Button shimmer
//               Container(
//                 height: 38,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
Widget _shimmerList() {
  return ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    physics: const NeverScrollableScrollPhysics(), // 👈 if inside scroll view
    shrinkWrap: true,
    itemCount: 5,
    separatorBuilder: (_, __) => const SizedBox(height: 16),
    itemBuilder: (_, __) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 10),
            Container(height: 12, width: 160, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Container(height: 14, width: 120, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Container(
              height: 42,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      );
    },
  );
}



Widget _productList() {
  final items =
      response?.products.where((e) => e.product != null).toList() ?? [];

  if (items.isEmpty) {
    return const Center(child: Text("No products available"));
  }

  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // ✅ 2 items per row
      crossAxisSpacing: 12,
      mainAxisSpacing: 16,
      childAspectRatio: 0.65, // 👈 adjust card height
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return NexusProductCard(
        product: items[index].product!,
      );
    },
  );
}


  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "New Arrivals",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              final products = response?.products ?? [];
              if (products.isEmpty) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewAllProductsScreen(products: products),
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
