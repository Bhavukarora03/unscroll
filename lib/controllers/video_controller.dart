

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/models/video_model.dart';

class VideoController extends GetxController {


  static VideoController get instance => Get.find();
  final Rx<List<VideoModel>> _videosList = Rx<List<VideoModel>>([]);

  List<VideoModel> get videoList => _videosList.value;

  final RxBool _isLoaded = false.obs;

  bool get isLoaded => _isLoaded.value;


  @override
  void onInit() {
    _isLoaded.value = true;
    super.onInit();
    _videosList.bindStream(
      firebaseFirestore.collection('videos').snapshots().map(
            (QuerySnapshot querySnapshot) {
          List<VideoModel> temp = [];

          for (var doc in querySnapshot.docs) {
            temp.add(VideoModel.fromSnap(doc));
            temp.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          }
          return temp;
        },
      ),
    );
  }

  likeVideo(String id) async {
    DocumentSnapshot documentSnapshot =
    await firebaseFirestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((documentSnapshot.data() as dynamic)['likes'].contains(uid)) {
      await firebaseFirestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firebaseFirestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  deleteVideo(String id) async {
    await firebaseFirestore.collection('videos').doc(id).delete();
  }

  saveVideo(String path) async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = "${appDocDir.path}/temp.mp4";
    await Dio().download(
        path, savePath);
    final result = await ImageGallerySaver.saveFile(savePath);
    if (result['isSuccess'] == true) {
      EasyLoading.showSuccess('Video Saved Successfully');
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Check your Gallery')));
      print(result);
    }
  }
}