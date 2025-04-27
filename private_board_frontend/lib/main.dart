import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/post_list_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> getStartPage() async {
    final token = await AuthService.getToken();
    print('앱 시작 토큰 체크: "$token"'); // (디버깅용)
    // 아래처럼 null 또는 빈 문자열 다 체크!
    if (token == null || token.isEmpty) {
      return const LoginPage();
    } else {
      return const PostListPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Private Board',
      debugShowCheckedModeBanner: false,
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
