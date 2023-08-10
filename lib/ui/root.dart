import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce/data/repo/cart_repository.dart';
import 'package:nike_ecommerce/ui/cart/cart.dart';
import 'package:nike_ecommerce/ui/home/home.dart';
import 'package:nike_ecommerce/ui/profile/profile.dart';
import 'package:nike_ecommerce/ui/widgets/badge.dart';

const int homeIndex = 0;
const int cartIndex = 1;
const int profileIndex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedTab = homeIndex;
  final List<int> _history = [];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    profileIndex: _profileKey,
  };

  Future<bool> _onWillPop() async {
    final NavigatorState navigatorSelectedSate =
        map[selectedTab]!.currentState!;
    if (navigatorSelectedSate.canPop()) {
      navigatorSelectedSate.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedTab = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                _history.remove(selectedTab);
                _history.add(selectedTab);
                selectedTab = index;
              });
            },
            currentIndex: selectedTab,
            items: [
              const BottomNavigationBarItem(

                  icon: Icon(CupertinoIcons.home), label: 'خانه'),
              BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(CupertinoIcons.cart),
                      // Positioned(
                      //     right: -10,
                      //     child: ValueListenableBuilder<int>(
                      //         valueListenable:
                      //             CartRepository.cartItemCountNotifier,
                      //         builder: (context, value, child) {
                      //           return Badge(value: value);
                      //         }))
                    ],
                  ),
                  label: 'سبد خرید'),
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person), label: 'پروفایل'),
            ]),
        body: IndexedStack(
          index: selectedTab,
          children: [
            _navigator(_homeKey, homeIndex, const HomeScreen()),
            _navigator(_cartKey, cartIndex, const CartScreen()),
            _navigator(_profileKey, profileIndex, const ProfileScreen()),
          ],
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Widget _navigator(GlobalKey key, int index, Widget widget) {
    return key.currentState == null && selectedTab != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) =>
                    Offstage(offstage: selectedTab != index, child: widget)));
  }

  @override
  void initState() {
    cartRepository.count();
    super.initState();
  }
}
