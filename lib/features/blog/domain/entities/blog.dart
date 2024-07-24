class Blog {
  final String id;
  final DateTime updatedAt;
  final String userId;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;
  final String? username;

  Blog({
    required this.id,
    required this.updatedAt,
    required this.userId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    this.username,
  });
}
