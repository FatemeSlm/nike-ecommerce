import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/product.dart';
import 'package:nike_ecommerce/data/repo/banner_repository.dart';
import 'package:nike_ecommerce/data/repo/product_repository.dart';
import 'package:nike_ecommerce/ui/home/bloc/home_bloc.dart';
import 'package:nike_ecommerce/ui/list/product_list.dart';
import 'package:nike_ecommerce/ui/product/product.dart';
import 'package:nike_ecommerce/ui/widgets/error.dart';
import 'package:nike_ecommerce/ui/widgets/slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
            bannerRepository: bannerRepository,
            productRepository: productRepository);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                return ListView.builder(
                    physics: defaultScrollPhsics,
                    itemCount: 5,
                    itemBuilder: ((context, index) {
                      switch (index) {
                        case 0:
                          return Container(
                            height: 56,
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/img/nike_logo.png',
                              height: 23,
                              fit: BoxFit.fitHeight,
                            ),
                          );
                        case 2:
                          return BannerSlider(
                            banners: state.banners,
                          );
                        case 3:
                          return _HorizontalProductList(
                            title: 'جدید ترین',
                            products: state.latestProducts,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) =>
                                      const ProductListScreen(
                                          sort: ProductSort.latest))));
                            },
                          );
                        case 4:
                          return _HorizontalProductList(
                            title: 'پربازدید ترین',
                            products: state.popularProducts,
                            onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) =>
                                      const ProductListScreen(
                                          sort: ProductSort.popular))));
                            },
                          );
                        default:
                          return Container();
                      }
                    }));
              } else if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HomeError) {
                return AppErrorWidget(
                  exception: state.exception,
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                  },
                );
              } else {
                throw Exception('state is not supported.');
              }
            },
          ),
        ),
      ),
    );
  }
}

class _HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<Product> products;

  const _HorizontalProductList({
    Key? key,
    required this.title,
    required this.onTap,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextButton(onPressed: onTap, child: const Text('مشاهده همه'))
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
              physics: defaultScrollPhsics,
              padding: const EdgeInsets.only(left: 8, right: 8),
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                final product = products[index];
                return ProductItem(
                  product: product,
                  borderRadius: BorderRadius.circular(12),
                );
              })),
        )
      ],
    );
  }
}
