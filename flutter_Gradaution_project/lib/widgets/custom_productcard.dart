import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/pages/product_details.dart';
import 'package:flutter_test_project/services/hive_services.dart';
import 'package:flutter_test_project/utilits/helper.dart';
import 'package:flutter_test_project/widgets/custom_gap.dart';

class ProductCard extends StatefulWidget {
  final String productName;
  final double productPrice;
  final String productImage;
  final String productDescription;
  final String category;
  final String productId;

  const ProductCard({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productDescription,
    required this.category,
    required this.productId,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = isProductInFavoriteBox(widget.productId);
  }

  void addToCart() {
    writeDataToCartbox(
      productId: widget.productId,
      productName: widget.productName,
      productPrice: widget.productPrice,
      productImage: widget.productImage,
    );
    showStatusSnackBar(
      context: context,
      isSuccess: true,
      message: "${widget.productName} added to cart",
    );
  }

  void toggleFavorite() {
    setState(() {
      if (_isFavorite) {
        removeFromFavoriteBox(widget.productId);
      } else {
        writeDataToFavoritebox(
          productId: widget.productId,
          productName: widget.productName,
          productImage: widget.productImage,
          productPrice: widget.productPrice,
          productDescription: widget.productDescription,
          category: widget.category,
        );
      }
      _isFavorite = !_isFavorite;
    });
    showStatusSnackBar(
      context: context,
      isSuccess: true,
      message: _isFavorite
          ? "${widget.productName} added to favorites"
          : "${widget.productName} removed from favorites",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(
              productName: widget.productName,
              productPrice: widget.productPrice,
              productImage: widget.productImage,
              productDescription: widget.productDescription,
              productId: widget.productId,
            ),
          ),
        );
      },
      child: Container(
        color: AppColors.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 170,
                      child: Image.network(
                        widget.productImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                      onPressed: toggleFavorite,
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite
                            // ignore: use_full_hex_values_for_flutter_colors
                            ? Color(0xfffc41010)
                            : AppColors.buttonColor,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(height: 5),
            Text(
              widget.productName,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  '\$${widget.productPrice}',
                  style: TextStyle(
                    color: AppColors.textinputColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: addToCart,
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline_sharp,
                        color: AppColors.textinputColor,
                        size: 16,
                      ),
                      const Gap(width: 5),
                      Text(
                        'Cart',
                        style: TextStyle(
                          color: AppColors.textinputColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
