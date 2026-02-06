// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:one_click_builder/themes/Amazon/Controllers/Category/CategoryUIController.dart';
// import 'package:one_click_builder/themes/Amazon/Controllers/Search/searchControllers.dart';
// import 'package:one_click_builder/themes/Amazon/Controllers/cart_controller.dart';
// import 'package:one_click_builder/themes/Amazon/Controllers/guestCartController/guestCart.dart';
// import 'package:one_click_builder/themes/Amazon/Screens/BottomNavCategory/bottoNavCategory.dart';
// import 'package:one_click_builder/themes/Amazon/Screens/Cart/AmzCart.dart';
// import 'package:one_click_builder/themes/Amazon/Screens/Home/home.dart';
// import 'package:one_click_builder/themes/Amazon/Screens/SearchScreren/AmzSearchScreen.dart';
// import 'package:one_click_builder/themes/Amazon/Screens/profile/screens/AmzProfileScreen.dart';
// import 'package:one_click_builder/themes/Amazon/utility/app_theme.dart';
//
// import '../Controllers/profile/profileController.dart';
// import '../NexusVendorId/vendorid.dart';
// import '../utility/plugin_list.dart';
//
// class AmzMain extends StatefulWidget {
//   const AmzMain({super.key});
//
//   @override
//   State<AmzMain> createState() => _AmzMainState();
// }
//
// class _AmzMainState extends State<AmzMain> {
//   int _selectedIndex = 0;
//   bool _showSplash = true;
//   final TextEditingController searchTextCtrl = TextEditingController();
//
//   final NexusSearchController searchCtrl =
//       Get.put(NexusSearchController(), permanent: true);
//   DateTime? lastBackPressed;
//
//   /// ✅ Pages
//   final List<Widget> _pages = [
//     const AmzHome(),
//     const AllCategoriesScreen(),
//     AmzCartScreen(),
//     const ProfileScreen(),
//   ];
//
//   /// ✅ GetX Controllers (GLOBAL)
//   final NexusVendorController vendorCtrl = Get.find<NexusVendorController>();
//
//
//
// @override
// void initState() {
//   super.initState();
//   initializeControllers();  // async setup
// }
//
// void initializeControllers() async {
//
//   /// 👍 Register SharedPreferences correctly
//   final prefs = await SharedPreferences.getInstance();
//   Get.put<SharedPreferences>(prefs, permanent: true);
//
//   /// 👍 Register guest cart controller
//   Get.put(GuestCartController(), permanent: true);
//   Get.put(ProfileOrdersController(), permanent: true);
//   // Get.put(CartController(), permanent: true);
//
//   /// 👍 Existing logic continues...
//   Get.put(CategoryUIController(), permanent: true);
//   final cartCtrl = Get.put(AmzCartController(), permanent: true);
//
//   vendorCtrl.loadVendorFromStorage().then((_) async {
//     final vendorId = vendorCtrl.vendorId.value;
//     if (vendorId.isNotEmpty) {
//       await cartCtrl.checkLogin(vendorId);
//     }
//   });
//
//   Future.delayed(const Duration(seconds: 2), () {
//     if (mounted) {
//       setState(() => _showSplash = false);
//     }
//   });
// }
//
//
//
//   Future<bool> onWillPop() async {
//     final now = DateTime.now();
//     if (lastBackPressed == null ||
//         now.difference(lastBackPressed!) > const Duration(seconds: 5)) {
//       lastBackPressed = now;
//
//       // Show warning
//       Get.snackbar(
//         'Exit App',
//         'Press again to exit',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return false; // Do not exit yet
//     }
//     return true; // Exit app
//   }
//
//   /// ✅ LOGIC:
//   /// Logged in → SharedPreferences
//   /// Not logged in → Existing Nexus controller value
//
//   @override
//   Widget build(BuildContext context) {
//     /// 🔥 SPLASH SCREEN
//     if (_showSplash) {
//       return Scaffold(
//         backgroundColor: Colors.white,
//         body: SizedBox.expand(
//           child: Image.asset(
//             'assets/nexus.png',
//             fit: BoxFit.cover, // 🔥 FULL SCREEN
//           ),
//         ),
//       );
//     }
//
//     /// 🔥 MAIN APP UI (Bottom Nav)
//     return WillPopScope(
//       onWillPop: onWillPop,
//       child: Theme(
//         data: AmzTheme(),
//         child: Scaffold(
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           appBar: AppBar(
//             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//             title: Container(
//               height: 46,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.12),
//                     blurRadius: 8,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 controller: searchTextCtrl,
//                 textInputAction: TextInputAction.search,
//                 onSubmitted: (value) async {
//                   if (value.trim().isEmpty) return;
//
//                   searchCtrl.searchProduct(value);
//                   await Get.to(() => const SearchScreen());
//                   searchTextCtrl.clear();
//                 },
//                 decoration: InputDecoration(
//                   contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                   border: InputBorder.none,
//
//                   // 🔍 LEFT SEARCH ICON (AMAZON STYLE)
//                   prefixIcon: const Icon(
//                     Icons.search,
//                     color: Colors.black54,
//                   ),
//
//                   hintText: "Search Here...",
//                   hintStyle: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.black45,
//                   ),
//
//                   // 📷 CAMERA ICON (optional – looks very Amazon)
//                   suffixIcon: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       // Icon(Icons.camera_alt_outlined, color: Colors.black54),
//                       // SizedBox(width: 10),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           body: _pages[_selectedIndex],
//           bottomNavigationBar: SafeArea(
//             top: false,
//             child: Container(
//               height: 80,
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).padding.bottom > 0 ? 4 : 8,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.06),
//                     blurRadius: 12,
//                     offset: const Offset(0, -2),
//                   )
//                 ],
//               ),
//               child: BottomNavigationBar(
//                 elevation: 0,
//                 backgroundColor: Colors.white,
//                 currentIndex: _selectedIndex,
//                 onTap: (index) => setState(() => _selectedIndex = index),
//                 type: BottomNavigationBarType.fixed,
//                 selectedFontSize: 13,
//                 unselectedFontSize: 12,
//                 items: const [
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.home), label: "Home"),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.category), label: "Categories"),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.shopping_cart), label: "Cart"),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.person), label: "Account"),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/Category/CategoryUIController.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/Search/searchControllers.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/cart_controller.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/guestCartController/guestCart.dart';
import 'package:one_click_builder/themes/Amazon/Screens/BottomNavCategory/bottoNavCategory.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Cart/AmzCart.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/home.dart';
import 'package:one_click_builder/themes/Amazon/Screens/SearchScreren/AmzSearchScreen.dart';
import 'package:one_click_builder/themes/Amazon/Screens/profile/screens/AmzProfileScreen.dart';
import 'package:one_click_builder/themes/Amazon/utility/app_theme.dart';
import '../Controllers/profile/profileController.dart';
import '../NexusVendorId/vendorid.dart';
import '../utility/plugin_list.dart';

