import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/Models/cart_model.dart';
import 'package:GroceryApp/allProviders/cart_provider.dart';
import 'package:GroceryApp/screens/categories_screen/categories_screen.dart';
import 'package:GroceryApp/screens/Buttom_bar_screens/Home_Screen.dart';
import 'package:GroceryApp/screens/Buttom_bar_screens/user.dart';
import 'package:badges/badges.dart' as badge;
import 'allProviders/DarkThemeProvider.dart';
import 'screens/cart/cart_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {
      'page': const HomeScreen(),
    },
    {
      'page': const CategoryScreen(),
    },
    {
      'page': const CartScreen(),
    },
    {
      'page': const UserScreen(),
    },
  ];

  void _selectedPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final cartProvider= Provider.of<CartProvider>(context);
    final List<CartModel> productsInCart =  cartProvider.getCartItems.values.toList();
    return Scaffold(
      body: _pages[selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: isDark ? Colors.white10 : Colors.black87,
        selectedItemColor: isDark ? Colors.lightBlue.shade200 : Colors.black87,
        backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon:
                  Icon(selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(selectedIndex == 1
                  ? IconlyBold.category
                  : IconlyLight.category),
              label: 'Category'),
          BottomNavigationBarItem(
              icon: badge.Badge(
                badgeAnimation: const badge.BadgeAnimation.slide(),
                badgeStyle: badge.BadgeStyle(
                  shape: badge.BadgeShape.circle,
                  badgeColor: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                position: badge.BadgePosition.topEnd(top: -7, end: -7),
                badgeContent: FittedBox(
                    child:Text(productsInCart.length.toString(),style: const TextStyle(fontSize: 12),),
                ),
                  child: Icon(
                      selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),

              ),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(
                  selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
              label: 'User'),
        ],
      ),
    );
  }
}
