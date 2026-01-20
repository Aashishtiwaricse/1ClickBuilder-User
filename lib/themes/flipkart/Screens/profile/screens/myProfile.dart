import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/profile/profileController.dart';
import 'package:one_click_builder/themes/Nexus/Screens/profile/screens/orderDetails.dart';
import 'package:shimmer/shimmer.dart';

class ProfileDashboardScreen extends StatelessWidget {
  ProfileDashboardScreen({super.key});

  final ProfileOrdersController controller = Get.put(ProfileOrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F9),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return  Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileCard(),
              const SizedBox(height: 16),
              _statsGrid(),
              const SizedBox(height: 24),
              const Text(
                "Recent Orders",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _ordersList(),
            ],
          ),
        );
      }),
    );
  }

  // =======================================================
  // PROFILE CARD
  // =======================================================
  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: controller.avatar.isNotEmpty
                ? NetworkImage(controller.avatar)
                : null,
            child: controller.avatar.isEmpty
                ? const Icon(Icons.person, size: 36)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.userName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.userEmail,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // =======================================================
  // STATS GRID (3 CARDS)
  // =======================================================
  Widget _statsGrid() {
    return Row(
      children: [
        _statCard(
          title: "Awaiting Pickup",
          value: controller.awaitingPickup.toString(),
          icon: Icons.hourglass_bottom,
        ),
        const SizedBox(width: 10),
        _statCard(
          title: "Cancelled",
          value: controller.cancelledOrders.toString(),
          icon: Icons.cancel_outlined,
        ),
        const SizedBox(width: 10),
        _statCard(
          title: "Total Orders",
          value: controller.totalOrders.toString(),
          icon: Icons.inventory_2_outlined,
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 2,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
  void _openOrderItems(BuildContext context, String orderId) {
  // showModalBottomSheet(
  //   context: context,
  //   isScrollControlled: true,
  //   backgroundColor: Colors.white,
  //   shape: const RoundedRectangleBorder(
  //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //   ),
  //   builder: (_) => 
  // );
}


  // =======================================================
  // ORDERS LIST
  // =======================================================
  Widget _ordersList() {
    return ListView.builder(
      itemCount: controller.orders.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final order = controller.orders[index];
        final product = order.products.isNotEmpty ? order.products.first : null;
        final imageUrl = product != null &&
                product.images.isNotEmpty &&
                product.images.first.image.isNotEmpty
            ? product.images.first.image
            : null;

        return GestureDetector(
                  onTap: () {
          _openOrderItems(context, order.orderId);
        },

          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          height: 72,
                          width: 72,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 72,
                          width: 72,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?.name ?? "Product",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product?.category ?? "",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text("${order.items} items"),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat("dd MMM yyyy, hh:mm a")
                            .format(order.createdAt),
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${order.price}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      order.status,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _statusColor(order.status),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =======================================================
  // STATUS COLOR
  // =======================================================
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
