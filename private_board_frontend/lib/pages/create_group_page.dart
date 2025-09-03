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
  void initState() {
    super.initState();
    // 그룹 ID가 바뀌면 중복확인 상태 리셋
    idController.addListener(() {
      if (idChecked || idAvailable != null) {
        setState(() {
          idChecked = false;
          idAvailable = null;
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
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
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '그룹 이름'),
            ),
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
                    final gid = idController.text.trim();
                    if (gid.isEmpty) {
                      if (context.mounted) _showSnack(context, '그룹 ID를 입력해주세요.');
                      return;
                    }
                    try {
                      final available = await ref
                          .read(groupServiceProvider)
                          .checkGroupId(gid);
                      setState(() {
                        idChecked = true;
                        idAvailable = available;
                      });

                      if (context.mounted) {
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.clearMaterialBanners();
                        messenger.showMaterialBanner(
                          MaterialBanner(
                            content: Text(
                              available
                                  ? '사용 가능한 ID입니다.'
                                  : '이미 존재하는 ID입니다.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => messenger.hideCurrentMaterialBanner(),
                                child: const Text('닫기'),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (_) {
                      if (context.mounted) {
                        _showSnack(context, 'ID 중복 확인 중 오류가 발생했습니다.');
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final gid = idController.text.trim();
                final pw  = pwController.text;
                final userId = ref.watch(userIdProvider);


                // 클라이언트 측 유효성 검사
                if (!idChecked || idAvailable != true) {
                  if (context.mounted) _showSnack(context, 'ID 중복 확인을 완료해주세요.');
                  return;
                }
                if (name.isEmpty) {
                  if (context.mounted) _showSnack(context, '그룹 이름을 입력해주세요.');
                  return;
                }
                if (gid.length < 3) {
                  if (context.mounted) _showSnack(context, '그룹 ID는 최소 3자 이상이어야 해요.');
                  return;
                }
                if (pw.length < 6) {
                  if (context.mounted) _showSnack(context, '비밀번호는 최소 6자 이상이어야 해요.');
                  return;
                }
                if ((token == null) || token.isEmpty) {
                  if (context.mounted) _showSnack(context, '인증 토큰이 없습니다. 다시 로그인해 주세요.');
                  return;
                }

                try {
                  final result = await ref.read(groupServiceProvider).createGroup(
                    name: name,
                    groupId: gid,
                    password: pw,
                    token: token,
                    userId : userId,
                  );

                  if (result['status'] == 'conflict') {
                    if (context.mounted) {
                      _showSnack(context, '이미 존재하는 그룹 ID입니다.');
                    }
                    return;
                  }
                  if (result['status'] != 'success') {
                    if (context.mounted) {
                      _showSnack(context, '그룹 생성에 실패했습니다.');
                    }
                    return;
                  }

                  if (context.mounted) {
                    // 응답에서 group 맵을 안전하게 파싱
                    final dynamic rawGroup = result['group'] ?? result['data'] ?? result;
                    final Map<String, dynamic> group = (rawGroup is Map)
                        ? Map<String, dynamic>.from(rawGroup as Map)
                        : <String, dynamic>{};

                    final String? invitationCode = group['invitationCode'] as String?;
                    final String? createdGroupId  = group['groupId'] as String?;

                    // groupId는 다음 화면 진입에 필수
                    if (createdGroupId == null || createdGroupId.isEmpty) {
                      await showDialog(
                        context: context,
                        builder: (_) => const AlertDialog(
                          content: Text('그룹 생성 결과에 groupId가 없습니다. 다시 시도해 주세요.'),
                        ),
                      );
                      return;
                    }

                    // 초대코드 다이얼로그 (null-safe)
                    await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: Text(
                          (invitationCode == null || invitationCode.isEmpty)
                              ? '초대코드 생성이 지연되었습니다.\n그룹 정보에서 다시 확인할 수 있어요.'
                              : '초대코드: $invitationCode',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('확인'),
                          )
                        ],
                      ),
                    );

                    // 다음 화면 이동
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostListPage(groupId: createdGroupId),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    _showSnack(context, '그룹 생성 실패: ${e.toString()}');
                  }
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
