import 'package:flutter/material.dart';
import '../views/splash_page.dart';
import '../views/login_page.dart';
import '../views/home_page.dart';
import '../views/write_page.dart';
import '../views/profile_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashPage(),
  '/login': (context) => const LoginPage(),
  '/home': (context) => const HomePage(),
  '/write': (context) => const WritePage(),
  '/profile': (context) => const ProfilePage(),
};
