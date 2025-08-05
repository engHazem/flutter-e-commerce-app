// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/App_routes.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/services/authentication_%20services.dart';
import 'package:flutter_test_project/utilits/helper.dart';
import 'package:flutter_test_project/widgets/custom_button.dart';
import 'package:flutter_test_project/widgets/custom_gap.dart';
import 'package:flutter_test_project/widgets/custom_inputtext.dart';
import 'package:flutter_test_project/widgets/custom_loading.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  late final List<TextEditingController> _controllers = [
    _emailController,
    _passwordController,
    _confirmPasswordController,
    _fullNameController,
  ];
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
          'Sign Up',
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap(height: 20),
                      CustomTextFormField(
                        controller: _fullNameController,
                        labelText: "Full Name",
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'من فضلك أدخل الاسم الكامل';
                          }
                          if (value.length < 3) {
                            return 'الاسم الكامل يجب أن يكون 3 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                      Gap(height: 10),
                      CustomTextFormField(
                        controller: _emailController,
                        labelText: "Email",
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'من فضلك أدخل البريد الإلكتروني';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'البريد الإلكتروني غير صالح';
                          }
                          if (value.length < 5) {
                            return 'البريد الإلكتروني يجب أن يكون 5 أحرف على الأقل';
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
                            return 'من فضلك أدخل كلمة المرور ';
                          }
                          if (value.length < 6) {
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                      Gap(height: 10),
                      CustomTextFormField(
                        controller: _confirmPasswordController,
                        labelText: "Confirm Password",
                        obscureText: true,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'من فضلك أدخل تاكيد كلمة المرور ';
                          }
                          if (value != _passwordController.text) {
                            return 'كلمة المرور غير متطابقة';
                          }
                          return null;
                        },
                      ),
                      Gap(height: 10),
                      _isLoading
                          ? CustomLoading(height: 30.0, width: 30.0)
                          : CustomElevatedButton(
                              text: "Sign Up",
                              onPressed: _signup,
                              loadinghight: 30,
                              loadingwidth: 30,
                            ),
                      Gap(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.login,
                              );
                            },
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                color: AppColors.buttonColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            "هل لديك حساب بالفعل ؟",
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signup() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      Authentication auth = Authentication(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      UserCredential? userCredential = await auth.signUpWithEmail();
      User? user = userCredential?.user;
      clearAllControllers(controllers: _controllers);
      _formKey.currentState!.reset();
      setState(() {
        _isLoading = false;
      });
      if (user != null) {
        await user.updateDisplayName(_fullNameController.text.trim());
      }
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      });
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
