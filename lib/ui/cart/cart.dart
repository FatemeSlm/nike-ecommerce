import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_ecommerce/data/repo/auth_repository.dart';
import 'package:nike_ecommerce/data/repo/cart_repository.dart';
import 'package:nike_ecommerce/ui/auth/auth.dart';
import 'package:nike_ecommerce/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_ecommerce/ui/cart/cart_item.dart';
import 'package:nike_ecommerce/ui/cart/price_info.dart';
import 'package:nike_ecommerce/ui/shipping/shipping.dart';
import 'package:nike_ecommerce/ui/widgets/empty_state.dart';
import 'package:nike_ecommerce/ui/widgets/error.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  final RefreshController _refreshController = RefreshController();
  StreamSubscription? streamSubscription;
  bool stateIsSuccess = false;

  @override
  void initState() {
    AuthRepository.authChangeNotifire.addListener(authCahngeNotifireListener);
    super.initState();
  }

  void authCahngeNotifireListener() {
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifire.value));
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifire
        .removeListener(authCahngeNotifireListener);
    cartBloc?.close();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('سبد خرید'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: stateIsSuccess,
          child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 48, right: 48),
              child: FloatingActionButton.extended(
                  onPressed: () {
                    final state = cartBloc?.state;
                    if(state is CartSuccess){
                      Navigator.of(context).push(MaterialPageRoute(builder: ((context) =>  ShippingScreen(
                        shippingCost: state.cartResponse.shippingCost,
                        totalPrice: state.cartResponse.totalPrice,
                        payablePrice: state.cartResponse.payablePrice,

                      ))));

                    }
                    
                  }, label: const Text('پرداخت'))),
        ),
        body: BlocProvider<CartBloc>(
          create: (context) {
            final bloc = CartBloc(cartRepository);
            streamSubscription = bloc.stream.listen((state) {
              setState(() {
                stateIsSuccess = state is CartSuccess;
              });

              if (_refreshController.isRefresh) {
                if (state is CartSuccess || state is CartEmpty) {
                  _refreshController.refreshCompleted();
                } else if (state is CartError) {
                  _refreshController.refreshFailed();
                }
              }
            });
            cartBloc = bloc;
            bloc.add(CartStarted(AuthRepository.authChangeNotifire.value));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CartError) {
                return AppErrorWidget(
                    exception: state.appException, onPressed: () {});
              } else if (state is CartSuccess || state is CartEmpty) {
                return SmartRefresher(
                  header: const ClassicHeader(
                    completeText: 'با موفقیت انجام شد',
                    refreshingText: 'در حال بروزرسانی',
                    idleText: 'برای بروزرسانی صفحه را به پایین بکشید',
                    releaseText: 'رها کنید',
                    failedText: 'خطای نامشخص',
                    spacing: 2,
                    completeIcon: Icon(
                      CupertinoIcons.checkmark_circle,
                      color: Colors.grey,
                      size: 22,
                    ),
                  ),
                  onRefresh: () {
                    cartBloc?.add(CartStarted(
                        AuthRepository.authChangeNotifire.value,
                        isRefreshing: true));
                  },
                  controller: _refreshController,
                  child: state is CartSuccess
                      ? ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: state.cartResponse.cartItems.length + 1,
                          itemBuilder: (context, index) {
                            if (index < state.cartResponse.cartItems.length) {
                              final data = state.cartResponse.cartItems[index];
                              return CartItem(
                                item: data,
                                ondeleteButtonClick: () {
                                  cartBloc
                                      ?.add(CartDeleteButtonClicked(data.id));
                                },
                                onPlusButtonClcick: () {
                                  if (data.count < 5) {
                                    cartBloc
                                        ?.add(CartPlusButtonClicked(data.id));
                                  }
                                },
                                onMinusButtonClick: () {
                                  if (data.count > 1) {
                                    cartBloc
                                        ?.add(CartMinusButtonClicked(data.id));
                                  }
                                },
                              );
                            } else {
                              return PriceInfo(
                                payablePrice: state.cartResponse.payablePrice,
                                shippingCost: state.cartResponse.shippingCost,
                                totalPrice: state.cartResponse.totalPrice,
                              );
                            }
                          })
                      : EmptyView(
                          message: 'محصولی به سبد خرید خود اضافه نکرده اید',
                          image: SvgPicture.asset(
                            'assets/img/empty_cart.svg',
                            width: 200,
                          )),
                );
              } else if (state is CartAuthRequired) {
                return EmptyView(
                    message:
                        'برای مشاهده سبد خرید ابتدا وارد حساب کاربری خود شوید',
                    callToAction: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                              builder: ((context) => const AuthScreen())));
                        },
                        child: const Text('ورود به حساب کاربری')),
                    image: SvgPicture.asset(
                      'assets/img/auth_required.svg',
                      width: 140,
                    ));
              } else {
                throw Exception('state is not supported');
              }
            },
          ),
        ));
  }
}
