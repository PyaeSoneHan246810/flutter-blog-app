import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadLocalBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl({required this.box});
  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    box.clear();
    box.write(() {
      for (var i = 0; i < blogs.length; i++) {
        final blogMap = blogs[i].toJson();
        box.put(i.toString(), blogMap);
      }
    });
  }

  @override
  List<BlogModel> loadLocalBlogs() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (var i = 0; i < box.length; i++) {
        final blogMap = box.get(i.toString());
        blogs.add(BlogModel.fromJson(blogMap));
      }
    });
    return blogs;
  }
}
