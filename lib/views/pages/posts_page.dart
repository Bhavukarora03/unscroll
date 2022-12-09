import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/post_controller.dart';
import 'package:unscroll/models/posts_model.dart';
import 'package:unscroll/views/screens/screens.dart';
import 'package:unscroll/views/widgets/user_profileimg.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/stories_controller.dart';
import '../screens/edit_post.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return RefreshIndicator(
            semanticsLabel: 'Loading',
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              postController.postsLists
                  .sort((a, b) => b.createdAt.compareTo(a.createdAt));
            },
            child: postController.postsLists.isNotEmpty
                ? CustomScrollView(controller: _scrollController, slivers: [
                    stories(),
                    posts(),
                  ])
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.signpost_sharp,
                          size: 150, color: Colors.white60),
                      Center(
                        child: Text(
                          'No Posts Yet',
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter stories() {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Get.to(() => const UnscrollStories());
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: const AssetImage('assets/images/stories.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.darken)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Unscroll Stories',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
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
              Card(
                child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        Get.to(() => ProfileScreen(
                              uid: data.uid,
                            ));
                      },
                      child: UserProfileImage(
                        imageUrl: data.profilePic,
                        radius: 20,
                      ),
                    ),
                    title: Text(
                      data.username,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      data.location,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    trailing: moreVerticalOptions(context, data)),
              ),
              height10,
              GestureDetector(
                onDoubleTap: () {
                  postController.likePost(data.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.shade100.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 30,
                        offset:
                            const Offset(-1, 0), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: UserPostsImages(imageUrl: data.postURL),
                ),
              ),
              height10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      likePost(data),
                      commentSection(data),
                      sharePost(data),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: postedAt(data),
                  ),
                ],
              ),
              height10,
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    likesCount(data),
                    height10,
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            data.caption,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
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

  IconButton moreVerticalOptions(BuildContext context, PostsModel data) {
    return IconButton(
        onPressed: () {
          showCupertinoModalBottomSheet(
              barrierColor: Colors.black.withOpacity(0.5),
              context: context,
              builder: (context) {
                return Material(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.linear_scale),
                      data.uid == authController.user.uid
                          ? ListTile(
                              onTap: () {
                                Get.back();
                                Get.to(
                                    () => EditPostScreen(
                                          imgUrl: data.postURL,
                                          editCaption: data.caption,
                                          id: data.id,
                                        ),
                                    arguments: data);
                              },
                              leading: const Icon(Icons.edit),
                              title: const Text(
                                'Edit Post',
                              ),
                            )
                          : const SizedBox(),
                      ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text(
                          "Share",
                        ),
                        onTap: () {
                          Share.share(
                              'Check out this post on Unscroll: ${data.postURL}');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.save),
                        title: const Text(
                          "Save",
                        ),
                        onTap: () {},
                      ),
                      data.uid == authController.user.uid
                          ? ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text("Delete",
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: const Text(
                                          'Do you want to Delete this post?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              if (data.uid ==
                                                  authController.user.uid) {
                                                postController
                                                    .deletePost(data.id);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text('Delete')),
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          : const SizedBox(),
                      height50
                    ],
                  ),
                );
              });
        },
        icon: const Icon(Icons.more_horiz));
  }

  ///Save Image to Gallery
  IconButton commentSection(PostsModel data) {
    return IconButton(
      icon: const Icon(Icons.comment_outlined,  color: Colors.grey,),
      onPressed: () {
        Get.to(
            () => CommentsScreen(commentTextController: commentTextController),
            transition: Transition.cupertino);
      },
    );
  }

  ///Share post
  IconButton sharePost(PostsModel data) {
    return IconButton(
      icon: const Icon(Icons.send_outlined, color: Colors.grey,),
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
          '${data.likes.length} likes    ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        width10,
        GestureDetector(
          onTap: () {
            Get.to(() =>
                CommentsScreen(commentTextController: commentTextController));
          },
          child: Text('View all ${data.commentCount} comments',
              style: const TextStyle(
                color: Colors.grey,
              )),
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
            : Colors.grey,
        onPressed: () {
          postController.likePost(data.id);
        });
  }

  ///Comment Editing Field

}
