import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/group_provider.dart';

class CreateGroupPage extends ConsumerWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    bool hasAdmin = false;

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
                    hasAdmin = value ?? false;
                  },
                ),
                Text('관리자 있음'),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await ref
                    .read(groupServiceProvider)
                    .createGroup(name: nameController.text, hasAdmin: hasAdmin);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('초대코드: ${result['invitationCode']}'),
                  ),
                );
              },
              child: Text('생성'),
            ),
          ],
        ),
      ),
    );
  }
}
