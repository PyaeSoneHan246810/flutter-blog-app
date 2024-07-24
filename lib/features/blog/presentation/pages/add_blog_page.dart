import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blogs_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) {
          return const AddBlogPage();
        },
      );
  const AddBlogPage({super.key});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final formKey = GlobalKey<FormState>();
  final blogTitleController = TextEditingController();
  final blogContentController = TextEditingController();
  List<String> selectedBlogTopics = [];
  File? blogImage;
  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        blogImage = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate()) {
      if (selectedBlogTopics.isEmpty) {
        showSnackbar(context, "Plese select at least one topic.");
        return;
      }
      if (blogImage == null) {
        showSnackbar(context, "Plese select the image.");
        return;
      }
      final userId =
          (context.read<AppUserCubit>().state as AppUserSignedIn).user.id;
      context.read<BlogBloc>().add(
            BlogUpload(
              image: blogImage!,
              userId: userId,
              title: blogTitleController.text.trim(),
              content: blogContentController.text.trim(),
              topics: selectedBlogTopics,
            ),
          );
    }
  }

  @override
  void dispose() {
    blogTitleController.dispose();
    blogContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "New Blog",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                color: AppPallete.whiteColor,
              ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: AppPallete.whiteColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: uploadBlog,
            icon: const Icon(
              CupertinoIcons.checkmark_alt,
              color: AppPallete.whiteColor,
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.message);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogsPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(
              child: Loader(),
            );
          }
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: selectImage,
                      child: (blogImage != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                width: double.infinity,
                                height: 160,
                                blogImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              color: AppPallete.borderColor,
                              dashPattern: const [12, 4],
                              radius: const Radius.circular(12),
                              strokeCap: StrokeCap.round,
                              strokeWidth: 2,
                              child: SizedBox(
                                width: double.infinity,
                                height: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.folder,
                                      color: AppPallete.whiteColor,
                                      size: 40,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Select your image",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: AppPallete.whiteColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: Constants.blogTopics.map(
                        (blogTopic) {
                          final isTopicSelected =
                              selectedBlogTopics.contains(blogTopic);
                          final leftPadding =
                              (Constants.blogTopics.indexOf(blogTopic) == 0)
                                  ? 16.0
                                  : 0.0;
                          final rightPadding =
                              (Constants.blogTopics.indexOf(blogTopic) ==
                                      Constants.blogTopics.length - 1)
                                  ? 16.0
                                  : 10.0;
                          return Padding(
                            padding: EdgeInsets.only(
                              left: leftPadding,
                              right: rightPadding,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (isTopicSelected) {
                                  selectedBlogTopics.remove(blogTopic);
                                } else {
                                  selectedBlogTopics.add(blogTopic);
                                }
                                setState(() {});
                              },
                              child: Chip(
                                label: Text(
                                  blogTopic,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: AppPallete.whiteColor,
                                      ),
                                ),
                                color: (isTopicSelected)
                                    ? const WidgetStatePropertyAll(
                                        AppPallete.gradient2,
                                      )
                                    : null,
                                side: (isTopicSelected)
                                    ? BorderSide.none
                                    : const BorderSide(
                                        color: AppPallete.borderColor,
                                      ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        BlogField(
                          controller: blogTitleController,
                          hintText: "Blog title",
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        BlogField(
                          controller: blogContentController,
                          hintText: "Blog content",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
