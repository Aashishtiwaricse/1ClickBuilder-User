// import 'package:flutter/material.dart';
// import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProduct/NexusProductCard.dart';

// import '../../../Modules/NexusProducts/NexusProduct.dart';


// class ViewAllProductsScreen extends StatelessWidget {
//   final List<ProductData> products;

//   const ViewAllProductsScreen({super.key, required this.products});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("All Products")),

//       body: GridView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: products.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.51,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//         ),
//         itemBuilder: (context, index) {
//           final product = products[index].product;
//           return NexusProductCard(product: product);
//         },
//       ),
//     );
//   }
// }
