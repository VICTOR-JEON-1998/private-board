import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/post_api.dart';
import '../views/emoji_reaction_row.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;
  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  String? currentUserId;

  // 이모지 관련 상태
  List<Map<String, dynamic>> emojiList = [];
  String? selectedEmojiKey;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadReactions();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? prefs.getString('token');
    if (token == null) return;
    try {
      final response = await Dio().get(
        'http://localhost:3000/api/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final userId = response.data['user']['id'];
        if (userId != null && mounted) setState(() => currentUserId = userId);
      }
    } catch (_) {}
  }

  /// 👇 이모지 공감 리스트 + 내가 공감한 이모지 불러오기
  Future<void> _loadReactions() async {
    print('[이모지 디버깅] _loadReactions() 호출됨!');
    try {
      final response = await Dio().get(
        'http://localhost:3000/api/posts/${widget.post['id']}',
      );
      print('[이모지 디버깅] 서버 응답: ${response.data}');
      final reactions = response.data['reactions'] as List? ?? [];
      final me = currentUserId;
      setState(() {
        // 1. 고정 이모지 3개를 먼저 생성!
        emojiList = [
          {'emoji': '👍', 'key': 'like',  'count': 0},
          {'emoji': '😂', 'key': 'laugh', 'count': 0},
          {'emoji': '😮', 'key': 'wow',   'count': 0},
        ];
        // 2. 서버에서 온 reactions로 count 덮어쓰기
        for (var e in reactions) {
          final idx = emojiList.indexWhere((em) => em['key'] == e['emoji']);
          if (idx != -1) {
            emojiList[idx]['count'] = e['count'] ?? 0;
          }
        }
        // 3. 내가 누른 이모지 찾기
        selectedEmojiKey = reactions.firstWhere(
              (e) => (e['users'] as List?)?.contains(me) ?? false,
          orElse: () => null,
        )?['emoji'];

        // 4. 깊은 복사로 UI 갱신 유도
        emojiList = List<Map<String, dynamic>>.from(emojiList);
      });
    } catch (e) {
      print('[이모지 디버깅] 예외 발생: $e');
      setState(() {
        emojiList = [
          {'emoji': '👍', 'key': 'like',  'count': 0},
          {'emoji': '😂', 'key': 'laugh', 'count': 0},
          {'emoji': '😮', 'key': 'wow',   'count': 0},
        ];
        selectedEmojiKey = null;
      });
    }
  }

  /// 이모지 공감/취소 요청
  Future<void> _handleEmojiTap(String emojiKey) async {
    final res = await PostApi.reactToPost(widget.post['id'].toString(), emojiKey);
    setState(() {
      if (res == null) return;

      if (res['status'] == 'reacted') {
        if (selectedEmojiKey != null && selectedEmojiKey != emojiKey) {
          final old = emojiList.firstWhere(
                (e) => e['key'] == selectedEmojiKey,
            orElse: () => {'key': null, 'count': 0, 'emoji': null},
          );
          if (old['key'] != null) old['count'] = (old['count'] ?? 1) - 1;
        }
        final cur = emojiList.firstWhere(
              (e) => e['key'] == emojiKey,
          orElse: () => {'key': null, 'count': 0, 'emoji': null},
        );
        if (cur['key'] != null) cur['count'] = (cur['count'] ?? 0) + 1;
        selectedEmojiKey = emojiKey;
      } else if (res['status'] == 'unreacted') {
        final cur = emojiList.firstWhere(
              (e) => e['key'] == emojiKey,
          orElse: () => {'key': null, 'count': 0, 'emoji': null},
        );
        if (cur['key'] != null) cur['count'] = (cur['count'] ?? 1) - 1;
        selectedEmojiKey = null;
      }

      // 다시 복사해서 빌드 유도
      emojiList = List<Map<String, dynamic>>.from(emojiList);
    });
  }

  int getCount(String key) {
    return emojiList.firstWhere((e) => e['key'] == key, orElse: () => {'count': 0})['count'];
  }

  @override
  Widget build(BuildContext context) {
    print('[이모지 디버깅 - build()] emojiList: $emojiList, selected: $selectedEmojiKey');
    final post = widget.post;
    final title = post['title'] ?? '제목 없음';
    final content = post['content'] ?? '내용 없음';
    final email = post['author']?['email'] ?? '알 수 없음';
    final createdAt = post['createdAt']?.substring(0, 10) ?? '';
    final authorId = post['author']?['id'];
    final isOwner = currentUserId != null && currentUserId == authorId;

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
            if (emojiList.isNotEmpty)
              EmojiReactionRow(
                emojiList: emojiList,
                selectedEmojiKey: selectedEmojiKey,
                onTap: _handleEmojiTap,
              ),
            const SizedBox(height: 20),
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
