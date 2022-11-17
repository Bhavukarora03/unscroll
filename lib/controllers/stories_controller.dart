import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:unscroll/models/user_stories.dart';

import '../constants.dart';

class StoriesController extends GetxController {
  static StoriesController get instance => Get.find();
  final Rx<List<StoriesModel>> _stories = Rx<List<StoriesModel>>([]);
  List<StoriesModel> get stories => _stories.value;
  String uid = authController.user.uid;

  final Rx<List<String>> _urls = Rx<List<String>>([]);
  List<String> get urls => _urls.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _stories.bindStream(
      firebaseFirestore.collection('stories').snapshots().map(
        (QuerySnapshot querySnapshot) {
          List<StoriesModel> temp = [];
          for (var doc in querySnapshot.docs) {
            temp.add(StoriesModel.fromSnap(doc));
          }
          return temp;
        },
      ),
    );
  }

  likeStories() async {
    DocumentSnapshot documentSnapshot =
        await firebaseFirestore.collection('stories').doc().get();
    var uid = authController.user.uid;
    if ((documentSnapshot.data() as dynamic)['likes'].contains(uid)) {
      await firebaseFirestore.collection('stories').doc().update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firebaseFirestore.collection('stories').doc().update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  getUserStories(String uid) async {
    var snaps = await firebaseFirestore.collection('stories').doc(uid).get();
    if (snaps.id == uid) {
      for (var i in snaps.data()!['storyUrl']) {
        _urls.value.add(i['url']);
        _urls.value.toSet().toList();
      }
    }

    return _urls.value;
  }
}
