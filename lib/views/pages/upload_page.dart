import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/screens/screens.dart';
import 'package:unscroll/views/widgets/modelBottomSheet.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  uploadVideo(ImageSource src, BuildContext ctx) async {
    final vid = await ImagePicker().pickVideo(source: src);
    if (vid != null) {
      Get.off(() => ConfirmVideo(
            videoFile: File(vid.path),
            videoPath: vid.path,
          ));
    } else {
      Get.snackbar("Error", "No Video Selected");
    }
  }

  uploadPost(ImageSource src, BuildContext ctx) async {
    final post = await ImagePicker().pickImage(source: src);
    if (post != null) {
      Get.off(() => ConfirmPost(
            postImage: File(post.path),
            imgPath: post.path,
          ));
    } else {
      Get.snackbar("Error", "No Image Selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CachedNetworkImage(
              imageUrl:
                  "https://cdni.iconscout.com/illustration/premium/thumb/upload-image-4358254-3618850.png"),
          height80,
          ModelBottomSheetForCamera(
            titleText: "upload a unscroll",
            onPressedCamera: () => uploadVideo(ImageSource.camera, context),
            onPressedGallery: () => uploadVideo(ImageSource.gallery, context),
            icon: Icons.video_call,
            iconColor: Colors.blueAccent.shade100,
          ),
          height20,
          ModelBottomSheetForCamera(
            titleText: "Upload a post",
            onPressedCamera: () => uploadPost(ImageSource.camera, context),
            onPressedGallery: () => uploadPost(ImageSource.gallery, context),
            icon: Icons.image,
            iconColor: Colors.black38,
          ),
        ],
      ),
    );
  }
}
