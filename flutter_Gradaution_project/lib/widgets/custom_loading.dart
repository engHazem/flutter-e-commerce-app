import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final double width;
  final double height;
  const CustomLoading({super.key, required this.width, required this.height});
  @override
  Widget build(Object context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0),
      ),
    );
  }
}
