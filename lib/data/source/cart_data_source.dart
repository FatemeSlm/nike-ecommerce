import 'package:dio/dio.dart';
import 'package:nike_ecommerce/common/http_response_validator.dart';
import 'package:nike_ecommerce/data/add_to_cart_response.dart';
import 'package:nike_ecommerce/data/cart_response.dart';

abstract class ICartDataSource {
  Future<AddToCartResponse> add(int productId);
  Future<AddToCartResponse> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRemoteDataSource
    with HttpResponseValidation
    implements ICartDataSource {
  final Dio httpClient;

  CartRemoteDataSource(this.httpClient);

  @override
  Future<AddToCartResponse> add(int productId) async {
    final response =
        await httpClient.post('cart/add', data: {'product_id': productId});
    validateResposnse(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) async {
    final response = await httpClient.post('cart/changeCount',
        data: {'cart_item_id': cartItemId, 'count': count});
    validateResposnse(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<int> count() async {
    final response = await httpClient.get('cart/count');
    validateResposnse(response);
    return response.data['count'];
  }

  @override
  Future<void> delete(int cartItemId) async {
    await httpClient.post('cart/remove', data: {'cart_item_id': cartItemId});
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpClient.get('cart/list');
    validateResposnse(response);

    return CartResponse.fromJson(response.data);
  }
}
