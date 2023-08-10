import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/order.dart';
import 'package:nike_ecommerce/data/repo/order_repository.dart';
import 'package:nike_ecommerce/ui/order/bloc/order_history_bloc.dart';
import 'package:nike_ecommerce/ui/product/details.dart';
import 'package:nike_ecommerce/ui/widgets/image.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderHistoryBloc>(
      create: (context) =>
          OrderHistoryBloc(orderRepository)..add(OrderHistoryStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سوابق سفارش'),
          centerTitle: true,
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccess) {
              final orders = state.orderList;
              return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _OrderItem(order: order);
                  });
            } else if (state is OrderHistoryError) {
              return Center(
                child: Text(state.appException.message),
              );
            } else if (state is OrderHistoryLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              throw Exception('state is not supprted.');
            }
          },
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  const _OrderItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('شناسه سفارش'),
                  Text(order.id.toString())
                ],
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('مبلغ'),
                  Text(order.payablePrice.withPriceLabel)
                ],
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                scrollDirection: Axis.horizontal,
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final product = order.items[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: product,)));
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      child: ImageLoadingService(
                        imageUrl: product.imageUrl,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
