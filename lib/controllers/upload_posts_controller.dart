import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unscroll/models/posts_model.dart';

import '../constants.dart';

class UploadPostsController extends GetxController {
  Rx<File> _pickedPostImage = Rx<File>(File(''));
  File get pickedPostImage => _pickedPostImage.value;

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
    return _pickedPostImage;
  }

  Future<String> _uploadPostToStorage(String id, String postPath) async {
    Reference ref = firebaseStorage.ref().child('posts/$id').child(id);
    UploadTask uploadTask = ref.putFile(File(postPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadPost(String caption, String postImage, String location) async {
    try {

      if (caption.isNotEmpty && postImage.isNotEmpty){
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

      Get.back();
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("Please fill all the fields")));
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text("Error uploading post$e")));
    }
  }
}
