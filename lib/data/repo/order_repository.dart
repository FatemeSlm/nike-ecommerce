import 'package:nike_ecommerce/common/http_client.dart';
import 'package:nike_ecommerce/data/order.dart';
import 'package:nike_ecommerce/data/payment_receipt.dart';
import 'package:nike_ecommerce/data/source/order_data_source.dart';

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);

  @override
  Future<CreateOrderResponse> create(CreateOrderParams params) =>
      dataSource.create(params);

  @override
  Future<PaymentReceipt> getPaymentReceipt(int orderId) =>
      dataSource.getPaymentReceipt(orderId);

  @override
  Future<List<OrderEntity>> getOrders() => dataSource.getOrders();
}
