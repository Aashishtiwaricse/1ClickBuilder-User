import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/cart_controller.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/guestCartController/guestCart.dart';
import 'package:one_click_builder/themes/Amazon/Modules/ProductById/AmzProductById.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Cart/AmzCart.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:one_click_builder/themes/Amazon/api/ProductById/productById.dart';
import 'package:one_click_builder/themes/Amazon/api/cart/AmzAddtoCart.dart'
    as api;
import 'package:one_click_builder/themes/Amazon/api/cart/AmzAddtoCart.dart'
    as cartApi;
import 'package:one_click_builder/themes/Amazon/utility/app_constant.dart';
import 'package:one_click_builder/themes/Amazon/utility/plugin_list.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';

import '../../../NexusVendorId/vendorid.dart';
import '../../SearchScreren/AmzSearchScreen.dart';

class AmzProductByIdScreen extends StatefulWidget {
  final String productId;
  const AmzProductByIdScreen({super.key, required this.productId});

  @override
  State<AmzProductByIdScreen> createState() => _AmzProductByIdScreenState();
}

class _AmzProductByIdScreenState extends State<AmzProductByIdScreen>
    with SingleTickerProviderStateMixin {
  bool isAddToCartLoading = false;
  bool isBuyNowLoading = false;

  Product? product;
  bool isLoading = true;

  final AmzCartController cartController = Get.find<AmzCartController>();

  File? userImage;
  Offset productOffset = const Offset(100, 200);
  double productScale = 1.0;

  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;

  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentCarouselIndex = 0;
  final GuestCartController guestCartController =
      Get.find<GuestCartController>();

  bool isWishlisted = false;
  late AnimationController _addToCartController;

  @override
  void initState() {
    super.initState();
    _addToCartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.9,
      upperBound: 1.05,
    )..value = 1.0;
//Get.put(GuestCartController());

    fetchProductData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _addToCartController.dispose();
    super.dispose();
  }

  bool isLoggedIn = false;
  bool isCheckingLogin = true;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        userImage = File(picked.path);
        productOffset = const Offset(100, 200);
        productScale = 1.0;
      });
    }
  }

  Future<void> fetchProductData() async {
    try {
      final api = NexusProductById();
      final fetchedProduct = await api.fetchProduct(widget.productId);
      await Future.delayed(const Duration(milliseconds: 250)); // small UX delay
      setState(() {
        product = fetchedProduct;
        isLoading = false;
        selectedColorIndex = 0;
        selectedSizeIndex = 0;
        _currentCarouselIndex = 0;
      });
    } catch (e) {
      debugPrint("Product fetch error: $e");
      setState(() {
        product = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildShimmer();

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Product not found")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(), // 👈 AMAZON BODY
    );
  }
  Map<String, dynamic> resolvePrice() {
    double sellingPrice = 0;
    double originalPrice = 0;
    int discountPercent = 0;

    // SAFETY
    if (product == null || product!.images == null || product!.images!.isEmpty) {
      return {
        "sellingPrice": 0.0,
        "originalPrice": 0.0,
        "discountPercent": 0,
      };
    }

    final images = product!.images!;

    final selectedImage = selectedColorIndex < images.length
        ? images[selectedColorIndex]
        : images.first;

    ProductSize? selectedSize;
    if (selectedImage.sizes != null &&
        selectedSizeIndex < selectedImage.sizes!.length) {
      selectedSize = selectedImage.sizes![selectedSizeIndex];
    }

    // SAME FLOW AS NEXUS
    sellingPrice = double.tryParse(
      selectedSize?.price?.toString() ??
          product!.salePrice?.toString() ??
          product!.price?.toString() ??
          "0",
    ) ??
        0;

    originalPrice =
        product!.price?.toDouble() ??
            product!.retailPrice?.toDouble() ??
            sellingPrice;

    if (originalPrice < sellingPrice) {
      originalPrice = sellingPrice;
    }

    discountPercent = originalPrice > 0
        ? (((originalPrice - sellingPrice) / originalPrice) * 100).round()
        : 0;

    return {
      "sellingPrice": sellingPrice,
      "originalPrice": originalPrice,
      "discountPercent": discountPercent,
    };
  }

  Widget amazonBottomBar({
    required VoidCallback onAddToCart,
    required VoidCallback onBuyNow,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,

      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🟡 ADD TO CART
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD814), // Amazon yellow
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // pill shape
                ),
              ),
              child: const Text(
                "Add to cart",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 🟠 BUY NOW
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onBuyNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9900), // Amazon orange
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Buy Now",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget amazonOffersCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Available Offers",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.local_offer, size: 18, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text("Bank Offer: 10% Instant Discount"),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.local_offer, size: 18, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text("Special Price: Extra savings on this product"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget amazonDeliveryInfo({required String stock}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "FREE delivery",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "In stock: $stock",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget amazonPriceSection({
    required double sellingPrice,
    required double originalPrice,
    required int discountPercent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DISCOUNT %
          if (discountPercent > 0)
            Text(
              "-$discountPercent%",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

          const SizedBox(height: 4),

          // PRICE ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "₹",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                sellingPrice.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          // ORIGINAL PRICE (MRP)
          if (originalPrice > sellingPrice)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "M.R.P.: ₹${originalPrice.toStringAsFixed(0)}",
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildBody() {
    final priceData = resolvePrice(); // ✅ yahin call hoga

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildImageCarousel(),
          const SizedBox(height: 12),
          const SizedBox(height: 8),

          // ✅ CORRECT PRICE FLOW
          amazonPriceSection(
            sellingPrice: priceData["sellingPrice"],
            originalPrice: priceData["originalPrice"],
            discountPercent: priceData["discountPercent"],
          ),

          amazonDeliveryInfo(stock: "${product!.currentStock}"),
          const SizedBox(height: 12),
          amazonOffersCard(),
          const Divider(height: 32),
          _buildColorSelector(),
          const SizedBox(height: 6),
          _buildSizeSelector(),
          const SizedBox(height: 12),
          _buildAmazonBottomBar(),
          const Divider(height: 32),
          _buildDescription(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black),

      title: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          // border: Border.all(
          //   color: Colors.grey, // Amazon yellow
          //   width: 1.2,
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (value.trim().isEmpty) return;

            // 👉 yahan apna search logic call karo
            // searchCtrl.searchProduct(value);
            // Get.to(() => const SearchScreen());
          },
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12),
            border: InputBorder.none,

            // 🔍 Amazon-style search icon
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black54,
            ),

            hintText: "Search here..",
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.black45,
            ),

            // 📷 Camera icon (optional)
            // suffixIcon: Icon(
            //   Icons.camera_alt_outlined,
            //   color: Colors.black54,
            // ),
          ),
        ),
      ),

      actions: const [
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildAmazonBottomBar() {
    return amazonBottomBar(
      onAddToCart: () {
        _onAddToCartPressed(isBuyNow: false);
      },
      onBuyNow: () async {
        final added = await _onAddToCartPressed(isBuyNow: true);
        if (added) {
          Get.to(() => const AmzCartScreen());
        }
      },
    );
  }

  Widget _buildImageCarousel() {
    final images = product!.images
        .where((e) => e.image != null && e.image!.isNotEmpty)
        .map((e) => e.image!)
        .toList();

    if (images.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Icon(Icons.image_not_supported)),
      );
    }

    return SizedBox(
      height: 420,
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        onPageChanged: (i) => setState(() => _currentCarouselIndex = i),
        itemBuilder: (_, i) {
          return Image.network(
            images[i],
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        product!.title ?? "",
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildColorSelector() {
    final colors = <String>{};

    for (var img in product!.images) {
      colors.addAll(img.colors);
    }

    if (colors.isEmpty) return const SizedBox();

    final colorList = colors.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Colour",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: colorList.length,
            itemBuilder: (_, i) {
              final hex = colorList[i];
              final selected = selectedColorIndex == i;

              return GestureDetector(
                onTap: () => setState(() => selectedColorIndex = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.black : Colors.grey,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: _hexToColor(hex),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelector() {
    final sizes = <ProductSize>{};

    for (var img in product!.images) {
      sizes.addAll(img.sizes);
    }

    if (sizes.isEmpty) return const SizedBox();

    final sizeList = sizes.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Size",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 10,
            children: List.generate(sizeList.length, (i) {
              final selected = selectedSizeIndex == i;
              return GestureDetector(
                onTap: () => setState(() => selectedSizeIndex = i),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? Colors.black : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    sizeList[i].size ?? "",
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    if (product!.description == null || product!.description!.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Html(data: product!.description!),
          ],
        ),
      ),
    );
  }

  Widget _buildCartIcon() {
    return Obx(() {
      final count = cartController.cartCount.value;
      return Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Get.to(() => const AmzCartScreen()),
          ),
          if (count > 0)
            Positioned(
              right: 6,
              top: 6,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: Text(
                  count.toString(),
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildBottomBar(String price) {
    final theme = Theme.of(context); // ✅ FIXED

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // GO TO CART
            Expanded(
              child: OutlinedButton(
                onPressed: isAddToCartLoading
                    ? null
                    : () async {
                        await _onAddToCartPressed(isBuyNow: false);
                      },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isAddToCartLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        "Add to cart",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // BUY NOW
            Expanded(
              child: ElevatedButton(
                onPressed: isBuyNowLoading
                    ? null
                    : () async {
                        final added = await _onAddToCartPressed(isBuyNow: true);
                        if (added) {
                          Get.to(() => const AmzCartScreen());
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Color(0xfff3c0e6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isBuyNowLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        "Buy now ₹$price",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- HELPERS & SMALL ANIMATIONS ----------

  void _simulateAddToCart() {
    _addToCartController.forward().then((_) => _addToCartController.reverse());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to cart")),
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('token');
    return userId != null && userId.isNotEmpty;
  }

  Future<bool> _onAddToCartPressed({required bool isBuyNow}) async {
    // Check login
    final loggedIn = await _checkLoginStatus();

    if (!loggedIn) {
      if (isBuyNow) {
        _showLoginRequiredDialog(context);
        return false;
      } else {
        print('guest cart execute if else');
        return await _guestAddToCart();
      }
    }

    // Normal add to cart flow
    if (product == null ||
        product!.images == null ||
        product!.images!.isEmpty) {
      _showSnack("Invalid product");
      return false;
    }

    setState(() {
      if (isBuyNow) {
        isBuyNowLoading = true;
      } else {
        isAddToCartLoading = true;
      }
    });

    try {
      final selectedImage = product!.images!.isNotEmpty &&
              selectedColorIndex < product!.images!.length
          ? product!.images![selectedColorIndex]
          : product!.images!.first;

      final selectedColor =
          (selectedImage.colors != null && selectedImage.colors!.isNotEmpty)
              ? selectedImage.colors!.first
              : "";

      final selectedSizeData = selectedSizeIndex < selectedImage.sizes!.length
          ? selectedImage.sizes![selectedSizeIndex]
          : null;

      final result = await cartApi.CartApiService.addToCart(
        vendorId: product!.vendorId ?? "",
        productId: product!.id ?? "",
        image: selectedImage.image ?? "",
        isImported: (product!.isImported ?? 0) == 1,
        price: selectedSizeData?.price?.toInt() ?? 0,
        quantity: 1,
        selectedColor: selectedColor,
        selectedSize: selectedSizeData?.size ?? "Free",
      );

      switch (result) {
        case cartApi.CartAddResult.success:
          cartController.cartCount.value += 1;
          _showSnack("Item added to cart", backgroundColor: Colors.green);
          return true;

        case cartApi.CartAddResult.alreadyExists:
          _showSnack("Item already in your cart",
              backgroundColor: Colors.orange);
          return true;

        case cartApi.CartAddResult.notLoggedIn:
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');
          _showSnack("Session Expired", backgroundColor: Colors.blue);
          _showLoginRequiredDialog(context);
          return false;

        case cartApi.CartAddResult.error:
          _showSnack("Failed to add item", backgroundColor: Colors.red);
          return false;
      }
    } catch (e) {
      _showSnack("Something went wrong");
      return false;
    } finally {
      setState(() {
        isAddToCartLoading = false;
        isBuyNowLoading = false;
      });
    }
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Required"),
        content: const Text("Please login to access this feature."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AmzSignInScreen()),
              );
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  void _showSnack(
    String message, {
    Color backgroundColor = Colors.black87,
  }) {
    Get.snackbar(
      "Cart",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void _openZoomableImage(BuildContext ctx, String url) {
    showDialog(
      context: ctx,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Dialog(
            backgroundColor: Colors.black87,
            insetPadding: const EdgeInsets.all(4),
            child: Hero(
              tag: url,
              child: InteractiveViewer(
                maxScale: 4.0,
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder: (c, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 120,
                          height: 20,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // shimmer loading scaffold
  Widget _buildShimmer() {
    return Scaffold(
      // appBar: AppBar(title: const Text("Product")),
      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(height: 300, color: Colors.white),
            const SizedBox(height: 16),
            Container(height: 20, color: Colors.white),
            const SizedBox(height: 12),
            Container(height: 18, width: 120, color: Colors.white),
            const SizedBox(height: 20),
            Row(children: [
              Container(height: 40, width: 40, color: Colors.white),
              const SizedBox(width: 10),
              Container(height: 40, width: 40, color: Colors.white),
              const SizedBox(width: 10),
              Container(height: 40, width: 40, color: Colors.white),
            ]),
            const SizedBox(height: 20),
            Container(height: 40, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse("0x$hex"));
  }

  Future<bool> _guestAddToCart() async {
    try {
      setState(() => isLoading = true); // 🔵 SHOW LOADER

      final prefs = await SharedPreferences.getInstance();
      final guestId = prefs.getString("guestId") ?? "";
      final vendorCtrl = Get.find<NexusVendorController>();
      final vendorId = vendorCtrl.vendorId.value;

      if (guestId.isEmpty) {
        print("⚠ No guestId found.");
        _showSnack("Something Went Wrong", backgroundColor: Colors.red);

        setState(() => isLoading = false); // 🔴 HIDE LOADER
        return false;
      }

      final String url =
          "${AmzAppConstant.baseUrl}/api/cart/guest/add-cart/$vendorId/$guestId";

      final selectedImage = product!.images!.isNotEmpty &&
              selectedColorIndex < product!.images!.length
          ? product!.images![selectedColorIndex]
          : product!.images!.first;

      final selectedColor =
          (selectedImage.colors != null && selectedImage.colors!.isNotEmpty)
              ? selectedImage.colors!.first
              : "";

      ProductSize? selectedSizeData;
      if (selectedSizeIndex < selectedImage.sizes!.length) {
        selectedSizeData = selectedImage.sizes![selectedSizeIndex];
      }

      final Map<String, dynamic> body = {
        "vendorId": product!.vendorId ?? "",
        "productId": product!.id ?? "",
        "image": selectedImage.image ?? "",
        "price": selectedSizeData?.price?.toInt() ?? 0,
        "quantity": 1,
        "selectedSize": selectedSizeData?.size ?? "Free",
      };

// ✅ Add color ONLY if available
      if (selectedImage.colors != null && selectedImage.colors!.isNotEmpty) {
        body["selectedColor"] = selectedImage.colors!.first;
      }

      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      final response = jsonDecode(res.body);

      print("hhhhhh${res.body}");

      if (res.statusCode == 200) {
        _showSnack("Item added to cart", backgroundColor: Colors.green);

        Get.find<GuestCartController>().loadGuestCart();

        return true;
      }

      final error = response["error"]?["error"];

      if (error == "ProductAlreadyInCart") {
        _showSnack("Item already in your cart", backgroundColor: Colors.orange);
        return true;
      }

      _showSnack("Failed to add item", backgroundColor: Colors.red);
      return false;
    } catch (e) {
      print("Guest add cart exception: $e");
      _showSnack("Something went wrong", backgroundColor: Colors.red);
      return false;
    } finally {
      setState(() => isLoading = false);
    }
  }
}
