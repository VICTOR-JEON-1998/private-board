import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mockPosts = [
      {'author': '익명1', 'content': '오늘 너무 힘들었어요... 그래도...' },
      {'author': '익명2', 'content': '고마운 사람이 있어요 😊' },
      {'author': '익명3', 'content': '다들 잘 지내고 계시죠?' },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F0), // 연한 살구톤
      appBar: AppBar(
        title: const Text(
          'Private Board',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '안녕하세요, 오늘도 반가워요 😊',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: mockPosts.length,
                itemBuilder: (context, index) {
                  final post = mockPosts[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post['author'] ?? '익명', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(post['content'] ?? ''),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFC8A2),
        onPressed: () {
          Navigator.pushNamed(context, '/write');
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
