import 'package:flutter/material.dart';

class WritePage extends StatelessWidget {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WritePage')),
      body: const Center(
        child: Text('Write_page 화면입니다'),
      ),
    );
  }
}
