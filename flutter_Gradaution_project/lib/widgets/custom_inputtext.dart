// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/constants/textinput_decoration.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Icon? prefixIcon;
  final double horizontalPadding;
  final double verticalPadding;
  // ignore: strict_top_level_inference
  final maxLines;
  final Function(String)? onChanged;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.horizontalPadding = 20.0,
    this.verticalPadding = 10.0,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardType,
        obscureText: obscureText,
        cursorColor: AppColors.textinputColor,
        validator: validator,
        decoration: style.copyWith(
          labelText: labelText,
          prefixIcon: prefixIcon,
        ),
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.textinputColor),
      ),
    );
  }
}
