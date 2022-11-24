import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
import '../screens/edit_post.dart';
import '../screens/profile_screen.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final postController = Get.put(PostController());

  @override
  void initState() {
    postController;
    super.initState();
  }

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
            child: CustomScrollView(controller: _scrollController, slivers: [
              stories(),
              posts(),
            ]),
          );
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
                            Get.to(() => UnscrollStories(uid: data.uid));

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
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      data.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
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
                  )),
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
                  children: [
                    likesCount(data),
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
                              title: const Text('Edit Post',
                                  style: TextStyle(color: Colors.white)),
                            )
                          : const SizedBox(),
                      ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text(
                          "Share",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Share.share(
                              'Check out this post on Unscroll: ${data.postURL}');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.save),
                        title: const Text("Save",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {},
                      ),
                      data.uid == authController.user.uid
                          ? ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text("Delete",
                                  style: TextStyle(color: Colors.white)),
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
      icon: const Icon(Icons.comment_outlined),
      onPressed: () {
        Get.to(CommentsScreen(commentTextController: commentTextController),
            transition: Transition.cupertino);
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
        width10,
        Text(
          data.caption,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
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

}
