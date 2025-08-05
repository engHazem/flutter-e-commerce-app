import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/widgets/custom_grid.dart';
import 'package:flutter_test_project/widgets/custom_productcard.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _favbox = Hive.box('favoriteBox');

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<Box>(
            valueListenable: _favbox.listenable(),
            builder: (context, box, _) {
              final items = box.values.toList();
              if (items.isEmpty) {
                return const Center(
                  child: Text(
                    "No favorites found.",
                    style: TextStyle(
                      color: AppColors.textinputColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              final favorites = items.map((item) {
                return ProductCard(
                  productId: item['productId'],
                  productName: item['productName'],
                  productPrice: item['productPrice'],
                  productImage: item['productImage'],
                  productDescription: item['productDescription'],
                  category: item['category'],
                );
              }).toList();
              return CustomGrid(products: favorites);
            },
          ),
        ],
      ),
    );
  }
}
