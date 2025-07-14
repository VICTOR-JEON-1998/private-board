import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/group_provider.dart';
import '../providers/auth_provider.dart';
import 'post_list_page.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final pwController = TextEditingController();
  bool? idAvailable;
  bool idChecked = false;

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final token = ref.watch(tokenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('그룹 생성'),
        leading: Navigator.canPop(context) ? const BackButton() : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: '그룹 이름')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: idController,
                    decoration: const InputDecoration(labelText: '그룹 ID'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (idController.text.trim().isEmpty) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('그룹 ID를 입력해주세요.')));
                      }
                      return;
                    }
                    try {
                      final available = await ref
                          .read(groupServiceProvider)
                          .checkGroupId(idController.text);
                      setState(() {
                        idChecked = true;
                        idAvailable = available;
                      });
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentMaterialBanner()
                          ..showMaterialBanner(
                            MaterialBanner(
                              content: Text(available
                                  ? '사용 가능한 ID입니다.'
                                  : '이미 존재하는 ID입니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentMaterialBanner(),
                                  child: const Text('닫기'),
                                )
                              ],
                            ),
                          );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                                content:
                                    Text('ID 중복 확인 중 오류가 발생했습니다.')),
                          );
                      }
                    }
                  },
                  child: const Text('중복 확인'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pwController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '그룹 비밀번호'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!idChecked || idAvailable != true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ID 중복 확인을 완료해주세요.')),
                  );
                  return;
                }

                final result = await ref.read(groupServiceProvider).createGroup(
                  name: nameController.text,
                  groupId: idController.text,
                  password: pwController.text,
                  token: token,
                );

                if (result['status'] == 'conflict') {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이미 존재하는 그룹 ID입니다.')),
                    );
                  }
                  return;
                }

                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text('초대코드: ${result['invitationCode']}'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('확인'),
                        )
                      ],
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostListPage(groupId: result['groupId']),
                    ),
                  );
                }
              },
              child: const Text('생성'),
            ),
          ],
        ),
      ),
    );
  }
}
