import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unscroll/views/widgets/user_profileimg.dart';
import '../../controllers/post_controller.dart';


class EditPostScreen extends StatelessWidget {
  EditPostScreen(
      {Key? key,
      required this.imgUrl,
      required this.editCaption,
      required this.id})
      : super(key: key);

  final String imgUrl;
  final String editCaption;
  final String id;
  String newValue = "";
  final postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Edit Post'),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  postController.updatePost(id, newValue);
                  Get.back();
                },
                icon: const Icon(Icons.done))
          ],
        ),
        body: Column(
          children: [
            Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 10,
                          blurRadius: 50,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: UserPostsImages(imageUrl: imgUrl))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListTile(
                    leading: Icon(Icons.closed_caption_outlined),
                    title: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: TextEditingController(text: editCaption),
                      decoration: const InputDecoration(
                        hintText: 'Write a caption...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        newValue = value;
                        postController.updatePost(id, value);
                        Get.back();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Post updated'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
