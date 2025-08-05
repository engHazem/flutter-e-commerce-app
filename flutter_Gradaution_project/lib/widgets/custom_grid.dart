import 'package:flutter/material.dart';
import 'package:flutter_test_project/widgets/custom_productcard.dart';

// ignore: must_be_immutable
class CustomGrid extends StatelessWidget {
  List<ProductCard> products;
  CustomGrid({super.key, required this.products});

  @override
  Widget build(Object context) {
    return Expanded(
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 15,
          childAspectRatio: 0.75,
        ),
        children: products,
      ),
    );
  }
}
