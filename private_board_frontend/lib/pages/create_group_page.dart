import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/group_provider.dart';
import '../providers/auth_provider.dart';
import 'post_list_page.dart';

class CreateGroupPage extends ConsumerWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final token = ref.watch(tokenProvider);

    return Scaffold(
      appBar: AppBar(title: Text('그룹 생성')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: '그룹 이름')),
            ElevatedButton(
              onPressed: () async {
                final result = await ref.read(groupServiceProvider).createGroup(
                  name: nameController.text,
                  token: token,
                );

                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('초대코드: ${result['invitationCode']}'),
                  ),
                );

                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const PostListPage()),
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
