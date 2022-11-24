import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/screens/screens.dart';
import 'package:unscroll/views/widgets/modelBottomSheet.dart';


class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  uploadVideo(ImageSource src, BuildContext ctx) async {
    final vid = await ImagePicker().pickVideo(source: src);
    if (vid != null) {
      Get.to(() => ConfirmVideo(
            videoFile: File(vid.path),
            videoPath: vid.path,
          ));
    } else {
      Get.snackbar("Error", "No Video Selected");
    }
  }

  uploadStories(ImageSource src, BuildContext ctx) async {
    final storyPath = await ImagePicker().pickImage(source: src);
    if (storyPath != null) {
      Get.to(() => ConfirmStory(
            storyFile: File(storyPath.path),
            storyPath: storyPath.path,
          ));
    } else {
      Get.snackbar("Error", "No Video Selected");
    }
  }

  uploadPost(ImageSource src, BuildContext ctx) async {
    final post = await ImagePicker().pickImage(source: src);
    CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: post!.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          activeControlsWidgetColor: Colors.blueAccent,
          toolbarTitle: 'Crop your unscroll',
          toolbarColor: Colors.blueAccent.shade100,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ]);

    if (croppedFile != null) {
      Get.to(() => ConfirmPost(
            postImage: File(croppedFile.path),
            imgPath: croppedFile.path,
          ));
    } else {
      Get.snackbar("Error", "No Image Selected");
    }
  }
  Future<void> getFruit() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('listFruit');
    final results = await callable();
    List fruit = results.data;  // ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]
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
          SizedBox(
            height: 300,
            width: double.infinity,
            child: CachedNetworkImage(
                imageUrl:
                    "https://cdni.iconscout.com/illustration/premium/thumb/upload-image-4358254-3618850.png"),
          ),
          height80,
          ModelBottomSheetForCamera(
            titleText: "upload a unscroll",
            onPressedCamera: () => uploadVideo(ImageSource.camera, context),
            onPressedGallery: () => uploadVideo(ImageSource.gallery, context),
            icon: Icons.video_call,
            iconColor: Colors.grey.shade700,
            topRadius: 15,
            bottomRadius: 0,
          ),
          height20,
          ModelBottomSheetForCamera(
            titleText: "Upload a post",
            onPressedCamera: () => uploadPost(ImageSource.camera, context),
            onPressedGallery: () => uploadPost(ImageSource.gallery, context),
            icon: Icons.image,
            iconColor: Colors.grey.shade700,
            topRadius: 0,
            bottomRadius: 0,
          ),
          height20,
          ModelBottomSheetForCamera(
            titleText: "Upload a story",
            onPressedCamera: () => uploadStories(ImageSource.camera, context),
            onPressedGallery: () => uploadStories(ImageSource.gallery, context),
            icon: Icons.shutter_speed,
            iconColor: Colors.grey.shade700,
            topRadius: 0,
            bottomRadius: 15,
          ),



         ElevatedButton(onPressed: (){  }, child: Text("Chat Page"))



        ],
      ),
    );
  }
}
