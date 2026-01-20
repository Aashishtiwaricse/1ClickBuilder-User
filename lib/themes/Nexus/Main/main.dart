import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:one_click_builder/themes/Fuzzy/utility/plugin_list.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/Category/CategoryUIController.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/Search/searchControllers.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/cart_controller.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/guestCartController/guestCart.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/Screens/BottomNavCategory/bottoNavCategory.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Cart/NexusCart.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/home.dart';
import 'package:one_click_builder/themes/Nexus/Screens/SearchScreren/NexusSearchScreen.dart';
import 'package:one_click_builder/themes/Nexus/Screens/profile/screens/nexusProfileScreen.dart';
import 'package:one_click_builder/themes/Nexus/utility/app_theme.dart';

class NexusMain extends StatefulWidget {
  const NexusMain({super.key});

  @override
  State<NexusMain> createState() => _NexusMainState();
}

class _NexusMainState extends State<NexusMain> {
  int _selectedIndex = 0;
  bool _showSplash = true;
  final TextEditingController searchTextCtrl = TextEditingController();

  final NexusSearchController searchCtrl =
      Get.put(NexusSearchController(), permanent: true);
  DateTime? lastBackPressed;

  /// ✅ Pages
  final List<Widget> _pages = [
    const NexusHome(),
    const AllCategoriesScreen(),
    CartScreen(),
    const ProfileScreen(),
  ];

  /// ✅ GetX Controllers (GLOBAL)
  final NexusVendorController vendorCtrl = Get.find<NexusVendorController>();

  // @override
  // void initState() {
  //   super.initState();

  //   /// ✅ Register controllers once
  //   Get.put(CategoryUIController(), permanent: true);
  // final cartCtrl = Get.put(CartController(), permanent: true);

  //   /// ✅ Decide Vendor ID source
  //   ///   /// LOAD vendor from prefs
  // vendorCtrl.loadVendorFromStorage().then((_) async {
  //   final vendorId = vendorCtrl.vendorId.value;

  //   if (vendorId.isNotEmpty) {
  //     await cartCtrl.checkLogin(vendorId);
  //    // await cartCtrl.loadCart(vendorId);
  //   }
  // });



  

  //   /// ⏳ Splash delay (1 second)
  //   Future.delayed(const Duration(seconds: 2), () {
  //     if (mounted) {
  //       setState(() {
  //         _showSplash = false;
  //       });
  //     }
  //   });

  //     Get.put(GuestCartController());
  //     final prefs =  SharedPreferences.getInstance();
  // Get.put(prefs);
  // }

@override
void initState() {
  super.initState();
  initializeControllers();  // async setup
}
void initializeControllers() async {

  /// 👍 Register SharedPreferences correctly
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs, permanent: true);

  /// 👍 Register guest cart controller
  Get.put(GuestCartController(), permanent: true);

  /// 👍 Existing logic continues...
  Get.put(CategoryUIController(), permanent: true);
  final cartCtrl = Get.put(CartController(), permanent: true);

  vendorCtrl.loadVendorFromStorage().then((_) async {
    final vendorId = vendorCtrl.vendorId.value;
    if (vendorId.isNotEmpty) {
      await cartCtrl.checkLogin(vendorId);
    }
  });

  Future.delayed(const Duration(seconds: 2), () {
    if (mounted) {
      setState(() => _showSplash = false);
    }
  });
}



  Future<bool> onWillPop() async {
    final now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 5)) {
      lastBackPressed = now;

      // Show warning
      Get.snackbar(
        'Exit App',
        'Press again to exit',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Do not exit yet
    }
    return true; // Exit app
  }

  /// ✅ LOGIC:
  /// Logged in → SharedPreferences
  /// Not logged in → Existing Nexus controller value

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
    return WillPopScope(
      onWillPop: onWillPop,
      child: Theme(
        data: nexusTheme(),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Row(
              //  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0; // 🔥 Navigate to Home Screen
                      });
                    },
                    child: SizedBox(
                      height: 70,
                      width: 70,
                      child: vendorCtrl.logoUrl.value.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: ClipOval(
                                child: Image.network(
                                  vendorCtrl.logoUrl.value,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: searchTextCtrl, // ✅ ADD THIS
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) async {
                        if (value.trim().isEmpty) return;

                        searchCtrl.searchProduct(value);

                        // ✅ Wait for search screen to close
                        await Get.to(() => const SearchScreen());

                        // ✅ Clear text when coming back
                        searchTextCtrl.clear();
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
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              height: 80,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom > 0 ? 4 : 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.white,
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 13,
                unselectedFontSize: 12,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.category), label: "Categories"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart), label: "Cart"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: "Account"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
