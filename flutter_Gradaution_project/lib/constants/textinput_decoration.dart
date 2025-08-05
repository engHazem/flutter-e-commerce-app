import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';

InputDecoration style = InputDecoration(
  labelStyle: const TextStyle(color: AppColors.textinputColor),
  fillColor: AppColors.textfieldColor,
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: AppColors.buttonColor, width: 1.0),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.red, width: 1.0),
  ),
);
