import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final TextEditingController _controller = TextEditingController();
  static const int maxLength = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F0),
      appBar: AppBar(
        title: const Text(
          '글쓰기',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLength: maxLength,
              maxLines: null,
              decoration: InputDecoration(
                hintText: '오늘의 이야기를 남겨보세요 😊',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC8A2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  // TODO: 글 등록 처리 (일단 SnackBar)
                  if (_controller.text.trim().isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('글이 작성되었습니다! (Mock)')),
                    );
                    Navigator.pop(context); // 홈으로 돌아가기
                  }
                },
                child: const Text(
                  '작성 완료',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
