import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/group_provider.dart';

class JoinGroupPage extends ConsumerWidget {
  final String userId;
  const JoinGroupPage({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('그룹 참여')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: '초대 코드 입력'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final result = await ref.read(groupServiceProvider).joinGroup(
                    invitationCode: codeController.text.trim(),
                    userId: userId,
                  );

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text(result['message'] ?? '참여 성공'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text('에러: $e'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('닫기'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('참여하기'),
            ),
          ],
        ),
      ),
    );
  }
}
