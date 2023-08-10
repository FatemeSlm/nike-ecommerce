import 'package:nike_ecommerce/common/http_client.dart';
import 'package:nike_ecommerce/data/product.dart';
import 'package:nike_ecommerce/data/source/product_data_source.dart';

final productRepository = ProductRepository(ProductRemoteDataSource(httpClient));

abstract class IProductRepository {
  Future<List<Product>> getAll(int sort);
  Future<List<Product>> search(String serachTerm);
}

class ProductRepository implements IProductRepository {
  final IProductDataSource dataSource;

  ProductRepository(this.dataSource);

  @override
  Future<List<Product>> getAll(int sort) => dataSource.getAll(sort);

  @override
  Future<List<Product>> search(String serachTerm) =>
      dataSource.search(serachTerm);
}
