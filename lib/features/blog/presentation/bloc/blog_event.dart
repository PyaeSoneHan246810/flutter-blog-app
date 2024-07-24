part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final File image;
  final String userId;
  final String title;
  final String content;
  final List<String> topics;

  BlogUpload({
    required this.image,
    required this.userId,
    required this.title,
    required this.content,
    required this.topics,
  });
}

final class BlogGetAll extends BlogEvent {}
