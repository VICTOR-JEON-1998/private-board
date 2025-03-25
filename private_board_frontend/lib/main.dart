import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ 추가
import 'views/splash_page.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(
    const ProviderScope( // ✅ Riverpod 적용!
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Private Board',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NanumGothic',
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
