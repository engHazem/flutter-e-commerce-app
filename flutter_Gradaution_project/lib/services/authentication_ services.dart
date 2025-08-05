// ignore_for_file: file_names, prefer_typing_uninitialized_variables, strict_top_level_inference

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/App_routes.dart';
import 'package:flutter_test_project/utilits/helper.dart';

class Authentication {
  final String? email;
  final String? password;
  final context;
  Authentication({this.context, this.email, this.password});
  Future<UserCredential?> signUpWithEmail() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      showStatusSnackBar(
        context: context,
        isSuccess: true,
        message: "تم إنشاء الحساب بنجاح",
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showStatusSnackBar(
          context: context,
          isSuccess: false,
          message: 'كلمة المرور ضعيفة جدًا.',
        );
      } else if (e.code == 'email-already-in-use') {
        showStatusSnackBar(
          context: context,
          isSuccess: false,
          message: 'البريد الإلكتروني مستخدم بالفعل.',
        );
      } else {
        showStatusSnackBar(
          context: context,
          isSuccess: false,
          message: 'حدث خطأ: ${e.message}',
        );
      }
    } catch (e) {
      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: 'حدث خطأ: $e',
      );
    }

    return null;
  }

  Future<bool> loginWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      showStatusSnackBar(
        context: context,
        isSuccess: true,
        message: "تم تسجيل الدخول بنجاح",
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = switch (e.code) {
        'user-not-found' => 'لا يوجد مستخدم مسجل بهذا البريد الإلكتروني.',
        'wrong-password' => 'كلمة المرور غير صحيحة.',
        'invalid-email' => 'البريد الإلكتروني غير صالح.',
        _ => 'حدث خطأ: ${e.message}',
      };

      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: errorMessage,
      );
    } catch (e) {
      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: 'حدث خطأ: $e',
      );
    }
    return false;
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      showStatusSnackBar(
        context: context,
        isSuccess: true,
        message: 'تم تسجيل الخروج بنجاح',
      );

      // يرجعك إلى صفحة تسجيل الدخول أو أي صفحة تحددها
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.welcome,
        (route) => false,
      );
    } catch (e) {
      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: 'حدث خطأ أثناء تسجيل الخروج: $e',
      );
    }
  }

  User? getCurrentUserInfo() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }
}
