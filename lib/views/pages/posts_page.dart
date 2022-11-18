import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/post_controller.dart';
import 'package:unscroll/models/posts_model.dart';
import 'package:unscroll/views/screens/unscroll_stories.dart';
import 'package:unscroll/views/widgets/user_profileimg.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/stories_controller.dart';
import '../screens/comments_screen.dart';
import '../screens/profile_screen.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final postController = Get.put(PostController());

  bool readOnly = true;

  final storiesController = Get.put(StoriesController());

  final TextEditingController commentTextController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  void _toggle() {
    setState(() {
      readOnly = !readOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return CustomScrollView(controller: _scrollController, slivers: [
            stories(),
            posts(),
          ]);
        },
      ),
    );
  }

  Widget stories() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: storiesController.stories.length,
              itemBuilder: (context, index) {
                final data = storiesController.stories[index];
                return SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => UnscrollStories(
                                uid: data.uid,
                              ));
                        },
                        child: UserProfileImage(
                          imageUrl: data.profilePic,
                          radius: 30,
                        ),
                      ),
                      Text(
                        data.username,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget posts() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {
        final data = postController.postsLists[index];
        final commentID = data.id;
        commentController.updatePostID(commentID);
        return Container(
          key: ValueKey(data.id),
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                          () => ProfileScreen(
                                uid: data.uid,
                              ),
                          transition: Transition.cupertino);
                    },
                    child: Row(
                      children: [
                        UserProfileImage(
                          imageUrl: data.profilePic,
                          radius: 15,
                        ),
                        width10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.username),
                            Text(
                              data.location,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: _toggle,
                      icon: data.uid == authController.user.uid
                          ? readOnly
                              ? const Icon(Icons.edit)
                              : const Icon(Icons.done)
                          : const SizedBox()),
                ],
              ),
              height10,
              GestureDetector(
                  onDoubleTap: () {
                    postController.likePost(data.id);
                  },
                  child: UserPostsImages(imageUrl: data.postURL)),
              height10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      likePost(data),
                      saveImageToGallery(data),
                      sharePost(data),
                    ],
                  ),
                  deletePostButton(data, context),
                ],
              ),
              height10,
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  children: [
                    likesCount(data),
                    commentField(data, context),
                    postedAt(data),
                  ],
                ),
              ),
              height10,
            ],
          ),
        );
      },
      childCount: postController.postsLists.length,
    ));
  }

  ///Save Image to Gallery
  IconButton saveImageToGallery(PostsModel data) {
    return IconButton(
      icon: const Icon(Icons.comment_outlined),
      onPressed: () {
        Get.to(CommentsScreen(commentTextController: commentTextController,));
      },
    );
  }

  ///Share post
  IconButton sharePost(PostsModel data) {
    return IconButton(
      icon: const Icon(Icons.send_outlined),
      onPressed: () {
        Share.share('Check out this post on: ${data.postURL}');
      },
    );
  }

  ///Likes Count
  Row likesCount(PostsModel data) {
    return Row(
      children: [
        Text(
          '${data.likes.length} likes',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// Timings
  Row postedAt(PostsModel data) {
    return Row(
      children: [
        Text(timeago.format(data.createdAt.toLocal())),
      ],
    );
  }

  /// Like Post
  IconButton likePost(PostsModel data) {
    return IconButton(
        icon: Icon(data.likes.contains(authController.user.uid)
            ? Icons.favorite
            : Icons.favorite_border),
        color: data.likes.contains(authController.user.uid)
            ? Colors.red
            : Colors.white,
        onPressed: () {
          postController.likePost(data.id);
        });
  }

  ///Comment Editing Field
  TextField commentField(PostsModel data, BuildContext context) {
    final contains = data.uid == authController.user.uid;
    return TextField(
      readOnly: contains ? readOnly : true,
      controller: TextEditingController(text: data.caption),
      style: TextStyle(
          color: contains
              ? readOnly
                  ? Colors.white
                  : Colors.blueAccent
              : Colors.white),
      onSubmitted: (value) {
        postController.updatePost(data.id, value);
        readOnly = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post Updated'),
          ),
        );
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }

  /// Delete post button
  IconButton deletePostButton(PostsModel data, BuildContext context) {
    return IconButton(
        onPressed: () {
          final contains = data.uid == authController.user.uid;
          if (contains) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text('Do you want to Delete this post?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          if (contains) {
                            postController.deletePost(data.id);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Delete')),
                  ],
                );
              },
            );
          } else {}
        },
        icon: data.uid == authController.user.uid
            ? const Icon(Icons.delete_outline)
            : const SizedBox());
  }
}
