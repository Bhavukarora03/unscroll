
import 'package:flutter/material.dart';

import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/post_controller.dart';
import 'package:unscroll/views/screens/unscroll_stories.dart';
import 'package:unscroll/views/widgets/user_profileimg.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/stories_controller.dart';

class PostsPage extends StatelessWidget {
  PostsPage({Key? key}) : super(key: key);

  final postController = Get.put(PostController());
  final storiesController = Get.put(StoriesController());
  final ScrollController _scrollController = ScrollController();

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
                        onTap: () => Get.to(() => UnscrollStories(), transition: Transition.downToUp),
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
        return Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      UserProfileImage(
                        imageUrl: data.profilePic,
                        radius: 15,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.username),
                          const Text('Location'),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.more_vert)
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
                      IconButton(
                          icon: Icon(
                              data.likes.contains(authController.user.uid)
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                          color: data.likes.contains(authController.user.uid)
                              ? Colors.red
                              : Colors.white,
                          onPressed: () {
                            postController.likePost(data.id);
                          }),
                      width20,
                      IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: () {},
                      ),
                      width20,
                      IconButton(
                        icon: const Icon(Icons.send_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
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
                                      postController.deletePost(data.id);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete')),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete_outline))
                ],
              ),
              height10,
              Row(
                children: [
                  Text(
                    '${data.likes.length} likes',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              height10,
              Row(
                children: [
                  Text(
                    "* ${data.caption}",
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
              height10,
              Row(
                children: [
                  Text(timeago.format(data.createdAt.toLocal())),
                ],
              ),
            ],
          ),
        );
      },
      childCount: postController.postsLists.length,
    ));
  }
}
