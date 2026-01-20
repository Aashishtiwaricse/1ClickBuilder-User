import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/profile/cancrellationPolicy.dart';
import 'package:shimmer/shimmer.dart';

class CancellationPolicyScreen extends StatelessWidget {
  CancellationPolicyScreen({super.key});

  final controller = Get.put(CancellationPolicyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancellation Policy'),
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

        final policy = controller.policy.value;

        if (policy == null) {
          return const Center(child: Text('No policy available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Html(
            data: policy.content,
          ),
        );
      }),
    );
  }
}
