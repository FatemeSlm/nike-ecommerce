import 'package:dio/dio.dart';
import 'package:nike_ecommerce/common/http_response_validator.dart';

import '../product.dart';

abstract class IProductDataSource {
  Future<List<Product>> getAll(int sort);
  Future<List<Product>> search(String serachTerm);
}

class ProductRemoteDataSource with HttpResponseValidation implements IProductDataSource {
  final Dio httpClient;

  ProductRemoteDataSource(this.httpClient);

  @override
  Future<List<Product>> getAll(int sort) async {
    final response = await httpClient.get('product/list?sort=$sort');
    validateResposnse(response);
    final products = <Product>[];
    (response.data as List).forEach((element) {
      products.add(Product.fromJson(element));
    });

    return products;
  }

  @override
  Future<List<Product>> search(String serachTerm) async {
    final response = await httpClient.get('product/search?q=$serachTerm');
    validateResposnse(response);
    final products = <Product>[];
    (response.data as List).forEach((element) {
      products.add(Product.fromJson(element));
    });

    return products;
  }

 
}
