import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/login_page.dart';
import 'pages/post_list_page.dart';
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
    print('앱 시작 토큰 체크: "$token"'); // (디버깅용)
    if (token == null || token.isEmpty) {
      return const LoginPage();
    } else {
      return const PostListPage(); // TODO: 향후 GroupHomePage로 변경해도 됨
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
