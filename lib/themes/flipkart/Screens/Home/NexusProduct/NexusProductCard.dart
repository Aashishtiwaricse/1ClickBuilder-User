import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Nexus/Modules/NexusProducts/NexusProduct.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProductById/productById.dart';

class NexusProductCard extends StatelessWidget {
  final Product product;

  const NexusProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final image = product.images.isNotEmpty ? product.images.first.image : "";

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
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: image == null || image.isEmpty
                  ? Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    )
                  : Image.network(
                      image,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported);
                      },
                    ),
            ),

            const SizedBox(height: 10),

            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: Colors.black),
            ),

            const SizedBox(height: 5),

            Row(
              children: [
                Text(
                  "₹${product.price}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.black),
                ),
                const SizedBox(width: 8),
                Text(
                  "₹${product.mrpPrice}",
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            Container(
              width: double.infinity,
              height: 40,
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xfff3c0e6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "BUY NOW",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
