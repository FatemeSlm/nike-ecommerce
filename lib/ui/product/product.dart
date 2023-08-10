import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/product.dart';
import 'package:nike_ecommerce/data/favorite_manager.dart';
import 'package:nike_ecommerce/ui/product/details.dart';
import 'package:nike_ecommerce/ui/widgets/image.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    Key? key,
    required this.product,
    required this.borderRadius,
    this.itemWidth = 176,
    this.itemHeight = 189,
  }) : super(key: key);

  final Product product;
  final BorderRadius borderRadius;
  final double itemWidth;
  final double itemHeight;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ValueListenableBuilder<Box<Product>>(
          valueListenable: favoriteManager.listenable,
          builder: (context, box, child) {
            return InkWell(
              borderRadius: widget.borderRadius,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                        product: widget.product,
                      ))),
              child: SizedBox(
                width: widget.itemWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 0.93,
                          child: ImageLoadingService(
                            imageUrl: widget.product.imageUrl,
                            borderRadius: widget.borderRadius,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: InkWell(
                            onTap: () {
                              if (!favoriteManager.isFavorite(widget.product)) {
                                favoriteManager.addFavorite(widget.product);
                              } else {
                                favoriteManager.deleteFavorite(widget.product);
                              }
                              
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Icon(
                                favoriteManager.isFavorite(widget.product)
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: Text(
                        widget.product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Text(
                        widget.product.previousPrice.withPriceLabel,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(decoration: TextDecoration.lineThrough),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(widget.product.price.withPriceLabel),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
