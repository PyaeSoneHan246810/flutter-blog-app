import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogsPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) {
          return const BlogsPage();
        },
      );
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  Future<void> _showSignOutConfirmDialog() async {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text(
            "Are you sure to sign out?",
            style: TextStyle(
              color: AppPallete.whiteColor,
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOut());
                Navigator.pop(context);
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: AppPallete.whiteColor,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: AppPallete.whiteColor,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _showSignOutLoadingDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Dialog.fullscreen(
          backgroundColor: AppPallete.transparentColor,
          child: Center(
            child: Loader(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogGetAll());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignOutSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            SignInPage.route(),
            (route) {
              return false;
            },
          );
        } else if (state is AuthLoading) {
          _showSignOutLoadingDialog();
        } else if (state is AuthFailure) {
          showSnackbar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Blog App",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppPallete.whiteColor,
                ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showSignOutConfirmDialog();
              },
              icon: const Icon(
                CupertinoIcons.square_arrow_left,
                color: AppPallete.whiteColor,
              ),
            )
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Center(
                child: Loader(),
              );
            }
            if (state is BlogFailure) {
              return Center(
                child: Text(state.message),
              );
            }
            if (state is BlogGetAllSuccess) {
              final blogs = state.blogs;
              final cardColors = [
                AppPallete.gradient1,
                AppPallete.gradient2,
                AppPallete.gradient3,
              ];
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: blogs.length,
                      itemBuilder: (context, index) {
                        final blog = blogs[index];
                        final cardColor = cardColors[index % cardColors.length];
                        return BlogCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              BlogViewerPage.route(blog: blog),
                            );
                          },
                          blog: blog,
                          color: cardColor,
                          isLastCard: index == blogs.length - 1,
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: BlogFab(
          onPressed: () {
            Navigator.push(
              context,
              AddBlogPage.route(),
            );
          },
          iconData: CupertinoIcons.add,
        ),
      ),
    );
  }
}
