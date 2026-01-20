import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:one_click_builder/themes/Nexus/Modules/Nexus-Sub-Category/Nexus-sub-Category.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProductById/productById.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../api/SubCategory/nexusGetSubCategory.dart';

class AllSubCategory extends StatefulWidget {
  final String subcategoryId;
  final String subcategoryName;

  const AllSubCategory({
    super.key,
    required this.subcategoryId,
    required this.subcategoryName,
  });

  @override
  State<AllSubCategory> createState() => _AllSubCategoryState();
}

class _AllSubCategoryState extends State<AllSubCategory> {
  bool loading = true;
  List<ProductData> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse("0x$hex"));
  }

  Future<void> fetchProducts() async {
    final api = ProductApiService();
    final vendorId = Get.find<NexusVendorController>().vendorId.value;

    final response = await api.fetchProducts(
      categoryId: vendorId,
      search: widget.subcategoryName,
    );

    setState(() {
      products = response;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subcategoryName)),
      body: loading
          ?  Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),)
          : Row(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 390,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, i) => _buildProductCard(products[i]),
                  ),
                ),
              ],
            ),
    );
  }

  // ------------------------------------------------------------
  // FIXED PRODUCT CARD → FULL NULL SAFETY
  // ------------------------------------------------------------
  Widget _buildProductCard(ProductData item) {
    final product = item.product;

    final String title = product!.title ?? "No Title";

    List<String> allColors = [];

    if (product.images != null && product.images!.isNotEmpty) {
      for (var img in product.images!) {
        if (img.colors != null && img.colors!.isNotEmpty) {
          allColors.addAll(img.colors!);
        }
      }
    }

// Remove duplicates
    allColors = allColors.toSet().toList();

    // ---------------- SAFE IMAGE ----------------
    final String imageUrl = product.images != null &&
            product!.images!.isNotEmpty &&
            product.images!.first.image != null
        ? product.images!.first.image!
        : "";

    // ---------------- SAFE PRICE ----------------
    int price = 0;

    if (product!.images != null &&
        product.images!.isNotEmpty &&
        product.images!.first.sizes != null &&
        product.images!.first.sizes!.isNotEmpty) {
      price =
          int.tryParse(product.images!.first.sizes!.first.price ?? "0") ?? 0;
    } else {
      price = product.price ?? 0;
    }

    final int mrp = product.price ?? price;
    final int discount =
        mrp > price ? (((mrp - price) / mrp) * 100).round() : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductByIdScreen(productId: product.id.toString()),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image, size: 60, color: Colors.grey),
              ),
            ),

            // TITLE
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            // PRICE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    "₹$price",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  if (mrp > price)
                    Text(
                      "₹$mrp",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (discount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "$discount% OFF",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.02),

            // COLORS
         allColors.isNotEmpty
    ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: allColors.map((colorHex) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black26, width: 1),
                color: _hexToColor(colorHex),
              ),
            );
          }).toList(),
        ),
      )
    : const SizedBox(height: 28), // <-- Keep fixed height when empty


            SizedBox(height: MediaQuery.of(context).size.width * 0.03),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Color(0xfff3c0e6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Text(
                      "BUY NOW",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
