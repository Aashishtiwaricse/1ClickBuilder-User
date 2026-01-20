class LogoModel {
  final String? logoId;
  final String? vendorId;
  final String? logoUrl;
  final String? email;
  final String? mobile;
  final String? address;
  final String? copyRights;
  final String? deliveryCharges;
  final String? createdAt;
  final String? updatedAt;
  final String? currentTheme;

  LogoModel({
    this.logoId,
    this.vendorId,
    this.logoUrl,
    this.email,
    this.mobile,
    this.address,
    this.copyRights,
    this.deliveryCharges,
    this.createdAt,
    this.updatedAt,
    this.currentTheme,
  });

  factory LogoModel.fromJson(Map<String, dynamic> json) {
    return LogoModel(
      logoId: json['logoId'],
      vendorId: json['vendorId'],
      logoUrl: json['logoUrl'],
      email: json['email'],
      mobile: json['mobile'],
      address: json['address'],
      copyRights: json['copyRights'],
      deliveryCharges: json['deliveryCharges'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      currentTheme: json['currentTheme'],
    );
  }
}
