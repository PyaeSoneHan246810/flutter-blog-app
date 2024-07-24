import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final VoidCallback onTap;
  final Blog blog;
  final Color color;
  final bool isLastCard;
  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
    required this.isLastCard,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(
          left: 16,
          top: 16,
          right: 16,
          bottom: isLastCard ? 16 : 0,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: blog.topics.map(
                  (topic) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                      ),
                      child: Chip(
                        label: Text(
                          topic,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: AppPallete.whiteColor,
                                  ),
                        ),
                        color: const WidgetStatePropertyAll(
                          AppPallete.backgroundColor,
                        ),
                        side: null,
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              blog.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppPallete.whiteColor,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Expanded(child: SizedBox()),
            Text(
              "${calculateReadingTime(blog.content)} min",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppPallete.whiteColor,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
