import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/product.dart';
import 'package:nike_ecommerce/data/repo/cart_repository.dart';
import 'package:nike_ecommerce/data/favorite_manager.dart';
import 'package:nike_ecommerce/theme.dart';
import 'package:nike_ecommerce/ui/product/bloc/product_bloc.dart';
import 'package:nike_ecommerce/ui/product/comment/comment_list.dart';
import 'package:nike_ecommerce/ui/widgets/image.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StreamSubscription<ProductState>? streamSubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void dispose() {
    streamSubscription?.cancel();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          streamSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccess) {
              _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text('با موفقیت به سبد خرید اضافه شد')));
            } else if (state is ProductAddToCartError) {
              _scaffoldKey.currentState?.showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });

          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) => FloatingActionButton.extended(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(CartAddButtonClick(widget.product.id));
                    },
                    label: state is ProductAddToCartLoading
                        ? CupertinoActivityIndicator(
                            color: Theme.of(context).colorScheme.onSecondary,
                          )
                        : const Text('افزودن به سبد خرید')),
              ),
            ),
            body: SafeArea(
              child: CustomScrollView(
                physics: defaultScrollPhsics,
                slivers: [
                  _SliverAppBar(product: widget.product,),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(widget.product.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.product.previousPrice.withPriceLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .apply(
                                            decoration:
                                                TextDecoration.lineThrough),
                                  ),
                                  Text(
                                    widget.product.price.withPriceLabel,
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا نمیگذارد هیچ فشار مخربی به زانوان و پای شما وارد شود',
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'نظرات کاربران',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text('ثبت نظر'))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  CommentList(productId: widget.product.id)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBar extends StatefulWidget {
  const _SliverAppBar({
    Key? key,
    required this.product
  }) : super(key: key);

  final Product product;

  @override
  State<_SliverAppBar> createState() => _SliverAppBarState();
}

class _SliverAppBarState extends State<_SliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      foregroundColor: LightThemeColors.secondryColor,
      expandedHeight: MediaQuery.of(context).size.width * 0.8,
      flexibleSpace: ImageLoadingService(
        imageUrl: widget.product.imageUrl,
      ),
      actions: [
        IconButton(
            onPressed: () {
              if (favoriteManager.isFavorite(widget.product)) {
                favoriteManager.deleteFavorite(widget.product);
              } else {
                favoriteManager.addFavorite(widget.product);
              }
              setState(() {
                
              });
            },
            icon: Icon(favoriteManager.isFavorite(widget.product)
                ? CupertinoIcons.heart_fill
                : CupertinoIcons.heart))
      ],
    );
  }
}
