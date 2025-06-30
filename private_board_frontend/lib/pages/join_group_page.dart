import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/group_provider.dart';

class JoinGroupPage extends ConsumerStatefulWidget {
  final String userId;
  const JoinGroupPage({Key? key, required this.userId}) : super(key: key); // ✅ 수정


  @override
  ConsumerState<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends ConsumerState<JoinGroupPage> {

  final codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 예시 UI 코드
    return Scaffold(
      appBar: AppBar(title: Text('그룹 참여')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: '초대 코드 입력'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final groupService = ref.read(groupServiceProvider);
                try {
                  final result = await groupService.joinGroup(
                    invitationCode: codeController.text,
                    userId: widget.userId,
                  );
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('참여 완료'),
                      content: Text(result['message'] ?? '그룹에 참여했습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('확인'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  print(e);
                }
              },
              child: Text('그룹 참여'),
            ),
          ],
        ),
      ),
    );
  }
}
