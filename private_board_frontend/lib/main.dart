import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const PrivateBoardApp());
}

class PrivateBoardApp extends StatelessWidget {
  const PrivateBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Private Board',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: appRoutes,
      theme: ThemeData(
        fontFamily: 'NanumGothic',
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
