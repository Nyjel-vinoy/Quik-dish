import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:quicke/pages/home.dart';
import 'package:quicke/pages/order.dart';
import 'package:quicke/pages/profile.dart';
import 'package:quicke/pages/wallet.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int currentTabindex = 0;
  late List<Widget> pages;
  late Widget currentPage;
  late Home homePage;
  late Profile profile;
  late Order order;
  late Wallet wallet;
  @override
  void initState() {
    homePage = Home();
    order = Order();
    profile = Profile();
    wallet = Wallet();
    pages = [homePage, order, wallet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65.0,
          backgroundColor: Colors.black,
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabindex = index;
            });
          },
          items: [
            Icon(
              Icons.home_outlined,
              color: Colors.black,
            ),
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
            Icon(
              Icons.wallet_outlined,
              color: Colors.black,
            ),
            Icon(
              Icons.person_outline,
              color: Colors.black,
            ),
          ]),
      body: SafeArea(child: pages[currentTabindex]),
    );
  }
}
