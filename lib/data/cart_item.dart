import 'package:nike_ecommerce/data/product.dart';

class CartItemEntity {
  final int id;
  final Product product;
  int count;
  bool deleteButtonLaoding = false;
  bool changeCountLoading = false;

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = Product.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemEntity> parseJsonArray(List<dynamic> jsonArrray) {
    final List<CartItemEntity> cartItems = [];
    jsonArrray.forEach((element) {
      cartItems.add(CartItemEntity.fromJson(element));
    });

    return cartItems;
  }
}
