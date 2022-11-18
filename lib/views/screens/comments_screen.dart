import 'package:flutter/material.dart';
import 'package:unscroll/constants.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/comment_controller.dart';
import '../widgets/user_profileimg.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({
    Key? key,
    required this.commentTextController,
  }) : super(key: key);

  final TextEditingController commentTextController;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  final CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                KeyboardUnFocus(context).hideKeyboard();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: WillPopScope(
          onWillPop: () {
            KeyboardUnFocus(context).hideKeyboard();
            Get.back();
            return Future.value(false);
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: commentController.postsComment.length,
                        itemBuilder: (context, index) {

                          final postComment =
                              commentController.postsComment[index];
                          return ListTile(
                            isThreeLine: true,
                            leading: UserProfileImage.small(
                                imageUrl: postComment.profilePic),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () =>
                                        commentController.likeComment(
                                            postComment.id,
                                            'posts'),
                                    icon: postComment.likes
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
                                  postComment.likes.length.toString(),
                                  style: const TextStyle(fontSize: 8),
                                ))
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  postComment.comment,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Text(
                                  '${postComment.username}    •',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                                const Divider(indent: 10),
                                Text(
                                  timeago
                                      .format(postComment.createdAt.toLocal()),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: TextFormField(
                          controller: widget.commentTextController,
                          decoration: const InputDecoration(
                            hintText: "Add a comment...",
                            border: InputBorder.none,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            commentController.postComment(
                                widget.commentTextController.text,
                                'posts',
                                );
                            widget.commentTextController.clear();
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
