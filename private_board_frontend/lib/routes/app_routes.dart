import 'package:flutter/material.dart';
import '../views/splash_page.dart';
import '../views/login_page.dart';
import '../views/home_page.dart';
import '../views/write_page.dart';
import '../views/profile_page.dart';
import '../pages/create_group_page.dart';
import '../pages/join_group_page.dart';
import '../pages/group_home_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashPage(),
  '/login': (context) => const LoginPage(),
  '/home': (context) => const HomePage(),
  '/write': (context) => const WritePage(),
  '/profile': (context) => const ProfilePage(),
  '/join-group': (context) => const JoinGroupPage(),
  '/group': (context) => const GroupHomePage(userId: ''), // 👉 추후 실제 userId 넘길 것
};
