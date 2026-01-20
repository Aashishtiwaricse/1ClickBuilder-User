import 'package:get/get.dart';

class NexusVendorController extends GetxController {
  /// Vendor ID
  final RxString vendorId = ''.obs;

  /// Logo URL
  final RxString logoUrl = ''.obs;

  /// Vendor loading state
  final RxBool loading = true.obs;

  /// Save all data at once
  void setVendorData({
    required String vendor,
    required String logo,
  }) {
    vendorId.value = vendor;
    logoUrl.value = logo;
    loading.value = false; // ✅ vendor ready
  }

  /// Set only vendor ID
  void setVendorId(String id) {
    vendorId.value = id;
    loading.value = false; // ✅ vendor readya
  }
}
