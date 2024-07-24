import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>(_onBlogEvent);
    on<BlogUpload>(_onBlogUpload);
    on<BlogGetAll>(_onBlogGetAll);
  }

  // on event functions
  void _onBlogEvent(
    BlogEvent event,
    Emitter<BlogState> emit,
  ) {
    emit(BlogLoading());
  }

  void _onBlogUpload(
    BlogUpload event,
    Emitter<BlogState> emit,
  ) async {
    final response = await _uploadBlog(
      UploadBlogParams(
        image: event.image,
        userId: event.userId,
        title: event.title,
        content: event.content,
        topics: event.topics,
      ),
    );
    response.fold(
      (failure) {
        _emitBlogFailure(failure.message, emit);
      },
      (blog) {
        _emitBlogUploadSuccess(emit);
      },
    );
  }

  void _onBlogGetAll(
    BlogGetAll event,
    Emitter<BlogState> emit,
  ) async {
    final response = await _getAllBlogs(NoParams());
    response.fold(
      (failure) {
        _emitBlogFailure(failure.message, emit);
      },
      (blogs) {
        _emitBlogGetAllSuccess(blogs, emit);
      },
    );
  }

  // emitter functions
  void _emitBlogFailure(
    String message,
    Emitter<BlogState> emit,
  ) {
    emit(BlogFailure(message: message));
  }

  void _emitBlogUploadSuccess(
    Emitter<BlogState> emit,
  ) {
    emit(BlogUploadSuccess());
  }

  void _emitBlogGetAllSuccess(
    List<Blog> blogs,
    Emitter<BlogState> emit,
  ) {
    emit(BlogGetAllSuccess(blogs: blogs));
  }
}
