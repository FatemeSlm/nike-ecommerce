import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/data/repo/product_repository.dart';
import 'package:nike_ecommerce/ui/list/bloc/product_list_bloc.dart';
import 'package:nike_ecommerce/ui/product/product.dart';
import 'package:nike_ecommerce/ui/widgets/error.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;

  const ProductListScreen({Key? key, required this.sort}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType { grid, list }

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViewType viewType = ViewType.grid;

  @override
  void dispose() {
    bloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('کفش های ورزشی'),
        centerTitle: true,
      ),
      body: BlocProvider<ProductListBloc>(create: (context) {
        bloc = ProductListBloc(productRepository)
          ..add(ProductListStarted(widget.sort));

        return bloc!;
      }, child: BlocBuilder<ProductListBloc, ProductListState>(
        builder: (context, state) {
          if (state is ProductListSuccess) {
            final products = state.products;
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: Theme.of(context).dividerColor, width: 1),
                      ),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20)
                      ]),
                  height: 52,
                  child: Row(children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24))),
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24, bottom: 24),
                                    child: Column(
                                      children: [
                                        Text(
                                          'انتخاب مرتب سازی',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: state.sortNames.length,
                                              itemBuilder: (context, index) {
                                                final selectedSortIndex =
                                                    state.sort;
                                                return InkWell(
                                                  onTap: () {
                                                    bloc!.add(
                                                        ProductListStarted(
                                                            index));
                                                    Navigator.pop(context);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(16, 8, 16, 8),
                                                    child: SizedBox(
                                                      height: 30,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            state.sortNames[
                                                                index],
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          if (selectedSortIndex ==
                                                              index)
                                                            Icon(
                                                              CupertinoIcons
                                                                  .check_mark_circled_solid,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.sort_down)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('مرتب سازی'),
                                  Text(
                                    state.sortNames[state.sort],
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 0.9,
                      color: Theme.of(context).dividerColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              viewType = viewType == ViewType.grid
                                  ? ViewType.list
                                  : ViewType.grid;
                            });
                          },
                          icon: Icon(viewType == ViewType.grid
                              ? CupertinoIcons.square_grid_2x2
                              : CupertinoIcons.list_bullet)),
                    )
                  ]),
                ),
                Expanded(
                  child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.65,
                          crossAxisCount: viewType == ViewType.grid ? 2 : 1),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItem(
                            product: product, borderRadius: BorderRadius.zero);
                      }),
                ),
              ],
            );
          } else if (state is ProductListLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is ProductListError) {
            return AppErrorWidget(
              exception: state.appException,
              onPressed: () {},
            );
          } else {
            throw Exception('state is not supported.');
          }
        },
      )),
    );
  }
}
