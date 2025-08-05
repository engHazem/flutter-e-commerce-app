import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/widgets/custom_button.dart';
import 'package:flutter_test_project/widgets/custom_cart.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _cartbox = Hive.box('cartBox');

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  List<Map<String, dynamic>> _getCartItems() {
    return _cartbox.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  double _getTotalPrice(List<Map<String, dynamic>> cartItems) {
    double total = 0.0;
    for (var item in cartItems) {
      total += item['productPrice'] * item['quantity'];
    }
    return total;
  }

  void _updateQuantity(String productId, int newQuantity) {
    final item = _cartbox.get(productId);
    if (item != null) {
      final updatedItem = Map<String, dynamic>.from(item);
      if (newQuantity <= 0) {
        _cartbox.delete(productId);
      } else {
        updatedItem['quantity'] = newQuantity;
        _cartbox.put(productId, updatedItem);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _cartbox.listenable(),
      builder: (context, Box box, _) {
        final cartItems = _getCartItems();
        final totalPrice = _getTotalPrice(cartItems);

        return Column(
          children: [
            ?cartItems.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '${cartItems.length} items',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textinputColor,
                      ),
                    ),
                  )
                : null,
            Expanded(
              child: cartItems.isEmpty
                  ? Center(
                      child: Text(
                        'Your cart is empty',
                        style: TextStyle(
                          color: AppColors.textinputColor,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return CustomCart(
                          imageUrl: item['productImage'],
                          productName: item['productName'],
                          price: item['productPrice'],
                          quantity: item['quantity'],
                          onAdd: () => _updateQuantity(
                            item['productId'],
                            item['quantity'] + 1,
                          ),
                          onRemove: () => _updateQuantity(
                            item['productId'],
                            item['quantity'] - 1,
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: cartItems.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textinputColor,
                          ),
                        ),
                        const Spacer(),
                        CustomElevatedButton(
                          icon: Icon(Icons.payment, color: AppColors.textColor),
                          text: 'Checkout',
                          onPressed: () {},
                          width: 155,
                          height: 45,
                          borderredius: 10,
                        ),
                      ],
                    )
                  : null,
            ),
          ],
        );
      },
    );
  }
}
