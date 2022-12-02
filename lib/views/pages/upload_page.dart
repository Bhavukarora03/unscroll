import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/screens/screens.dart';
import 'package:unscroll/views/widgets/modelBottomSheet.dart';
import 'dart:io' show Platform;

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
          ElevatedButton(
              onPressed: () async {
                final offerings = await Purchases.getOfferings();

                showCupertinoModalBottomSheet(
                  backgroundColor: Colors.teal,
                    context: context,
                    builder: (context) {
                      var product = offerings.current!.availablePackages;
                      return Material(
                        child: SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              var item = offerings.current!.availablePackages;
                              return ListTile(
                                title: Text(item[index].storeProduct.title),
                                subtitle:
                                    Text(item[index].storeProduct.description),
                                trailing:
                                    Text(item[index].storeProduct.priceString),
                                onTap: () async {
                                 CustomerInfo customerInfo = await Purchases.purchasePackage(item[index]);

                                },
                              );
                            },
                            itemCount: product.length,
                          ),
                        ),
                      );
                    });

              },
              child: const Text("Chat Page"))
        ],
      ),
    );
  }
}
