import 'dart:io';
import 'package:flutter/cupertino.dart';
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
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("No video selected"),
        ),
      );
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
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("No post selected"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: authController.hasInternet ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.asset(
              "assets/images/upload.png",
              fit: BoxFit.contain,
            ),
          ),
          height80,

          ModelBottomSheetForCamera(
            titleText: "Unscroll",
            onPressedCamera: () => uploadVideo(ImageSource.camera, context),
            onPressedGallery: () => uploadVideo(ImageSource.gallery, context),
            icon: Icons.u_turn_right,
            iconColor: Colors.grey.shade700,
            topRadius: 15,
            bottomRadius: 0,
          ),
          height20,
          ModelBottomSheetForCamera(
            titleText: "Post",
            onPressedCamera: () => uploadPost(ImageSource.camera, context),
            onPressedGallery: () => uploadPost(ImageSource.gallery, context),
            icon: CupertinoIcons.photo_on_rectangle,
            iconColor: Colors.grey.shade700,
            topRadius: 0,
            bottomRadius: 0,
          ),
          height20,
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
              ),
              onPressed: () {
               showDialog(context: context, builder: (context) => const AlertDialog(
                 title: Text("Coming Soon"),
                 content: Text("This feature is coming soon"),
               ));
              },
              label: const Text("Story"),
              icon: const Icon(Icons.upload))
        ],
      ): Column(
        children: [
          Image.asset("assets/images/walking-girl.png",scale: 3,),
          const Text("No internet connection", style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold

          ),),
        ],
      )
    );
  }
}
