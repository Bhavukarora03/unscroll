import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/post_controller.dart';
import 'package:unscroll/views/widgets/user_profileimg.dart';
import 'package:get/get.dart';

class PostsPage extends StatelessWidget {
  PostsPage({Key? key}) : super(key: key);

  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Posts'),
        ),
        body: Obx(() {
          return GridView.builder(


            itemCount: postController.postsLists.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 50,
            ),
            itemBuilder: (BuildContext context, int index) {
              final data = postController.postsLists[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children:  [
                        UserProfileImage(
                          imageUrl: data.profilePic,
                          radius: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(data.username),
                      ],
                    ),
                    height20,
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child:  CachedNetworkImage(imageUrl: data.postURL),

                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              postController.likePost(data.id);
                            },
                            icon:  Icon(
                              data.likes.contains(authController.user.uid)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: data.likes.contains(authController.user.uid) ? Colors.red : Colors.white,
                            )
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.comment,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.send,
                            )),
                      ],
                    ),
                    Row(
                      children:  [
                        Text(data.likes.length.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text('likes'),
                        SizedBox(
                          width: 10,
                        ),

                        Text(data.caption),

                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }));
  }
}
