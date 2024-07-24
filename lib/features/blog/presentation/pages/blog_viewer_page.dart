import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  static route({required Blog blog}) => MaterialPageRoute(
        builder: (context) {
          return BlogViewerPage(
            blog: blog,
          );
        },
      );
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Text(
                blog.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppPallete.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "By ${blog.username}",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppPallete.whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppPallete.greyColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  width: double.infinity,
                  height: 200,
                  blog.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                blog.content,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppPallete.whiteColor,
                      height: 2,
                    ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
