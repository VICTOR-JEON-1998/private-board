import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final pwCtrl = TextEditingController();
  bool isLoading = false;

  Future<void> handleRegister() async {
    setState(() => isLoading = true);

    final result = await AuthService.register(emailCtrl.text, pwCtrl.text);
    setState(() => isLoading = false);

    if (mounted) {
      if (result == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🎉 회원가입이 완료되었습니다!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else if (result == 'conflict') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ 이미 존재하는 이메일입니다')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입에 실패했습니다 😥')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2), // 따뜻한 배경색
      appBar: AppBar(
        backgroundColor: Colors.orange[200],
        title: const Text('🧡 따뜻한 회원가입'),
        centerTitle: true,
        leading: Navigator.canPop(context) ? const BackButton() : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              '환영합니다!\n소중한 하루를 나눠보세요 🌿',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pwCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('가입하기', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
