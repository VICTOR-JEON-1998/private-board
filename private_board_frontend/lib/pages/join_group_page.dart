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
  final messageController = TextEditingController(); // ✅ 이 줄 추가

  @override
  void dispose() {
    codeController.dispose();
    messageController.dispose(); // ✅ 함께 dispose
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
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: '신청 메시지'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final groupService = ref.read(groupServiceProvider);
                try {
                  // invitationCode로 groupId를 먼저 조회한 후 요청
                  final joinResult = await groupService.sendJoinRequest(
                    groupId: '예시 그룹 ID', // 이건 실제 로직에 맞게 수정 필요
                    userId: widget.userId,
                    message: messageController.text,
                  );
                  // 완료 후 처리
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('요청 완료'),
                      content: Text('참여 요청이 전송되었습니다.'),
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
              child: Text('참여 요청 보내기'),
            ),
          ],
        ),
      ),
    );
  }
}
