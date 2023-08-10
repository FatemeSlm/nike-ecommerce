import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/product.dart';
import 'package:nike_ecommerce/data/favorite_manager.dart';
import 'package:nike_ecommerce/theme.dart';
import 'package:nike_ecommerce/ui/product/details.dart';
import 'package:nike_ecommerce/ui/widgets/image.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست علاقه مندی ها'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Product>>(
          valueListenable: favoriteManager.listenable,
          builder: (context, box, child) {
            final products = box.values.toList();
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 100),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 16, right: 16),
                  child: InkWell(
                    onLongPress: () {
                      favoriteManager.deleteFavorite(product);
                    },
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product)));
                    },
                    child: SizedBox(
                      height: 120,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 110,
                              height: 110,
                              child: ImageLoadingService(
                                imageUrl: product.imageUrl,
                                borderRadius: BorderRadius.circular(8),
                              )),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 8, right: 16),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              color: LightThemeColors
                                                  .primaryTextColor,
                                              fontSize: 14),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      product.previousPrice.withPriceLabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .apply(
                                              decoration:
                                                  TextDecoration.lineThrough),
                                    ),
                                    Text(product.price.withPriceLabel)
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
