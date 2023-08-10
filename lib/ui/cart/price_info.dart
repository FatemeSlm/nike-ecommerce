import 'package:flutter/material.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/theme.dart';

class PriceInfo extends StatelessWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;
  const PriceInfo(
      {Key? key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 8, 0),
          child: Text(
            'جزییات خرید',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 32),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ کل خرید'),
                    RichText(
                        text: TextSpan(
                            text: totalPrice.separateByComma,
                            style: DefaultTextStyle.of(context).style.apply(
                                color: LightThemeColors.secondryTextColor),
                            children: const [
                          TextSpan(
                              text: ' تومان', style: TextStyle(fontSize: 10)),
                        ]))
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('هزینه ارسال'),
                    Text(shippingCost.withPriceLabel)
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ قابل پرداخت'),
                    RichText(
                        text: TextSpan(
                            text: payablePrice.separateByComma,
                            style: DefaultTextStyle.of(context).style.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 17),
                            children: const [
                          TextSpan(
                              text: ' تومان',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.normal, color: LightThemeColors.secondryTextColor))
                        ]))
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
