import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/services/hive_services.dart';
import 'package:flutter_test_project/utilits/helper.dart';
import 'package:flutter_test_project/widgets/custom_button.dart';
import 'package:flutter_test_project/widgets/custom_gap.dart';
import 'package:flutter_test_project/widgets/custom_loading.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productDescription,
    required this.productId,
  });
  final String productName;
  final double productPrice;
  final String productImage;
  final String productDescription;
  final String productId;
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  // Variable to track loading state
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    Future<void> addToCart() async {
      setState(() {
        _isloading = true;
        writeDataToCartbox(
          productId: widget.productId,
          productName: widget.productName,
          productPrice: widget.productPrice,
          productImage: widget.productImage,
        );
      });

      await Future.delayed(const Duration(seconds: 1), () {});
      showStatusSnackBar(
        // ignore: use_build_context_synchronously
        context: context,
        isSuccess: true,
        message: "${widget.productName} added to cart",
      );
      setState(() {
        _isloading = false;
      });
      Future.delayed(const Duration(seconds: 1), () {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        ),
        title: Text(
          'Product Details',
          style: TextStyle(color: AppColors.textColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.productImage,
              height: 200,
              width: double.infinity,
              fit: BoxFit.scaleDown,
            ),
            Gap(height: 16),
            Text(
              widget.productName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            Gap(height: 8),
            Text(
              '\$${widget.productPrice}',
              style: TextStyle(fontSize: 20, color: AppColors.textinputColor),
            ),
            Gap(height: 16),
            Text(
              widget.productDescription,
              style: TextStyle(fontSize: 16, color: AppColors.textColor),
            ),
            Spacer(),
            _isloading
                ? Center(child: CustomLoading(height: 30, width: 30))
                : CustomElevatedButton(
                    icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                    text: 'Add to Cart',
                    onPressed: addToCart,
                    width: double.infinity,
                    height: 50,
                    backgroundColor: AppColors.buttonColor,
                    textColor: Colors.white,
                    borderredius: 30.0,
                  ),
            Gap(height: 20),
          ],
        ),
      ),
    );
  }
}
