import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ProfilePage')),
      body: const Center(
        child: Text('Profile_page 화면입니다'),
      ),
    );
  }
}
