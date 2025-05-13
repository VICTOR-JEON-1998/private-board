import 'package:flutter/material.dart';
import '../services/post_api.dart';
import 'create_post_page.dart';
import 'post_detail_page.dart';
import '../services/auth_service.dart';
import '../pages/login_page.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  List<dynamic> posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    await _checkToken();
    await loadPosts();
  }

  Future<void> _checkToken() async {
    final token = await AuthService.getToken();
    print('[PostListPage] 토큰 확인: $token');
    if (token == null || token.isEmpty) {
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    }
  }

  Future<void> loadPosts() async {
    print('[PostListPage] loadPosts 호출');
    final data = await PostApi.fetchPosts();
    print('[PostListPage] 받아온 글 개수: ${data.length}');
    setState(() {
      posts = data;
      _loading = false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('[PostListPage] build 호출, posts 길이: ${posts.length}, loading: $_loading');
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        title: const Text('🌿 따뜻한 하루'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "로그아웃",
            onPressed: () => _logout(context),
          ),
        ],
        backgroundColor: Colors.orange[200],
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
          ? const Center(child: Text('게시글이 없습니다.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final title = post['title'] ?? '제목 없음';
          final email = post['author']?['email'] ?? '알 수 없음';
          final createdAt = post['createdAt']?.substring(0, 10) ?? '';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            color: const Color(0xFFF8F4FF),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              title: Text(
                title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('$email\n$createdAt'),
              isThreeLine: true,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostDetailPage(post: post),
                  ),
                );

                if (result == true) {
                  await loadPosts(); // 수정 or 삭제 후 목록 새로고침
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostPage()),
          );
          if (result == true) {
            await loadPosts(); // 글쓰기 성공 시 목록 새로고침
          }
        },
        backgroundColor: Colors.orange[300],
        child: const Icon(Icons.add, size: 28),
        tooltip: '글 쓰기',
      ),
    );
  }
}
