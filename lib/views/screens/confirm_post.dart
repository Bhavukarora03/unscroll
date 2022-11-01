import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:unscroll/constants.dart';
import 'package:get/get.dart';
import 'package:unscroll/controllers/upload_posts_controller.dart';

class ConfirmPost extends StatefulWidget {
  const ConfirmPost({Key? key, required this.postImage, required this.imgPath})
      : super(key: key);

  final File postImage;
  final String imgPath;

  @override
  State<ConfirmPost> createState() => _ConfirmPostState();
}

class _ConfirmPostState extends State<ConfirmPost> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final UploadPostsController _postController =
      Get.put(UploadPostsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Confirm Post'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.file(
                      File(widget.imgPath),
                      fit: BoxFit.cover,
                    )),
                height50,
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'Add location',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _captionController,
                  decoration: const InputDecoration(
                      hintText: 'Add a caption',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                height50,
                ElevatedButton(
                    onPressed: () {
                      _postController.uploadPost(
                        _captionController.text,
                        widget.imgPath,
                        _locationController.text,
                      );
                    },
                    child: const Text('Confirm Post'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
