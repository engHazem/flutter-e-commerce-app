import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';

class CustomCart extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double price;
  final int quantity;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const CustomCart({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.quantity,
    this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 50,
            height: 50,
            color: Colors.grey[300],
            child: Icon(Icons.broken_image, color: Colors.grey[700]),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
        ),
      ),
      title: Text(
        productName,
        style: TextStyle(
          color: AppColors.textColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '\$${price.toStringAsFixed(2)}',
        style: TextStyle(color: AppColors.textinputColor, fontSize: 16),
      ),
      trailing: Wrap(
        spacing: 5,
        children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: onRemove,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              '$quantity',
              style: TextStyle(color: AppColors.textColor, fontSize: 16),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.green),
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}
