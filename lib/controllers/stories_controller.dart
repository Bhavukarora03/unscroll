

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:unscroll/models/user_stories.dart';

import '../constants.dart';

class StoriesController extends GetxController {
  final Rx<List<StoriesModel>> _stories = Rx<List<StoriesModel>>([]);
  List<StoriesModel> get stories => _stories.value;

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

}
