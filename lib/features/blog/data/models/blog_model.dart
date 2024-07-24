import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.updatedAt,
    required super.userId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    super.username,
  });
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'updated_at': updatedAt.toIso8601String(),
      'user_id': userId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      updatedAt: (map['updated_at'] == null)
          ? DateTime.now()
          : DateTime.parse(map['updated_at'] as String),
      userId: map['user_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: (map['image_url'] == null) ? "" : map['image_url'] as String,
      topics: (map['topics'] == null)
          ? List<String>.empty()
          : List<String>.from(map['topics'] as List<dynamic>),
    );
  }

  BlogModel copyWith({
    String? id,
    DateTime? updatedAt,
    String? userId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    String? username,
  }) {
    return BlogModel(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      username: username ?? this.username,
    );
  }
}
