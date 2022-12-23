import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          body: RefreshIndicator(
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
          ),
        );
      },
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
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        Get.off(() => ProfileScreen(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        likePost(data),
                        commentSection(data),
                        sharePost(data),
                      ],
                    ),
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
                        onTap: () {
                          Get.back();
                          postController.savePost(data.postURL);
                        },
                      ),
                      data.uid == authController.user.uid
                          ? ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text(
                                "Delete",
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

  /// comment section
  IconButton commentSection(PostsModel data) {
    return IconButton(
      icon: const Icon(
        Icons.comment_outlined,
        color: Colors.grey,
      ),
      onPressed: () {
        showMaterialModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            bounce: true,
            context: context,
            builder: (context) => buildCommentSection(context));
      },
    );
  }

  ///Share post
  IconButton sharePost(PostsModel data) {
    return IconButton(
      icon: const Icon(
        Icons.share_outlined,
        color: Colors.grey,
      ),
      onPressed: () {
        Share.share('Check out this post on: ${data.postURL}');
      },
    );
  }

  ///Likes Count
  Row likesCount(PostsModel data) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Text('View all ${data.commentCount.toString()} comments',
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

  Future<bool> onLikeButtonTapped(bool isLiked, PostsModel data) async {
    if (isLiked) {
      !postController.likePost(data.id);
    } else {
      postController.likePost(data.id);
    }

    return !isLiked;
  }

  /// Like Post
  Widget likePost(PostsModel data) {
    return LikeButton(
      size: 25,
      onTap: (isLiked) => onLikeButtonTapped(isLiked, data),
      isLiked: data.likes.contains(authController.user.uid),
      likeCount: data.likes.length,
      likeBuilder: (bool isLiked) {
        return isLiked
            ? const Icon(
                Icons.favorite,
                color: Colors.red,
              )
            : const Icon(
                Icons.favorite_border,
                color: Colors.grey,
              );
      },
      countBuilder: (int? count, bool isLiked, String text) {
        Widget result;
        if (count == 0) {
          result = const Text(
            "love",
            style: TextStyle(color: Colors.grey),
          );
        } else {
          result = Text(
            text,
            style: const TextStyle(color: Colors.grey),
          );
        }
        return result;
      },
    );
  }

  buildCommentSection(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.remove,
              color: Colors.grey[600],
              size: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Comments",
                    style: TextStyle(fontSize: 15),
                  )),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: commentController.postsComment.length,
                  itemBuilder: (context, index) {
                    final comment = commentController.postsComment[index];
                    return ListTile(
                      isThreeLine: true,
                      leading:
                          UserProfileImage.small(imageUrl: comment.profilePic),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () => commentController.likeComment(
                                  comment.id, 'posts'),
                              icon: comment.likes
                                      .contains(authController.user.uid)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.redAccent,
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      size: 18,
                                    )),
                          Expanded(
                              child: Text(
                            comment.likes.length.toString(),
                            style: const TextStyle(fontSize: 8),
                          ))
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.comment,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      title: Row(
                        children: [
                          Text(
                            '${comment.username}    •',
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 12),
                          ),
                          const Divider(indent: 10),
                          Text(
                            timeago.format(comment.createdAt.toLocal()),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 9),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Card(
                child: ListTile(
                  title: TextFormField(
                    controller: commentTextController,
                    decoration: const InputDecoration(
                      hintText: "Add a comment...",
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      commentController.postComment(
                          commentTextController.text, 'posts');
                      commentTextController.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Comment Editing Field

}
