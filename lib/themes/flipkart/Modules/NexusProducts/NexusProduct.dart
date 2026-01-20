import 'dart:convert';

ProductListResponse productListResponseFromJson(String str) =>
    ProductListResponse.fromJson(json.decode(str));

class ProductListResponse {
  final List<ProductData> data;

  ProductListResponse({required this.data});

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      data: List<ProductData>.from(
        json["data"].map((x) => ProductData.fromJson(x)),
      ),
    );
  }
}

class ProductData {
  final Product product;

  ProductData({required this.product});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      product: Product.fromJson(json["product"]),
    );
  }
}

class Product {
  final String id;
  final String title;
  final double price;
  final double mrpPrice;
  final List<ProductImage> images;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.mrpPrice,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"] ?? "",
        price: (json["discountPrice"] ?? 0).toDouble(),
        mrpPrice: (json["mrpPrice"] ?? 0).toDouble(),
        images: json["images"] == null
            ? []
            : List<ProductImage>.from(
                json["images"].map((x) => ProductImage.fromJson(x))),
      );
}

class ProductImage {
  final String image;

  ProductImage({required this.image});

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        image: json["image"] ?? "",
      );
}
