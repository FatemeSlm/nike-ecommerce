import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/repo/order_repository.dart';
import 'package:nike_ecommerce/theme.dart';
import 'package:nike_ecommerce/ui/receipt/bloc/payment_receipt_bloc.dart';

class ReceiptScreen extends StatelessWidget {
  final int orderId;
  const ReceiptScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('رسید پرداخت'),
        centerTitle: true,
      ),
      body: BlocProvider<PaymentReceiptBloc>(
        create: (context) => PaymentReceiptBloc(orderRepository)
          ..add(PaymentReceiptStarted(orderId)),
        child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
          builder: (context, state) {
            if (state is PaymentReceiptSuccess) {
              return Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: themeData.dividerColor, width: 1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Text(
                          state.paymentReceipt.purchaseSuccess
                              ? 'پرداخت با موفقیت انجام شد'
                              : 'پرداخت ناموفق',
                          style: themeData.textTheme.headline6!.copyWith(
                              color: themeData.colorScheme.primary,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'وضعیت سفارش',
                              style: TextStyle(
                                  color: LightThemeColors.secondryTextColor),
                            ),
                            Text(
                              state.paymentReceipt.paymentStatus,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        ),
                        const Divider(
                          height: 24,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'مبلغ سفارش',
                              style: TextStyle(
                                  color: LightThemeColors.secondryTextColor),
                            ),
                            Text(
                              state.paymentReceipt.payablePrice.withPriceLabel,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text('بازگشت به صفحه اصلی'))
                ],
              );
            } else if (state is PaymentReceiptError) {
              return Center(
                child: Text(state.appException.message),
              );
            } else if (state is PaymentReceiptLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              throw Exception('state is not supported');
            }
          },
        ),
      ),
    );
  }
}
