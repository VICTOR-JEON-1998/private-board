class Post {
  final String author;
  final String content;
  final DateTime createdAt;

  Post({
    required this.author,
    required this.content,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      author: json['author'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
