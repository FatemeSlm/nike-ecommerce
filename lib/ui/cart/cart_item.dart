import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/cart_item.dart';
import 'package:nike_ecommerce/ui/widgets/image.dart';

class CartItem extends StatelessWidget {
  final CartItemEntity item;
  final GestureTapCallback ondeleteButtonClick;
  final GestureTapCallback onPlusButtonClcick;
  final GestureTapCallback onMinusButtonClick;

  const CartItem({
    Key? key,
    required this.item,
    required this.ondeleteButtonClick,
    required this.onPlusButtonClcick,
    required this.onMinusButtonClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                SizedBox(
                    width: 100,
                    height: 100,
                    child: ImageLoadingService(
                      imageUrl: item.product.imageUrl,
                      borderRadius: BorderRadius.circular(8),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item.product.title,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'تعداد',
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: onPlusButtonClcick,
                            icon: const Icon(
                              CupertinoIcons.plus_rectangle,
                              color: Colors.grey,
                            )),
                        item.changeCountLoading
                            ? SizedBox(
                                width: 20,
                                child: CupertinoActivityIndicator(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ))
                            : SizedBox(
                                width: 20,
                                child: Center(
                                  child: Text(item.count.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(fontSize: 14)),
                                ),
                              ),
                        IconButton(
                            onPressed: onMinusButtonClick,
                            icon: const Icon(
                              CupertinoIcons.minus_rectangle,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.product.previousPrice.withPriceLabel,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(decoration: TextDecoration.lineThrough),
                    ),
                    Text(item.product.price.withPriceLabel)
                  ],
                )
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          item.deleteButtonLaoding
              ? const SizedBox(
                  height: 48,
                  child: Center(child: CupertinoActivityIndicator()))
              : TextButton(
                  onPressed: ondeleteButtonClick,
                  child: const Text('حذف از سبد خرید'))
        ],
      ),
    );
  }
}
