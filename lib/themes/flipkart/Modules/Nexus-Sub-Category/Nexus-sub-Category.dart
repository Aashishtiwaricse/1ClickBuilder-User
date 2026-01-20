import 'dart:convert';

/// ================= HELPER =================
List<T> parseList<T>(
  dynamic value,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (value is List) {
    return value.map((e) => fromJson(e)).toList();
  }
  if (value is Map<String, dynamic>) {
    return [fromJson(value)];
  }
  return [];
}

/// ================= RESPONSE =================
ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

class ProductResponse {
  final Meta? meta;
  final dynamic error;
  final List<ProductData>? data;

  ProductResponse({
    this.meta,
    this.error,
    this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        meta: json["meta"] != null ? Meta.fromJson(json["meta"]) : null,
        error: json["error"],
        data: json["data"] is List
            ? List<ProductData>.from(
                json["data"].map((x) => ProductData.fromJson(x)),
              )
            : [],
      );
}

/// ================= META =================
class Meta {
  final dynamic paginationInfo;

  Meta({this.paginationInfo});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        paginationInfo: json["paginationInfo"],
      );
}

/// ================= PRODUCT DATA =================
class ProductData {
  final Product? product;
  final List<ShippingDetail> shippingDetails;
  final List<dynamic> reviews;
  final List<WholesalerAddress> wholesalerAddress;
  final List<ResalerAddress> resalerAddress;

  ProductData({
    this.product,
    required this.shippingDetails,
    required this.reviews,
    required this.wholesalerAddress,
    required this.resalerAddress,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        product:
            json["product"] != null ? Product.fromJson(json["product"]) : null,

        shippingDetails: parseList(
          json["shipping_details"],
          (e) => ShippingDetail.fromJson(e),
        ),

        reviews: json["reviews"] is List ? json["reviews"] : [],

        wholesalerAddress: parseList(
          json["wholesalerAddress"],
          (e) => WholesalerAddress.fromJson(e),
        ),

        resalerAddress: parseList(
          json["resalerAddress"],
          (e) => ResalerAddress.fromJson(e),
        ),
      );
}

/// ================= PRODUCT =================
class Product {
  final String? id;
  final String? vendorId;
  final String? title;
  final String? description;
  final int price;
  final List<ProductImage> images;
  final List<String> sizes;
  final List<String> colors;

  Product({
    this.id,
    this.vendorId,
    this.title,
    this.description,
    required this.price,
    required this.images,
    required this.sizes,
    required this.colors,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"]?.toString(),
        vendorId: json["vendor_id"]?.toString(),
        title: json["title"]?.toString(),
        description: json["description"]?.toString(),
        price: json["price"] ?? 0,

        images: json["images"] is List
            ? List<ProductImage>.from(
                json["images"].map((x) => ProductImage.fromJson(x)),
              )
            : [],

        sizes: json["sizes"] is String
            ? List<String>.from(jsonDecode(json["sizes"]))
            : json["sizes"] is List
                ? List<String>.from(json["sizes"])
                : [],

        colors: json["color_images"] is String
            ? List<String>.from(jsonDecode(json["color_images"]))
            : json["color_images"] is List
                ? List<String>.from(json["color_images"])
                : [],
      );
}

/// ================= PRODUCT IMAGE =================
class ProductImage {
  final String? image;
  final List<ProductSize> sizes;
  final List<String> colors;

  ProductImage({
    this.image,
    required this.sizes,
    required this.colors,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        image: json["image"]?.toString(),

        sizes: json["sizes"] is List
            ? List<ProductSize>.from(
                json["sizes"].map((x) => ProductSize.fromJson(x)),
              )
            : [],

        colors: json["colors"] is List
            ? List<String>.from(json["colors"])
            : [],
      );
}

/// ================= PRODUCT SIZE =================
class ProductSize {
  final String? size;
  final String? price;
  final String? stock;

  ProductSize({
    this.size,
    this.price,
    this.stock,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
        size: json["Size"]?.toString(),
        price: json["price"]?.toString(),
        stock: json["stock"]?.toString(),
      );
}

/// ================= SHIPPING =================
class ShippingDetail {
  final String? locationName;
  final String? shippingCharge;

  ShippingDetail({
    this.locationName,
    this.shippingCharge,
  });

  factory ShippingDetail.fromJson(Map<String, dynamic> json) =>
      ShippingDetail(
        locationName: json["location_name"]?.toString(),
        shippingCharge: json["shipping_charge"]?.toString(),
      );
}

/// ================= WHOLESALER =================
class WholesalerAddress {
  final String? userId;
  final List<String> country;
  final List<String> state;
  final List<String> city;
  final List<String> postalCode;

  WholesalerAddress({
    this.userId,
    required this.country,
    required this.state,
    required this.city,
    required this.postalCode,
  });

  factory WholesalerAddress.fromJson(Map<String, dynamic> json) =>
      WholesalerAddress(
        userId: json["userId"]?.toString(),

        country: json["originCountry"] != null
            ? List<String>.from(jsonDecode(json["originCountry"]))
            : [],

        state: json["originState"] != null
            ? List<String>.from(jsonDecode(json["originState"]))
            : [],

        city: json["originCity"] != null
            ? List<String>.from(jsonDecode(json["originCity"]))
            : [],

        postalCode: json["originPostalCode"] != null
            ? List<String>.from(jsonDecode(json["originPostalCode"]))
            : [],
      );
}

/// ================= RESALER =================
class ResalerAddress {
  final String? id;
  final dynamic country;

  ResalerAddress({
    this.id,
    this.country,
  });

  factory ResalerAddress.fromJson(Map<String, dynamic> json) =>
      ResalerAddress(
        id: json["id"]?.toString(),
        country: json["country"],
      );
}
