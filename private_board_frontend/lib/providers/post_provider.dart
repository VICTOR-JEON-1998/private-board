import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';

class PostNotifier extends StateNotifier<List<Post>> {
  PostNotifier() : super([]);

  void addPost(Post post) {
    state = [...state, post];
  }

  void clearPosts() {
    state = [];
  }
}

final postProvider = StateNotifierProvider<PostNotifier, List<Post>>(
      (ref) => PostNotifier(),
);
