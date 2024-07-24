import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BlogFab extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  const BlogFab({
    super.key,
    required this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 16),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppPallete.gradient2,
        foregroundColor: AppPallete.whiteColor,
        child: Icon(
          iconData,
        ),
      ),
    );
  }
}
