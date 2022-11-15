

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/models/video_model.dart';

class VideoController extends GetxController {
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


}
