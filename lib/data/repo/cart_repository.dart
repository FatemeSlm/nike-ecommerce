import 'package:flutter/cupertino.dart';
import 'package:nike_ecommerce/common/http_client.dart';
import 'package:nike_ecommerce/data/add_to_cart_response.dart';
import 'package:nike_ecommerce/data/cart_response.dart';
import 'package:nike_ecommerce/data/source/cart_data_source.dart';

final cartRepository = CartRepository(CartRemoteDataSource(httpClient));

abstract class ICartRepository {
  Future<AddToCartResponse> add(int productId);
  Future<AddToCartResponse> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  static ValueNotifier<int> cartItemCountNotifier = ValueNotifier(0);

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(int productId) {
    return dataSource.add(productId);
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) {
    return dataSource.changeCount(cartItemId, count);
  }

  @override
  Future<int> count() async {
    final count = await dataSource.count();
    cartItemCountNotifier.value = count;
    return count;
  }

  @override
  Future<void> delete(int cartItemId) {
    return dataSource.delete(cartItemId);
  }

  @override
  Future<CartResponse> getAll() {
    return dataSource.getAll();
  }
}
