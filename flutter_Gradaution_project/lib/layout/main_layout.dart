import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/pages/addproduct_page.dart';
import 'package:flutter_test_project/pages/favorite_page.dart';
import 'package:flutter_test_project/pages/home_page.dart';
import 'package:flutter_test_project/pages/profile_page.dart';
import 'package:flutter_test_project/pages/cart_page.dart';
import 'package:flutter_test_project/services/authentication_%20services.dart';
import 'package:flutter_test_project/widgets/custom_gap.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  @override
  State<MainLayout> createState() => _MainPageState();
}

class _MainPageState extends State<MainLayout> {
  int _currentIndex = 0;
  String _title = 'Shop';
  Key _homePageKey = UniqueKey();

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage(key: _homePageKey);
      case 1:
        return CartPage();
      case 2:
        return const AddproductPage();
      case 3:
        return const FavoritePage();
      case 4:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _currentIndex == 0
            ? [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _homePageKey = UniqueKey();
                    });
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ]
            : null,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        title: Text(_title, style: const TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.primaryColor,
        leading: _currentIndex == 4
            ? IconButton(
                onPressed: () {
                  Authentication(context: context).logout();
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.buttonColor,
                  size: 50,
                ),
              )
            : Gap(),
      ),
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => setState(() {
          _currentIndex = value;
          if (value == 0) _title = 'Shop';
          if (value == 1) _title = 'Cart';
          if (value == 2) _title = 'Add Product';
          if (value == 3) _title = 'Favorites';
          if (value == 4) _title = 'Profile';
        }),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.textfieldColor,
        unselectedItemColor: AppColors.buttonColor,
        selectedItemColor: AppColors.textColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_sharp),
            label: 'AddProduct',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorites',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
