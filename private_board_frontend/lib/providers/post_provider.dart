import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../services/post_api.dart';

final postApiProvider = Provider<PostApi>((ref) => PostApi());

final postListProvider = FutureProvider<List<Post>>((ref) async {
  final api = ref.read(postApiProvider);
  return api.fetchPosts();
});
