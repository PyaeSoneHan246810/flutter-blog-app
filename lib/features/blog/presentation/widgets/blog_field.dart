import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BlogField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const BlogField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppPallete.greyColor,
            ),
      ),
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppPallete.whiteColor,
          ),
      maxLines: null,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is missing!";
        }
        return null;
      },
      cursorColor: AppPallete.gradient2,
    );
  }
}
