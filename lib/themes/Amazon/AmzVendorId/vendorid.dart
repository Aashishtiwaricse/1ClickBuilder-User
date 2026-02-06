import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/utility/plugin_list.dart';

class AmzVendorController extends GetxController {
  /// Vendor ID
  final RxString vendorId = ''.obs;

  /// Logo URL
  final RxString logoUrl = ''.obs;

  /// Vendor loading state
  final RxBool loading = true.obs;

  /// Save all data at once
  Future<void> setVendorData({
    required String vendor,
    required String logo,
  }) async {
    vendorId.value = vendor;
    logoUrl.value = logo;
    loading.value = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vendor_id', vendor);
    await prefs.setString('vendor_logo', logo);

    print("✅ Vendor data saved to SharedPreferences");
  }

  /// Save only vendor ID
  Future<void> setVendorId(String id) async {
    vendorId.value = id;
    loading.value = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vendor_id', id);

    print("✅ Vendor ID saved: $id");
  }

  /// Load vendor ID on app start
  Future<void> loadVendorFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    vendorId.value = prefs.getString('vendor_id') ?? '';
    logoUrl.value = prefs.getString('vendor_logo') ?? '';
    loading.value = false;

    print("📦 Vendor loaded: ${vendorId.value}");
  }
}
