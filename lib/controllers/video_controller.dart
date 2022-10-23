import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/models/video_model.dart';

class VideoController extends GetxController {


  final Rx<List<VideoModel>> _videosList = Rx<List<VideoModel>>([]);

  List<VideoModel> get videoList => _videosList.value;

  @override
  void onInit() {
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
}
