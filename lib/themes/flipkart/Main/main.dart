import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:one_click_builder/themes/Fuzzy/utility/plugin_list.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/Category/CategoryUIController.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/Search/searchControllers.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/cart_controller.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/Screens/BottomNavCategory/bottoNavCategory.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Cart/NexusCart.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/home.dart';
import 'package:one_click_builder/themes/Nexus/Screens/SearchScreren/NexusSearchScreen.dart';
import 'package:one_click_builder/themes/Nexus/Screens/profile/screens/nexusProfileScreen.dart';
import 'package:one_click_builder/themes/Nexus/utility/app_theme.dart';
import 'package:one_click_builder/themes/flipkart/Screens/Home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FlipkartMain extends StatefulWidget {
  const FlipkartMain({super.key});

  @override
  State<FlipkartMain> createState() => _FlipkartMainState();
}

class _FlipkartMainState extends State<FlipkartMain> {
  int _selectedIndex = 0;
  bool _showSplash = true;
final NexusSearchController searchCtrl =
    Get.put(NexusSearchController(), permanent: true);


  /// ✅ Pages
  final List<Widget> _pages = [
    const FlipkartHome(),
    const AllCategoriesScreen(),
    CartScreen(),
    const ProfileScreen(),
  ];

  /// ✅ GetX Controllers (GLOBAL)
  final NexusVendorController vendorCtrl =
      Get.find<NexusVendorController>();

  @override
void initState() {
  super.initState();

  /// ✅ Register controllers once
  Get.put(CategoryUIController(), permanent: true);
  Get.put(CartController(), permanent: true);

  /// ✅ Decide Vendor ID source
  saveVendorIdToGetX();

  /// ⏳ Splash delay (1 second)
  Future.delayed(const Duration(seconds: 2), () {
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  });
}

  /// ✅ LOGIC:
  /// Logged in → SharedPreferences
  /// Not logged in → Existing Nexus controller value
  Future<void> saveVendorIdToGetX() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString('user_id');

    if (savedUserId != null && savedUserId.isNotEmpty) {
      vendorCtrl.setVendorId(savedUserId);
      debugPrint("✅ Vendor ID from SharedPreferences: $savedUserId");
    } else {
      debugPrint(
        "⚠️ Vendor ID from Nexus controller: ${vendorCtrl.vendorId.value}",
      );
    }
  }

@override
Widget build(BuildContext context) {
  /// 🔥 SPLASH SCREEN
  if (_showSplash) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SizedBox.expand(
      child: Image.asset(
        'assets/nexus.png',
        fit: BoxFit.cover, // 🔥 FULL SCREEN
      ),
    ),
  );
}


  /// 🔥 MAIN APP UI (Bottom Nav)
  return Theme(
    data: nexusTheme(),
    child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: Row(
          children: [
            Obx(
              () => SizedBox(
                height: 35,
                child: vendorCtrl.logoUrl.value.isNotEmpty
                    ? Image.network(
                        vendorCtrl.logoUrl.value,
                        fit: BoxFit.contain,
                      )
                    : const SizedBox(),
              ),
            ),
            const SizedBox(width: 10),
          Expanded(
  child: Container(
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFF6F2FF),
      borderRadius: BorderRadius.circular(25),
    ),
    child: TextField(
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        if (value.trim().isEmpty) return;

        searchCtrl.searchProduct(value);
        Get.to(() => SearchScreen());
      },
      decoration: const InputDecoration(
        hintText: "Search products...",
        border: InputBorder.none,
        icon: Icon(Icons.search, color: Color(0xFF6B6B6B)),
      ),
    ),
  ),
),

          ],
        ),
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    ),
  );
}


}
