import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/App_routes.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/widgets/custom_button.dart';
import 'package:flutter_test_project/widgets/custom_gap.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isFinished = true;
      });
    });
  }

  Widget _buildWelcomeContent() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedOpacity(
          opacity: _isFinished ? 1.0 : 0,
          duration: const Duration(milliseconds: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome to Our App",
                style: TextStyle(
                  color: AppColors.textinputColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(height: 5),
              Text(
                "Discover amazing products and deals",
                style: TextStyle(
                  color: AppColors.buttonColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Gap(height: 30),
              CustomElevatedButton(
                icon: Icon(Icons.login_outlined, color: AppColors.textColor),
                text: 'Login',
                backgroundColor: AppColors.buttonColor,
                textColor: AppColors.textColor,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
              ),
              Gap(height: 20),
              CustomElevatedButton(
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: AppColors.textColor,
                ),
                text: 'Sign Up',
                backgroundColor: AppColors.textfieldColor,
                textColor: AppColors.textColor,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: 0.6,
            duration: const Duration(seconds: 2),
            child: Image.asset(
              'assets/images/home_background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          if (_isFinished) _buildWelcomeContent(),
        ],
      ),
    );
  }
}
