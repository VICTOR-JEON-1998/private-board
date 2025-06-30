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
  bool hasAdmin = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final token = ref.watch(tokenProvider);

    return Scaffold(
      appBar: AppBar(title: Text('그룹 생성')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: '그룹 이름')),
            Row(
              children: [
                Checkbox(
                  value: hasAdmin,
                  onChanged: (value) {
                    setState(() {
                      hasAdmin = value ?? false;
                    });
                  },
                ),
                const Text('관리자 있음'),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await ref.read(groupServiceProvider).createGroup(
                  name: nameController.text,
                  hasAdmin: hasAdmin,
                  token: token,
                );

                final groupId = result['groupId'] as String?;
                final code = result['invitationCode'] as String?;

                if (groupId != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostListPage(
                        groupId: groupId,
                        invitationCode: hasAdmin ? code : null,
                      ),
                    ),
                  );
                }
              },
              child: Text('생성'),
            ),
          ],
        ),
      ),
    );
  }
}
