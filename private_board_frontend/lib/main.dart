import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/login_page.dart';
import 'pages/group_home_page.dart';
import 'pages/welcome_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(
    ProviderScope( // ✅ Riverpod 사용을 위한 최상위 Wrapper
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> getStartPage() async {
    final token = await AuthService.getToken();
    final userId = await AuthService.getUserId();
    final email = await AuthService.getUserEmail();
    print('앱 시작 토큰 체크: "$token"'); // (디버깅용)
    if (token == null || token.isEmpty || userId == null || email == null) {
      return const LoginPage();
    } else {
      return WelcomePage(userId: userId, email: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Private Board',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'NanumGothic'),
      home: FutureBuilder(
        future: getStartPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
