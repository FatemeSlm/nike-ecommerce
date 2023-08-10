import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce/data/auth_info.dart';
import 'package:nike_ecommerce/data/repo/auth_repository.dart';
import 'package:nike_ecommerce/data/repo/cart_repository.dart';
import 'package:nike_ecommerce/ui/auth/auth.dart';
import 'package:nike_ecommerce/ui/favorites/favorites.dart';
import 'package:nike_ecommerce/ui/order/order_history.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پروفایل'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<AuthInfo?>(
          valueListenable: AuthRepository.authChangeNotifire,
          builder: (context, authinfo, childe) {
            final isLogin = authinfo != null && authinfo.accessToken.isNotEmpty;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 10),
                      padding: const EdgeInsets.all(8),
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).dividerColor, width: 1)),
                      child: Image.asset('assets/img/nike_logo.png')),
                  Text(isLogin ? authinfo.email : 'کاربر مهمان'),
                  const SizedBox(
                    height: 32,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FavoriteListScreen()));
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        children: [
                          Row(
                            children: const [
                              Icon(CupertinoIcons.heart),
                              SizedBox(
                                width: 16,
                              ),
                              Text('لیست علاقه مندی ها')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrderHistoryScreen()));
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        children: [
                          Row(
                            children: const [
                              Icon(CupertinoIcons.cart),
                              SizedBox(
                                width: 16,
                              ),
                              Text('سوابق سفارش')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      isLogin
                          ? showDialog(
                              context: context,
                              useRootNavigator: true,
                              builder: (context) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    title: const Text('خروج از حساب کاربری'),
                                    content: const Text(
                                        'آیا می خواهید از حساب خود خارج شوید؟'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            CartRepository.cartItemCountNotifier
                                                .value = 0;
                                            authRepository.signOut();
                                          },
                                          child: const Text('بله')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('خیر')),
                                    ],
                                  ),
                                );
                              })
                          : Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()));
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(isLogin
                                  ? CupertinoIcons.arrow_right_square
                                  : CupertinoIcons.arrow_left_square),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(isLogin
                                  ? 'خروج از حساب کاربری'
                                  : 'ورود به حساب کاربری')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
