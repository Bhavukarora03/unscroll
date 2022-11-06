import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unscroll/models/posts_model.dart';

import '../constants.dart';
import '../models/user_stories.dart';

class UploadPostsController extends GetxController {
  Rx<File> _pickedPostImage = Rx<File>(File(''));
  File get pickedPostImage => _pickedPostImage.value;

  ///crop image

  cropImage(String imgPath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imgPath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    return croppedFile;
  }

  ///picks posts image from ImageSource
  Future<Rx<File>> pickImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 50,
      maxHeight: 500,
      maxWidth: 500,
    );
    if (pickedImage != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("Picked Image successfully")));
    }
    _pickedPostImage = Rx<File>(File(pickedImage!.path));

    await ImageCropper()
        .cropImage(sourcePath: pickedImage.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ]);
    return _pickedPostImage;
  }

  Future<String> _uploadPostToStorage(String id, String postPath) async {
    Reference ref = firebaseStorage.ref().child('posts/$id').child(id);
    UploadTask uploadTask = ref.putFile(File(postPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _uploadStories(String id, String postPath) async {
    Reference ref = firebaseStorage.ref().child('stories/$id').child(id);
    UploadTask uploadTask = ref.putFile(File(postPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadPost(String caption, String postImage, String location) async {
    try {
      if (caption.isNotEmpty && postImage.isNotEmpty && location.isNotEmpty) {
        String uid = firebaseAuth.currentUser!.uid;
        DocumentSnapshot doc =
            await firebaseFirestore.collection('users').doc(uid).get();
        var allDocs = await firebaseFirestore.collection('posts').get();
        int docCount = allDocs.docs.length;
        String id = docCount.toString();
        String postUrl = await _uploadPostToStorage("posts $id", postImage);

        PostsModel postsModel = PostsModel(
          username: (doc.data()! as Map<String, dynamic>)['username'],
          profilePic: (doc.data()! as Map<String, dynamic>)['profilePic'],
          postURL: postUrl,
          caption: caption,
          id: "posts $docCount",
          uid: uid,
          likes: [],
          commentCount: 0,
          createdAt: DateTime.now(),
          location: location,
        );

        await firebaseFirestore
            .collection('posts')
            .doc("posts $docCount")
            .set(postsModel.toJson());

        Navigator.of(Get.context!).pop();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text("Post uploaded successfully")));
        EasyLoading.dismiss();
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text("Please fill all the fields")));
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Error uploading post$e")));
    }
  }

  uploadStories(String imagePath) async {
    try {
      if (imagePath.isNotEmpty) {
        String uid = firebaseAuth.currentUser!.uid;
        DocumentSnapshot doc =
            await firebaseFirestore.collection('users').doc(uid).get();
        var docs = firebaseFirestore.collection('stories').get();
        int docCount = (await docs).docs.length;
        String id = docCount.toString();
        String storyUrl = await _uploadStories("stories $id", imagePath);
        StoriesModel storyModel = StoriesModel(
            uid: uid,
            username: (doc.data()! as Map<String, dynamic>)['username'],
            id: "Posts $id",
            profilePic: (doc.data()! as Map<String, dynamic>)['profilePic'],
            likes: [],
            storyUrl: storyUrl,
            createdAt: DateTime.now());

        await firebaseFirestore
            .collection('stories')
            .doc("stories $docCount")
            .set(storyModel.toJson());

        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text("Successfully uploaded")));
        Get.back();
        EasyLoading.dismiss();
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Error uploading story$e")));
    }
  }
}
