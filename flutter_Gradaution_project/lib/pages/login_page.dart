// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/App_routes.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/services/authentication_%20services.dart';
import 'package:flutter_test_project/utilits/helper.dart';
import 'package:flutter_test_project/widgets/custom_button.dart';
import 'package:flutter_test_project/widgets/custom_inputtext.dart';
import 'package:flutter_test_project/widgets/custom_gap.dart';
import 'package:flutter_test_project/widgets/custom_loading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final List<TextEditingController> _controllers = [
    _emailController,
    _passwordController,
  ];
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        ),
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Gap(height: 20),
                    CustomTextFormField(
                      controller: _emailController,
                      labelText: "Email",
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'من فضلك أدخل البريد الإلكتروني';
                        }
                        return null;
                      },
                    ),
                    Gap(height: 10),
                    CustomTextFormField(
                      controller: _passwordController,
                      labelText: "Password",
                      obscureText: true,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'من فضلك أدخل كلمة المرور';
                        }
                        return null;
                      },
                    ),
                    Gap(height: 10),
                    _isLoading
                        ? CustomLoading(height: 30.0, width: 30.0)
                        : CustomElevatedButton(
                            text: "Login",
                            onPressed: _login,
                            loadinghight: 30.0,
                            loadingwidth: 30.0,
                          ),
                    Gap(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.signup,
                            );
                          },
                          child: Text(
                            'تسجيل ',
                            style: TextStyle(
                              color: AppColors.buttonColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          "ليس لديك حساب ؟",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool success = await Authentication(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).loginWithEmail();

      setState(() {
        _isLoading = false;
      });

      clearAllControllers(controllers: _controllers);
      _formKey.currentState!.reset();
      if (success) {
        await Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, AppRoutes.main);
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: "من فضلك أكمل جميع الحقول بشكل صحيح",
      );
    }
  }
}
