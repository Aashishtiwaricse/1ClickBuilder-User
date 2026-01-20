// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';

// /// ================== SCREEN ==================
// class OrderDetailsScreen extends StatefulWidget {
//   final String orderId;

//   const OrderDetailsScreen({super.key, required this.orderId});

//   @override
//   State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
// }

// class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
//   late Future<ShiprocketOrderResponse?> _future;

//   @override
//   void initState() {
//     super.initState();
//     _future = ShiprocketOrderApi.fetchOrderDetails(widget.orderId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           // ================= HEADER =================
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 56),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   "Order Details",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const Divider(height: 1),

//           // ================= CONTENT =================
//           Expanded(
//             child: FutureBuilder<ShiprocketOrderResponse?>(
//               future: _future,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return  Center(child:  Shimmer.fromColors(
//     baseColor: Colors.grey.shade300,
//     highlightColor: Colors.grey.shade100,
//     child: Container(
//       width: 120,
//       height: 20,
//       color: Colors.white,
//     ),
//   ),);
//                 }

//                 // ❌ No error text shown
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: Text(
//                       "Order details not available",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   );
//                 }

//                 final order = snapshot.data!;
//                 return _orderContent(order);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ================= ORDER UI =================
//   Widget _orderContent(ShiprocketOrderResponse order) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _infoTile("Order ID", order.orderId),
//           _infoTile("Status", order.userStatus ?? "Pending"),
//           _infoTile("Created", order.createdAt),
//           const SizedBox(height: 16),

//           const Text(
//             "Items",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),

//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: order.items.length,
//             itemBuilder: (context, index) {
//               return _itemCard(order.items[index]);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoTile(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               title,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }

//   Widget _itemCard(ShiprocketItem item) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _productImage(item.productImageId),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Product ID: ${item.productId}",
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 4),
//                   Text("Status: ${item.status ?? "Pending"}"),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _productImage(String? imageId) {
//     if (imageId == null || imageId.isEmpty) {
//       return _imagePlaceholder();
//     }

//     final url =
//         "https://storage.googleapis.com/1clickbuilder-new2/$imageId";

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(8),
//       child: Image.network(
//         url,
//         width: 70,
//         height: 70,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) => _imagePlaceholder(),
//       ),
//     );
//   }

//   Widget _imagePlaceholder() {
//     return Container(
//       width: 70,
//       height: 70,
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: const Icon(Icons.image_not_supported),
//     );
//   }
// }

// /// ================== API ==================
// class ShiprocketOrderApi {
//   static Future<ShiprocketOrderResponse?> fetchOrderDetails(
//       String orderId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';

//       final url =
//           "https://api.1clickbuilder.com/api/shiprocket/get-order-details/$orderId";

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           "Authorization": token,
//           "Accept": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         return ShiprocketOrderResponse.fromJson(
//           jsonDecode(response.body),
//         );
//       }

//       return null; // ❌ no throw
//     } catch (e) {
//       debugPrint("❌ order details error => $e");
//       return null;
//     }
//   }
// }

// /// ================== MODEL ==================
// class ShiprocketOrderResponse {
//   final String orderId;
//   final String createdAt;
//   final String? userStatus;
//   final List<ShiprocketItem> items;

//   ShiprocketOrderResponse({
//     required this.orderId,
//     required this.createdAt,
//     required this.items,
//     this.userStatus,
//   });

//   factory ShiprocketOrderResponse.fromJson(Map<String, dynamic> json) {
//     final data = json['data'];

//     return ShiprocketOrderResponse(
//       orderId: data['order_id'] ?? '',
//       createdAt: data['created_at'] ?? '',
//       userStatus: data['user_status'],
//       items: (data['items'] as List? ?? [])
//           .map((e) => ShiprocketItem.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class ShiprocketItem {
//   final String productId;
//   final String? status;
//   final String? productImageId;

//   ShiprocketItem({
//     required this.productId,
//     this.status,
//     this.productImageId,
//   });

//   factory ShiprocketItem.fromJson(Map<String, dynamic> json) {
//     return ShiprocketItem(
//       productId: json['product_id'] ?? '',
//       status: json['status'],
//       productImageId: json['productImageId'],
//     );
//   }
// }
