import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Nexus/Modules/NexusProducts/NexusProduct.dart';
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';

class ProductService {
  Future<ProductListResponse?> getProducts(String vendorId) async {
    final url =
        "${NexusAppConstant.baseUrl}${NexusAppConstant.product_list}$vendorId";

    try {
      final response = await http.get(Uri.parse(url));
      

      if (response.statusCode == 200) {
        return productListResponseFromJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
