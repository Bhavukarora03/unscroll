import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/models/video_model.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  ///compress video and return the compressed video
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
    );
    return compressedVideo!.file;
  }

  ///get video thumbnail and return the thumbnail
  _getThumbnail(String thumbnail) async {
    final videoThumbnail = await VideoCompress.getFileThumbnail(
      thumbnail,
      quality: 50,
    );

    return videoThumbnail;
  }

  ///upload thumbnail to firebase storage and return the url
  _uploadImageThumbnailToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child("Thumbnails").child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  ///upload video to firebase storage and return the url
  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos/$id').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  ///upload video to firebase firestore
  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      if (songName.isNotEmpty && caption.isNotEmpty && videoPath.isNotEmpty) {
        String uid = firebaseAuth.currentUser!.uid;
        DocumentSnapshot doc =
            await firebaseFirestore.collection('users').doc(uid).get();
        var allDocs = await firebaseFirestore.collection('videos').get();
        int docCount = allDocs.docs.length;
        var uuid = const Uuid().v4();

        String videoUrl =
            await _uploadVideoToStorage("Video $docCount", videoPath);
        String thumbnail =
            await _uploadImageThumbnailToStorage("Video $docCount", videoPath);

        VideoModel video = VideoModel(
          username: (doc.data()! as Map<String, dynamic>)['username'],
          songName: songName,
          caption: caption,
          likes: [],
          shareCount: 0,
          commentCount: 0,
          uid: uid,
          id: uuid,
          videoUrl: videoUrl,
          thumbnail: thumbnail,
          profilePic: (doc.data()! as Map<String, dynamic>)['profilePic'],
          createdAt: DateTime.now(),
        );

        await firebaseFirestore
            .collection('videos')
            .doc(uuid)
            .set(video.toJson());

        Get.back();
        await EasyLoading.showSuccess("Video Uploaded Successfully");
      } else {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text("Please fill all the fields")));
      }
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
           SnackBar(content: Text("Something went wrong + $e")));
    }
  }

  ///Save Video to phone Storage
  saveVideo(String videoPath) async {
    try {
      Uint8List bytes = await File(videoPath).readAsBytes();
      //   await FileSaver.instance.saveFile(videoPath, bytes, 'video.mp4');
      Get.snackbar("success", "Video saved to phone storage");
    } catch (e) {
      Get.snackbar("error", e.toString());
    }
  }
}
