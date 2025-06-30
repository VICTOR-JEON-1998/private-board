import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_board_frontend/pages/login_page.dart';

void main() {
  testWidgets('Login page shows login button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.text('로그인'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
