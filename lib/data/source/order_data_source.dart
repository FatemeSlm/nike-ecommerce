import 'package:dio/dio.dart';
import 'package:nike_ecommerce/common/http_response_validator.dart';
import 'package:nike_ecommerce/data/order.dart';
import 'package:nike_ecommerce/data/payment_receipt.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResponse> create(CreateOrderParams params);
  Future<PaymentReceipt> getPaymentReceipt(int orderId);
  Future<List<OrderEntity>> getOrders();
}

class OrderRemoteDataSource
    with HttpResponseValidation
    implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);

  @override
  Future<CreateOrderResponse> create(CreateOrderParams params) async {
    final response = await httpClient.post('order/submit', data: {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'mobile': params.phoneNumber,
      'postal_code': params.postalCode,
      'address': params.address,
      'payment_method': params.paymentMethod == PaymentMethod.online
          ? 'online'
          : 'cash_on_delivery'
    });

    validateResposnse(response);
    return CreateOrderResponse.fromJson(response.data);
  }

  @override
  Future<PaymentReceipt> getPaymentReceipt(int orderId) async {
    final response = await httpClient.get('order/checkout?order_id=$orderId');
    validateResposnse(response);

    return PaymentReceipt.fromJson(response.data);
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    final response = await httpClient.get('order/list');
    validateResposnse(response);

    return (response.data as List).map((e) => OrderEntity.fromJson(e)).toList();
  }
}
