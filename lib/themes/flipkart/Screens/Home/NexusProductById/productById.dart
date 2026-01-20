import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/cart_controller.dart';
import 'package:one_click_builder/themes/Nexus/Modules/ProductById/nexusProductById.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Cart/NexusCart.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProductById/NexusTryon.dart';
import 'package:one_click_builder/themes/Nexus/api/ProductById/productById.dart';
import 'package:one_click_builder/themes/Nexus/api/cart/nexusAddtoCart.dart'
    as api;
import 'package:one_click_builder/themes/Nexus/api/cart/nexusAddtoCart.dart'
    as cartApi;
import 'package:shimmer/shimmer.dart';
import 'dart:io';

class ProductByIdScreen extends StatefulWidget {
  final String productId;
  const ProductByIdScreen({super.key, required this.productId});

  @override
  State<ProductByIdScreen> createState() => _ProductByIdScreenState();
}

class _ProductByIdScreenState extends State<ProductByIdScreen>
    with SingleTickerProviderStateMixin {
  bool isAddToCartLoading = false;
  bool isBuyNowLoading = false;

  Product? product;
  bool isLoading = true;

  final CartController cartController = Get.find<CartController>();

  File? userImage;
  Offset productOffset = const Offset(100, 200);
  double productScale = 1.0;

  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;

  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentCarouselIndex = 0;

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

    fetchProductData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _addToCartController.dispose();
    super.dispose();
  }

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
      return Scaffold(
        appBar: AppBar(title: const Text("Product")),
        body: const Center(child: Text("Product not found")),
      );
    }

    final List<ProductImage> images = product!.images ?? [];

    // If there are no images at all, show fallback
    if (images.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Product")),
        body: const Center(child: Text("No images available")),
      );
    }

    // selectedColorData: choose item at selectedColorIndex (safe because images not empty)
    final ProductImage selectedColorData = images[selectedColorIndex];

    // Build a list of images for carousel — **only using the single `image` field**
    final List<String> selectedColorImages = [];
    if ((selectedColorData.image ?? "").isNotEmpty) {
      selectedColorImages.add(selectedColorData.image!);
    }

    // If you later add multi-images to model, you can append them here.
    // e.g. if you add List<String> extraImages to ProductImage, push them to selectedColorImages.

    final List<ProductSize> sizeList = selectedColorData.sizes ?? [];

    String price = sizeList.isNotEmpty
        ? (sizeList[selectedSizeIndex].price?.toString() ?? "0")
        : "0";

    String stock =
        sizeList.isNotEmpty ? (sizeList[selectedSizeIndex].stock ?? "0") : "0";

    // 🔹 VISIBILITY FLAGS (IMPORTANT)
    final bool hasColors = images.any(
      (img) => img.colors != null && img.colors!.isNotEmpty,
    );

    final bool hasSizes = sizeList.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(product!.title ?? "Product"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _toggleWishlist,
              child: AnimatedScale(
                scale: isWishlisted ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // CAROUSEL (single image per color in current API)
          if (selectedColorImages.isNotEmpty)
            SizedBox(
              height: 560,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: selectedColorImages.length,
                    onPageChanged: (idx) {
                      setState(() => _currentCarouselIndex = idx);
                    },
                    itemBuilder: (context, index) {
                      final imgUrl = selectedColorImages[index];
                      return GestureDetector(
                        onTap: () => _openZoomableImage(context, imgUrl),
                        child: Hero(
                          tag: imgUrl,
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return  Center(
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
                            errorBuilder: (c, e, s) =>
                                const Center(child: Icon(Icons.broken_image)),
                          ),
                        ),
                      );
                    },
                  ),

                  // DOT INDICATOR (works even if there is just one dot)
                  Positioned(
                    bottom: 12,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        selectedColorImages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentCarouselIndex == i ? 14 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentCarouselIndex == i
                                ? Colors.white
                                : Colors.white54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          else

            // Fallback: show first image from product images list (shouldn't usually happen)
            SizedBox(
              height: 450,
              child: Center(
                child: Image.network(
                  product!.images!.first.image!,
                  fit: BoxFit.contain,
                ),
              ),
            ),

          const SizedBox(height: 16),

          // TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              product!.title ?? "",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 12),

          // PRICE + STOCK + CART ICON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Text(
                "₹$price",
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
            ]),
          ),

          const SizedBox(height: 18),

          // COLOR SELECTOR
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Select Color",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 54,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, idx) {
                final colorList = images[idx].colors ?? [];
                String hex = "#000000";
                if (colorList.isNotEmpty) hex = colorList.first;

                final bool selected = idx == selectedColorIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColorIndex = idx;
                      selectedSizeIndex = 0;
                      _currentCarouselIndex = 0;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: selected ? Colors.blue : Colors.grey.shade300,
                          width: selected ? 2 : 1),
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: _hexToColor(hex),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: images.length,
            ),
          ),

          // const SizedBox(height: 18),
          // ElevatedButton.icon(
          //   icon: const Icon(Icons.person),
          //   label: const Text("Virtual Try-On"),
          //   onPressed: () {
          //     showGeneralDialog(
          //       context: context,
          //       barrierDismissible: true,
          //       barrierLabel: "Virtual Try On",
          //       barrierColor: Colors.black.withOpacity(0.6),
          //       transitionDuration: const Duration(milliseconds: 300),
          //       pageBuilder: (_, __, ___) {
          //         return VirtualTryOnDialog(
          //           dressImage: selectedColorImages.first,
          //         );
          //       },
          //       transitionBuilder: (_, anim, __, child) {
          //         return Transform.scale(
          //           scale: Curves.easeOut.transform(anim.value),
          //           child: child,
          //         );
          //       },
          //     );
          //   },
          // ),

          // SIZE SELECTOR
          if (hasSizes) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Select Size",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(sizeList.length, (i) {
                  final size = sizeList[i];
                  final selected = i == selectedSizeIndex;
                  return GestureDetector(
                    onTap: () => setState(() => selectedSizeIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? Colors.black : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(size.size ?? "",
                          style: TextStyle(
                              color: selected ? Colors.white : Colors.black)),
                    ),
                  );
                }),
              ),
            ),
          ],

          const SizedBox(height: 28),

          // ADD TO CART BUTTON (bottom)

          const SizedBox(height: 24),
        ]),
      ),
      bottomNavigationBar: _buildBottomBar(price),
    );
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
                          Get.to(() => const CartScreen());
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

  void _toggleWishlist() {
    setState(() {
      isWishlisted = !isWishlisted;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              isWishlisted ? "Added to wishlist" : "Removed from wishlist")),
    );
  }

  void _simulateAddToCart() {
    _addToCartController.forward().then((_) => _addToCartController.reverse());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to cart")),
    );
  }

  Future<bool> _onAddToCartPressed({required bool isBuyNow}) async {
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
      final selectedImage = product!.images![selectedColorIndex];

      final selectedColor =
          (selectedImage.colors != null && selectedImage.colors!.isNotEmpty)
              ? selectedImage.colors!.first
              : "";

      ProductSize? selectedSizeData;
      if (selectedImage.sizes != null && selectedImage.sizes!.isNotEmpty) {
        selectedSizeData = selectedImage.sizes![selectedSizeIndex];
      }

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
          _showSnack("Item added to cart", backgroundColor: Colors.green);
          return true;

        case cartApi.CartAddResult.alreadyExists:
          _showSnack("Item already in your cart",
              backgroundColor: Colors.orange);
          return true;

        case cartApi.CartAddResult.notLoggedIn:
          _showSnack("Please login to continue", backgroundColor: Colors.blue);
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

// Future<void> _onAddToCartPressed() async {
//   if (product == null || product!.images == null || product!.images!.isEmpty) {
//     _showSnack("Invalid product");
//     return;
//   }

//   setState(() => isAddingToCart = true);

//   try {
//     final selectedImage = product!.images![selectedColorIndex];

//     // SAFE COLOR
//     final selectedColor =
//         (selectedImage.colors != null && selectedImage.colors!.isNotEmpty)
//             ? selectedImage.colors!.first
//             : "";

//     // SAFE SIZE
//     ProductSize? selectedSizeData;
//     if (selectedImage.sizes != null && selectedImage.sizes!.isNotEmpty) {
//       selectedSizeData = selectedImage.sizes![selectedSizeIndex];
//     }

//     final result = await cartApi.CartApiService.addToCart(
//       vendorId: product!.vendorId ?? "",
//       productId: product!.id ?? "",
//       image: selectedImage.image ?? "",
//       isImported: (product!.isImported ?? 0) == 1,
//       price: selectedSizeData?.price?.toInt() ?? 0,
//       quantity: 1,
//       selectedColor: selectedColor,
//       selectedSize: selectedSizeData?.size ?? "Free",
//     );

//     switch (result) {
//   case cartApi.CartAddResult.success:
//     _showSnack(
//       "Item added to cart",
//       backgroundColor: Colors.green,
//     );
//     break;

//   case cartApi.CartAddResult.alreadyExists:
//     _showSnack(
//       "Item already in your cart",
//       backgroundColor: Colors.orange,
//     );
//     break;

//   case cartApi.CartAddResult.notLoggedIn:
//     _showSnack(
//       "Please login to continue",
//       backgroundColor: Colors.blue,
//     );
//     break;

//   case cartApi.CartAddResult.error:
//     _showSnack(
//       "Failed to add item",
//       backgroundColor: Colors.red,
//     );
//     break;
// }

//   } catch (e, s) {
//     debugPrint("ADD TO CART ERROR: $e");
//     debugPrintStack(stackTrace: s);
//     _showSnack("Something went wrong");
//   } finally {
//     setState(() => isAddingToCart = false);
//   }
// }

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
                    return  Center(
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
      appBar: AppBar(title: const Text("Product")),
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
}
