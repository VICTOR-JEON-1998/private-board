import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import 'group_home_page.dart';
import 'login_page.dart';

class WelcomePage extends ConsumerWidget {
  final String userId;
  final String email;
  const WelcomePage({Key? key, required this.userId, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('환영합니다'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$email 님 안녕하세요!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GroupHomePage(userId: userId)),
                );
              },
              child: const Text('그룹 목록 보기'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await AuthService.logout();
                ref.read(tokenProvider.notifier).state = '';
                ref.read(userIdProvider.notifier).state = '';
                ref.read(userEmailProvider.notifier).state = '';
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              child: const Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
