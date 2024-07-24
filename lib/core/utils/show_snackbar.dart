import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: AppPallete.whiteColor,
          ),
        ),
        backgroundColor: AppPallete.borderColor,
      ),
    );
}
