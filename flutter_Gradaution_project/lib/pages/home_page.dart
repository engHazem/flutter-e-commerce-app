import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/services/firestore_%20services.dart';
import 'package:flutter_test_project/widgets/custom_category.dart';
import 'package:flutter_test_project/widgets/custom_grid.dart';
import 'package:flutter_test_project/widgets/custom_gap.dart';
import 'package:flutter_test_project/widgets/custom_inputtext.dart';
import 'package:flutter_test_project/widgets/custom_loading.dart';
import 'package:flutter_test_project/widgets/custom_productcard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _category = "All";
  final _textFieldController = TextEditingController();
  late Future<List<ProductCard>> _productCardsFuture;
  List<ProductCard> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    _productCardsFuture = Firestore().fetchProductCardsFromFirestore();
    _productCardsFuture.then((products) {
      setState(() {
        _allProducts = products;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: _textFieldController,
                    horizontalPadding: 0,
                    verticalPadding: 0,
                    labelText: "Search",
                    prefixIcon: Icon(Icons.search, color: AppColors.textColor),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Gap(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: CategoryChipsRow(
                spacing: 10,
                categories: ["All", "Electronics", "Books", "Fashion"],
                selectedCategory: _category,
                onCategorySelected: (category) {
                  setState(() {
                    _category = category;
                  });
                },
              ),
            ),
            Gap(height: 20),

            FutureBuilder<List<ProductCard>>(
              future: _productCardsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _allProducts.isEmpty) {
                  return const Center(
                    child: CustomLoading(width: 50, height: 50),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                List<ProductCard> filtered =
                    _category == "All" || _category.isEmpty
                    ? _allProducts
                    : _allProducts
                          .where(
                            (product) =>
                                product.category.toLowerCase() ==
                                _category.toLowerCase(),
                          )
                          .toList();
                final searchQuery = _textFieldController.text
                    .trim()
                    .toLowerCase();
                if (searchQuery.isNotEmpty) {
                  filtered = filtered.where((product) {
                    return product.productName.toLowerCase().contains(
                          searchQuery,
                        ) ||
                        product.productDescription.toLowerCase().contains(
                          searchQuery,
                        );
                  }).toList();
                }

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      "No products found.",
                      style: TextStyle(
                        color: AppColors.textinputColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return CustomGrid(products: filtered);
              },
            ),
          ],
        ),
      ),
    );
  }
}
