import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';

class CategoryChipsRow extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final double spacing;

  const CategoryChipsRow({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.spacing = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: categories.map((category) {
        final isSelected = selectedCategory == category;
        return Padding(
          padding: EdgeInsets.only(right: spacing),
          child: ChoiceChip(
            selectedShadowColor: AppColors.buttonColor,
            checkmarkColor: AppColors.textColor,
            side: BorderSide(
              color: isSelected
                  ? AppColors.buttonColor
                  : AppColors.textfieldColor,
            ),
            label: Text(category),
            labelStyle: TextStyle(color: AppColors.textinputColor),
            backgroundColor: AppColors.textfieldColor,
            selectedColor: AppColors.buttonColor,
            disabledColor: AppColors.textfieldColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            selected: isSelected,
            onSelected: (selected) {
              onCategorySelected(selected ? category : '');
            },
          ),
        );
      }).toList(),
    );
  }
}
