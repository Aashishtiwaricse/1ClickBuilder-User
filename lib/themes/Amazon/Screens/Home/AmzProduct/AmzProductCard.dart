// import 'package:flutter/material.dart';
// import 'package:one_click_builder/themes/Amazon/Modules/AmzProducts/AmzProduct.dart';
// import 'package:one_click_builder/themes/Amazon/Screens/Home/AmzProductById/productById.dart';
//
// class AmzProductCard extends StatelessWidget {
//   final Product product;
//
//   const AmzProductCard({super.key, required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     final image = product.images.isNotEmpty ? product.images.first.image : "";
//
//     final String? firstSizePrice =
//         product.images.isNotEmpty && product.images.first.sizes.isNotEmpty
//             ? product.images.first.sizes.first.price
//             : null;
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ProductByIdScreen(productId: product.id),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             )
//           ],
//         ),
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // IMAGE - fixed height
//             (image.isEmpty)
//                 ? Container(
//                     height: 120,
//                     width: double.infinity,
//                     color: Colors.grey.shade200,
//                     child: const Icon(Icons.image_outlined,
//                         size: 50, color: Colors.grey),
//                   )
//                 : Expanded(
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         image,
//                        // height: 120,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return Container(
//                          //   height: 120,
//                             width: double.infinity,
//                             color: Colors.grey.shade200,
//                             child: const Center(
//                               child: CircularProgressIndicator(strokeWidth: 2),
//                             ),
//                           );
//                         },
//                         errorBuilder: (context, error, stackTrace) => Container(
//                           height: 120,
//                           width: double.infinity,
//                           color: Colors.grey.shade200,
//                           child: const Icon(
//                             Icons.broken_image_outlined,
//                             size: 50,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ),
//
//             const SizedBox(height: 10),
//
//             // TITLE + PRICE - Expanded to fill space
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   product.title,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12,
//                       color: Colors.black),
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     // Selling price (String)
//                     if (firstSizePrice != null)
//                       Text(
//                         "₹$firstSizePrice",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.black,
//                         ),
//                       ),
//
//                     const SizedBox(width: 8),
//
//                     // Original price (double)
//                     if (product.discountPrice != null)
//                       Text(
//                         "₹${product.discountPrice!.toStringAsFixed(0)}",
//                         style: const TextStyle(
//                           decoration: TextDecoration.lineThrough,
//                           color: Colors.grey,
//                         ),
//                       ),
//
//                     const SizedBox(width: 8),
//
//                     // 🔥 Show discount % only if discount exists
//                     if (firstSizePrice != null && product.discountPrice != null)
//                       (() {
//                         final double sellingPrice =
//                             double.tryParse(firstSizePrice!) ?? 0;
//
//                         final double originalPrice = product.discountPrice!;
//
//                         // No discount → hide
//                         if (originalPrice <= sellingPrice) {
//                           return const SizedBox.shrink();
//                         }
//
//                         // Calculate discount %
//                         final double percent =
//                             ((originalPrice - sellingPrice) / originalPrice) *
//                                 100;
//
//                         return Row(
//                           children: [
//                             const Icon(Icons.arrow_downward,
//                                 color: Colors.green, size: 14),
//                             Text(
//                               "${percent.toStringAsFixed(0)}% OFF",
//                               style: const TextStyle(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         );
//                       })(),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//
//             // BUY NOW BUTTON - fixed height
//             Container(
//               width: double.infinity,
//               height: 40,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: const Color(0xfff3c0e6),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Text(
//                 "BUY NOW",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Amazon/Modules/AmzProducts/AmzProduct.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/AmzProductById/productById.dart';

class AmzProductCard extends StatelessWidget {
  final Product product;

  const AmzProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final image =
    product.images.isNotEmpty ? product.images.first.image : "";

    final String? firstSizePrice =
    product.images.isNotEmpty && product.images.first.sizes.isNotEmpty
        ? product.images.first.sizes.first.price
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AmzProductByIdScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔴 DEAL TAG (Amazon style)
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "Deal",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // 🖼 IMAGE + ADD BUTTON
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: image.isEmpty
                        ? Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_outlined,
                          size: 50, color: Colors.grey),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        image,
                        fit: BoxFit.contain,
                        loadingBuilder:
                            (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ➕ ADD BUTTON (Amazon)
                  // Positioned(
                  //   bottom: 4,
                  //   right: 4,
                  //   child: CircleAvatar(
                  //     radius: 16,
                  //     backgroundColor: Colors.amber,
                  //     child: const Icon(Icons.add, size: 18),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // 📝 TITLE
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            // 💰 PRICE ROW
            Row(
              children: [
                if (firstSizePrice != null)
                  Text(
                    "₹$firstSizePrice",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(width: 6),
                if (product.discountPrice != null)
                  Text(
                    "₹${product.discountPrice!.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),

            // 🔥 DISCOUNT %
            if (firstSizePrice != null && product.discountPrice != null)
              (() {
                final double selling =
                    double.tryParse(firstSizePrice!) ?? 0;
                final double original = product.discountPrice!;

                if (original <= selling) return const SizedBox.shrink();

                final percent =
                    ((original - selling) / original) * 100;

                return Text(
                  "-${percent.toStringAsFixed(0)}%",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              })(),

            const Text(
              "Limited time deal",
              style: TextStyle(
                fontSize: 11,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