class AmzMain extends StatefulWidget {
  const AmzMain({super.key});

  @override
  State<AmzMain> createState() => _AmzMainState();
}

class _AmzMainState extends State<AmzMain> {
  int _selectedIndex = 0;
  bool _showSplash = true;

  final TextEditingController searchTextCtrl = TextEditingController();
  final NexusSearchController searchCtrl =
  Get.put(NexusSearchController(), permanent: true);

  DateTime? lastBackPressed;

  /// 🔥 Pages (order same rakho)
  final List<Widget> _pages = [
    const AmzHome(),
    const ProfileScreen(),
    AmzCartScreen(),
    const AllCategoriesScreen(), // Menu ke liye (change later)
  ];

  final NexusVendorController vendorCtrl =
  Get.find<NexusVendorController>();

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  void initializeControllers() async {
    final prefs = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(prefs, permanent: true);

    Get.put(GuestCartController(), permanent: true);
    Get.put(ProfileOrdersController(), permanent: true);
    Get.put(CategoryUIController(), permanent: true);

    final cartCtrl = Get.put(AmzCartController(), permanent: true);

    vendorCtrl.loadVendorFromStorage().then((_) async {
      final vendorId = vendorCtrl.vendorId.value;
      if (vendorId.isNotEmpty) {
        await cartCtrl.checkLogin(vendorId);
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  Future<bool> onWillPop() async {
    final now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 5)) {
      lastBackPressed = now;
      Get.snackbar(
        'Exit App',
        'Press again to exit',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Text('Sab se sasta'),
      );
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Theme(
        data: AmzTheme(),
        child: Scaffold(
          appBar: _buildSearchBar(),
          body: _pages[_selectedIndex],
          bottomNavigationBar: _amazonBottomBar(),
        ),
      ),
    );
  }

  /// 🔍 APP BAR
  PreferredSizeWidget _buildSearchBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: searchTextCtrl,
          onSubmitted: (v) async {
            if (v.trim().isEmpty) return;
            searchCtrl.searchProduct(v);
            await Get.to(() => const SearchScreen());
            searchTextCtrl.clear();
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.black54),
            hintText: "Search here...",
          ),
        ),
      ),
    );
  }

  /// 🔥 AMAZON BOTTOM BAR (TOP INDICATOR)
  Widget _amazonBottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_outlined, "Home", 0),
            _navItem(Icons.person_outline, "You", 1),
            _navItem(Icons.shopping_cart_outlined, "Cart", 2, badge: true),
            _navItem(Icons.menu_outlined, "Menu", 3),
          ],
        ),
      ),
    );
  }

  /// 🔥 SINGLE ITEM WITH TOP LINE
  Widget _navItem(
      IconData icon,
      String label,
      int index, {
        bool badge = false,
      }) {
    final isActive = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 6,
              width: isActive ? 45 : 0,
              margin: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
            ),
            Stack(
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: Colors.black,
                ),
                // if (badge)
                //   Positioned(
                //     right: -6,
                //     top: -6,
                //     child: Container(
                //       padding: const EdgeInsets.all(4),
                //       decoration: const BoxDecoration(
                //         color: Colors.black,
                //         shape: BoxShape.circle,
                //       ),
                //       child: const Text(
                //         "5",
                //         style: TextStyle(
                //           fontSize: 10,
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
