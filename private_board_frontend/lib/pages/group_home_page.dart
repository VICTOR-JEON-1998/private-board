import 'package:flutter/material.dart';
import 'create_group_page.dart';
import 'join_group_page.dart';

class GroupHomePage extends StatelessWidget {
  final String userId;
  const GroupHomePage({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('그룹 선택')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateGroupPage()),
                );
              },
              child: Text('그룹 생성'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => JoinGroupPage(userId: userId)),
                );
              },
              child: Text('그룹 참여'),
            ),
          ],
        ),
      ),
    );
  }
}
