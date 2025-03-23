#!/bin/bash

PROJECT_PATH="./lib"
VIEWS_PATH="$PROJECT_PATH/views"
ROUTES_PATH="$PROJECT_PATH/routes"

mkdir -p "$VIEWS_PATH"
mkdir -p "$ROUTES_PATH"

echo "📁 폴더 구조 생성 완료"

# main.dart
cat > "$PROJECT_PATH/main.dart" <<EOF
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
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
EOF

# routes/app_routes.dart
cat > "$ROUTES_PATH/app_routes.dart" <<EOF
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
EOF

# views templates
for PAGE in splash login home write profile; do
	  PAGE_CAP="$(tr '[:lower:]' '[:upper:]' <<< ${PAGE:0:1})${PAGE:1}_page"
  CLASS_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${PAGE:0:1})${PAGE:1}Page"

  cat > "$VIEWS_PATH/${PAGE}_page.dart" <<EOF
import 'package:flutter/material.dart';

class $CLASS_NAME extends StatelessWidget {
  const $CLASS_NAME({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$CLASS_NAME')),
      body: const Center(
        child: Text('$PAGE_CAP 화면입니다'),
      ),
    );
  }
}
EOF
done

echo "✅ 라우팅 세팅 완료: main.dart, routes/app_routes.dart, views/*"

