import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Nexus/Modules/NexusProducts/NexusProduct.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProductById/productById.dart';

class NexusProductCard extends StatelessWidget {
  final Product product;

  const NexusProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final image = product.images.isNotEmpty ? product.images.first.image : "";

    final String? firstSizePrice =
        product.images.isNotEmpty && product.images.first.sizes.isNotEmpty
            ? product.images.first.sizes.first.price
            : null;

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
              offset: Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE - fixed height
            (image.isEmpty)
                ? Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_outlined,
                        size: 50, color: Colors.grey),
                  )
                : Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        image,
                       // height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                         //   height: 120,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 120,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                ),

            const SizedBox(height: 10),

            // TITLE + PRICE - Expanded to fill space
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    // Selling price (String)
                    if (firstSizePrice != null)
                      Text(
                        "₹$firstSizePrice",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),

                    const SizedBox(width: 8),

                    // Original price (double)
                    if (product.discountPrice != null)
                      Text(
                        "₹${product.discountPrice!.toStringAsFixed(0)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),

                    const SizedBox(width: 8),

                    // 🔥 Show discount % only if discount exists
                    if (firstSizePrice != null && product.discountPrice != null)
                      (() {
                        final double sellingPrice =
                            double.tryParse(firstSizePrice!) ?? 0;

                        final double originalPrice = product.discountPrice!;

                        // No discount → hide
                        if (originalPrice <= sellingPrice) {
                          return const SizedBox.shrink();
                        }

                        // Calculate discount %
                        final double percent =
                            ((originalPrice - sellingPrice) / originalPrice) *
                                100;

                        return Row(
                          children: [
                            const Icon(Icons.arrow_downward,
                                color: Colors.green, size: 14),
                            Text(
                              "${percent.toStringAsFixed(0)}% OFF",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      })(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // BUY NOW BUTTON - fixed height
            Container(
              width: double.infinity,
              height: 40,
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
          ],
        ),
      ),
    );
  }
}
