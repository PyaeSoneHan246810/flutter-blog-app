import 'dart:io';

import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  const BlogRepositoryImpl({
    required this.blogRemoteDataSource,
    required this.blogLocalDataSource,
    required this.connectionChecker,
  });
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String userId,
    required String title,
    required String content,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(message: Constants.noConnectionErrorMessage));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        updatedAt: DateTime.now(),
        userId: userId,
        title: title,
        content: content,
        imageUrl: "",
        topics: topics,
      );
      // upload blog image and get url
      final blogImageUrl = await blogRemoteDataSource.uploadBlogImage(
          image: image, blogModel: blogModel);
      // upload blog
      final blog = await blogRemoteDataSource.uploadBlog(
        blogModel: blogModel.copyWith(imageUrl: blogImageUrl),
      );
      return right(blog);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        final localBlogs = blogLocalDataSource.loadLocalBlogs();
        return right(localBlogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
