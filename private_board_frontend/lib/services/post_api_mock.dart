import '../models/post.dart';

class PostApi {
  final List<Post> _mockPosts = [
    Post(author: '익명1', content: '오늘도 고생했어요 😊', createdAt: DateTime.now()),
    Post(author: '익명2', content: '힘내세요 모두!', createdAt: DateTime.now()),
  ];

  Future<List<Post>> fetchPosts() async {
    await Future.delayed(const Duration(milliseconds: 500)); // 시뮬레이션
    return _mockPosts;
  }

  Future<void> createPost(Post post) async {
    await Future.delayed(const Duration(milliseconds: 300)); // 시뮬레이션
    _mockPosts.add(post);
  }
}
