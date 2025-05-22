import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../pages/group_home_page.dart';
import '../providers/auth_provider.dart';
import 'register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailCtrl = TextEditingController();
  final pwCtrl = TextEditingController();
  bool isLoading = false;

  Future<void> handleLogin() async {
    setState(() => isLoading = true);
    final response = await AuthService.login(emailCtrl.text, pwCtrl.text);
    setState(() => isLoading = false);

    if (response != null && mounted) {
      final token = response['token'];
      final userId = response['user']['id'];

      // 전역 상태에 저장
      ref.read(tokenProvider.notifier).state = token;
      ref.read(userIdProvider.notifier).state = userId;

      // 그룹 선택 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => GroupHomePage(userId: userId)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔐 로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: '이메일')),
            TextField(controller: pwCtrl, obscureText: true, decoration: const InputDecoration(labelText: '비밀번호')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : handleLogin,
              child: isLoading ? const CircularProgressIndicator() : const Text('로그인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text('계정이 없으신가요? 회원가입하기 🧡'),
            )
          ],
        ),
      ),
    );
  }
}
