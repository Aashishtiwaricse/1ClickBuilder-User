import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/api/profile/about.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Nexus/Modules/profile/aboutUs.dart';
import 'package:shimmer/shimmer.dart';

class NexusAboutScreen extends StatefulWidget {
  const NexusAboutScreen({super.key});

  @override
  State<NexusAboutScreen> createState() => _NexusAboutScreenState();
}

class _NexusAboutScreenState extends State<NexusAboutScreen> {
  final NexusVendorController vendorCtrl = Get.find<NexusVendorController>();

  bool isLoading = true;
  AboutResponse? aboutData;
  late Worker vendorWorker;

  @override
  void initState() {
    super.initState();

    // If vendor already loaded before screen opens
    if (!vendorCtrl.loading.value &&
        vendorCtrl.vendorId.value.isNotEmpty) {
      _loadAbout(vendorCtrl.vendorId.value);
    }

    // Listen for vendor readiness
    vendorWorker = ever<String>(
      vendorCtrl.vendorId,
      (vendorId) {
        if (vendorId.isNotEmpty) {
          _loadAbout(vendorId);
        }
      },
    );
  }

  Future<void> _loadAbout(String vendorId) async {
    try {
      setState(() => isLoading = true);
      aboutData = await AboutService.fetchAbout(vendorId);
      debugPrint("About API called for vendorId: $vendorId");
    } catch (e) {
      aboutData = null;
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    vendorWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: isLoading
          ?  Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),)
          : aboutData == null
              ? const Center(child: Text("No data available"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aboutData!.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        aboutData!.content,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
