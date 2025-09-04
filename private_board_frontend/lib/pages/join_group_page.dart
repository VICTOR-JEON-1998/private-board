import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/group_provider.dart';
import '../providers/auth_provider.dart';

class JoinGroupPage extends ConsumerStatefulWidget {
  const JoinGroupPage({Key? key}) : super(key: key);


  @override
  ConsumerState<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends ConsumerState<JoinGroupPage> {

  final idController = TextEditingController();
  final pwController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 예시 UI 코드
    return Scaffold(
      appBar: AppBar(
        title: const Text('그룹 참여'),
        leading: Navigator.canPop(context) ? const BackButton() : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: '그룹 ID'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pwController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final groupService = ref.read(groupServiceProvider);
                final token = ref.read(tokenProvider);
                try {
                  final result = await groupService.joinGroupByCredential(
                    groupId: idController.text,
                    password: pwController.text,
                    token: token,
                  );
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('참여 완료'),
                        content: Text(result['message'] ?? '그룹에 참여했습니다.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('확인'),
                          ),
                        ],
                      ),
                    );
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('그룹 참여'),
            ),
          ],
        ),
      ),
    );
  }
}
