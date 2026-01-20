import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Nexus/Modules/BestSellers/bestSellers.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProductById/productById.dart';
class ProductCard extends StatelessWidget {
  final Product product;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.product,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductByIdScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(10),

        // ✅ IMPORTANT
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🖼 IMAGE — FLEXIBLE
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: imageUrl.isEmpty
                    ? Container(
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image_outlined,
                              size: 40, color: Colors.grey),
                        ),
                      )
                    : Image.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 40),
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 8),

            // 🏷 TITLE
            Text(
              (product.title ?? "").toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 4),

            // 💰 PRICE
            Row(
              children: [
                Text(
                  "₹${product.salePrice}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    "₹${product.price}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

   const SizedBox(height: 5),
            // 🛒 BUTTON (STABLE)
            SizedBox(
              height: 38,
              width: double.infinity,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xfff3c0e6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "BUY NOW",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
