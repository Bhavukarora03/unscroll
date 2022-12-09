import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:unscroll/models/posts_model.dart';
import '../constants.dart';

class PostController extends GetxController {
  final Rx<List<PostsModel>> _posts = Rx<List<PostsModel>>([]);
  List<PostsModel> get postsLists => _posts.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _posts.bindStream(
      firebaseFirestore.collection('posts').snapshots().map(
        (QuerySnapshot querySnapshot) {
          List<PostsModel> temp = [];
          for (var doc in querySnapshot.docs) {
            temp.add(PostsModel.fromSnap(doc));
            temp.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          }

          return temp;
        },
      ),
    );
  }

  likePost(String id) async {
    DocumentSnapshot documentSnapshot =
        await firebaseFirestore.collection('posts').doc(id).get();
    var uid = authController.user.uid;
    if ((documentSnapshot.data() as dynamic)['likes'].contains(uid)) {
      await firebaseFirestore.collection('posts').doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firebaseFirestore.collection('posts').doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  deletePost(String id) async {
    await firebaseFirestore.collection('posts').doc(id).delete();
  }

  updatePost(String id, String caption) async {
    await firebaseFirestore.collection('posts').doc(id).update({
      'caption': caption,
    });
    if (Get.isDialogOpen!) Get.back();
  }

  void saveNetworkImage(String pathProvided) async {
    try {
      // Saved with this method.
      var file = DefaultCacheManager().downloadFile(pathProvided);
      if (file != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Image Saved'),
          ),
        );
      }
      Get.back();
    } on PlatformException catch (error) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text('Download Failed $error')));
    }
  }

}
