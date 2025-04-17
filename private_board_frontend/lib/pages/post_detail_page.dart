import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/post_api.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  String? currentUserId;
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:3000'; // 필요시 10.0.2.2로 수정

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? prefs.getString('token');

    if (token == null) return;

    try {
      final response = await _dio.get(
        '$_baseUrl/api/me',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          currentUserId = response.data['id'];
        });
      }
    } catch (e) {
      print('❌ 사용자 정보 불러오기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final title = post['title'] ?? '제목 없음';
    final content = post['content'] ?? '내용 없음';
    final email = post['author']?['email'] ?? '알 수 없음';
    final createdAt = post['createdAt']?.substring(0, 10) ?? '';
    final authorId = post['author']?['id'];

    final isOwner = currentUserId != null && currentUserId == authorId;
    print('🪪 currentUserId: $currentUserId');
    print('🧾 authorId: ${post['author']?['id']}');

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        title: const Text('📖 게시글 상세'),
        backgroundColor: Colors.orange[200],
        centerTitle: true,
        actions: isOwner
            ? [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _handleEdit(post),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _handleDelete(post['id']),
          ),
        ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('작성자: $email', style: const TextStyle(fontSize: 14)),
            Text('작성일: $createdAt', style: const TextStyle(fontSize: 14)),
            const Divider(height: 32, thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEdit(Map<String, dynamic> post) async {
    final titleCtrl = TextEditingController(text: post['title']);
    final contentCtrl = TextEditingController(text: post['content']);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('게시글 수정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(hintText: '제목')),
            const SizedBox(height: 12),
            TextField(
              controller: contentCtrl,
              decoration: const InputDecoration(hintText: '내용'),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          TextButton(
            onPressed: () async {
              final success = await PostApi.update(
                post['id'],
                titleCtrl.text.trim(),
                contentCtrl.text.trim(),
              );
              Navigator.pop(context, success);
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ 수정 완료')),
      );
      Navigator.pop(context, true);
    }
  }

  void _handleDelete(String postId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('삭제 확인'),
        content: const Text('정말 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('삭제')),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await PostApi.delete(postId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🗑 삭제 완료')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제 실패')),
      );
    }
  }
}
