import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/widgets/custom_loading.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderredius;
  final Icon? icon;
  final bool? isloading;
  final double loadinghight;
  final double loadingwidth;
  const CustomElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 380,
    this.height = 50,
    this.backgroundColor,
    this.textColor,
    this.borderredius = 0.0,
    this.isloading,
    this.loadinghight = 50.0,
    this.loadingwidth = 50.0,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderredius),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton.icon(
          icon: icon,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          label: isloading == true
              ? CustomLoading(width: width, height: height)
              : Text(
                  text,
                  style: TextStyle(
                    color: textColor ?? AppColors.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
