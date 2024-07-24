import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;
  const UploadBlog({required this.blogRepository});
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      userId: params.userId,
      title: params.title,
      content: params.content,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final File image;
  final String userId;
  final String title;
  final String content;
  final List<String> topics;

  UploadBlogParams({
    required this.image,
    required this.userId,
    required this.title,
    required this.content,
    required this.topics,
  });
}
