import 'package:nike_ecommerce/data/product.dart';

class CreateOrderResponse {
  final int orderId;
  final String bankGatewayUrl;

  CreateOrderResponse(this.orderId, this.bankGatewayUrl);

  CreateOrderResponse.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGatewayUrl = json['bank_gateway_url'];
}

class CreateOrderParams {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String postalCode;
  final String address;
  final PaymentMethod paymentMethod;

  CreateOrderParams(
      {required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.postalCode,
      required this.paymentMethod,
      required this.address});
}

enum PaymentMethod { online, cashOnDelivery }

class OrderEntity {
  final int id;
  final int payablePrice;
  final List<Product> items;

  OrderEntity(this.id, this.payablePrice, this.items);

  OrderEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        payablePrice = json['payable'],
        items = (json['order_items'] as List)
            .map((item) => Product.fromJson(item['product']))
            .toList();
}
