import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/App_routes.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/layout/main_layout.dart';
import 'package:flutter_test_project/pages/login_page.dart';
import 'package:flutter_test_project/pages/signup_page.dart';
import 'package:flutter_test_project/pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.openBox('cartBox');
  Hive.openBox('favoriteBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(Object context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        AppRoutes.welcome: (context) => WelcomePage(),
        AppRoutes.login: (context) => LoginPage(),
        AppRoutes.signup: (context) => SignupPage(),
        AppRoutes.main: (context) => MainLayout(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.primaryColor),
        scaffoldBackgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
