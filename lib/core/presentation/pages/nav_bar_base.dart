import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kitaby/features/authentication/presentation/pages/login_page.dart';
import 'package:kitaby/features/cart/presentation/pages/cart_page.dart';
import 'package:kitaby/features/favorites/presentation/pages/favorites_page.dart';
import 'package:kitaby/features/order/presentation/pages/orders_page.dart';
import 'package:kitaby/features/store_books/presentation/pages/store_books_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/authentication/data/models/user_model.dart';
import '../../../features/home/presentation/pages/home_page.dart';

class NavBarBase extends StatefulWidget {
  const NavBarBase({
    Key? key,
  }) : super(key: key);

  @override
  State<NavBarBase> createState() => _NavBarBaseState();
}

class _NavBarBaseState extends State<NavBarBase> {
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final String? result = prefs.getString('user');

    if (result != null) {
      final value = jsonDecode(result);
      // await prefs.remove('user');
      return UserModel.fromJson(value);
    } else {
      return null;
    }
  }

  int currentIndex = 0;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const HomePage(),
      const StoreBooksPage(),
      const CartPage(),
      const OrdersPage(),
      const FavoritesPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  setState(
                    () {
                      currentIndex = 0;
                    },
                  );
                },
                child: Icon(
                  Icons.home_filled,
                  color: accentColor,
                ),
              ),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  setState(
                    () {
                      currentIndex = 1;
                    },
                  );
                },
                child: Icon(
                  Icons.menu_book_rounded,
                  color: accentColor,
                ),
              ),
              label: 'books',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () async {
                  final result = await getUser();
                  if (result != null) {
                    setState(
                      () {
                        currentIndex = 2;
                      },
                    );
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    );
                  }
                },
                child: Icon(
                  Icons.shopping_cart_rounded,
                  color: accentColor,
                ),
              ),
              label: 'cart',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  setState(
                    () {
                      currentIndex = 3;
                    },
                  );
                },
                child: Icon(
                  Icons.shopify,
                  color: accentColor,
                ),
              ),
              label: 'orders',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () async {
                  final result = await getUser();
                  if (result != null) {
                    setState(
                      () {
                        currentIndex = 4;
                      },
                    );
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    );
                  }
                },
                child: Icon(
                  Icons.favorite,
                  color: accentColor,
                ),
              ),
              label: 'favorites',
            ),
          ],
        ),
      ),
    );
  }
}
