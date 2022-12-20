import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:unscroll/models/user_stories.dart';

import '../constants.dart';

class StoriesController extends GetxController {
  static StoriesController get instance => Get.find();
  final Rx<List<StoriesModel>> _stories = Rx<List<StoriesModel>>([]);
  List<StoriesModel> get stories => _stories.value;

  String uid = authController.user.uid;

  final Rx<List<dynamic>> _urls = Rx<List<String>>([]);
  List<dynamic> get urls => _urls.value;

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
            temp.sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
    await firebaseFirestore
        .collection('stories')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) => _urls.value = value
            .data()!['storyUrl']
            .map((e) => e.toString())
            .toList()
            .cast<String>());

    return _urls.value;
  }
}
