import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blogModel,
  });
  Future<BlogModel> uploadBlog({required BlogModel blogModel});
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  const BlogRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blogModel}) async {
    try {
      await supabaseClient.storage
          .from("blog_images")
          .upload(blogModel.id, image);
      return supabaseClient.storage
          .from("blog_images")
          .getPublicUrl(blogModel.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> uploadBlog({required BlogModel blogModel}) async {
    try {
      final response = await supabaseClient
          .from("blogs")
          .insert(blogModel.toJson())
          .select();
      final blog = BlogModel.fromJson(response.first);
      return blog;
    } on PostgrestException catch (e) {
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final response =
          await supabaseClient.from("blogs").select("*, profiles (name)");
      final blogs = response.map(
        (blog) {
          return BlogModel.fromJson(blog).copyWith(
            username: blog["profiles"]["name"],
          );
        },
      ).toList();
      return blogs;
    } on PostgrestException catch (e) {
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
