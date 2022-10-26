import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  final Rx<String> _uid = "".obs;

  updateUSerId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];
    var querySnapshot = await firebaseFirestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      thumbnails.add((querySnapshot.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot documentSnapshot =
        await firebaseFirestore.collection('users').doc(_uid.value).get();

    var userData = documentSnapshot.data()! as dynamic;
    String name = userData['username'];
    String profilePic = userData['profilePic'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var items in querySnapshot.docs) {
      likes += (items.data()['likes'] as List).length;
    }

    var followersSnapshot = await firebaseFirestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingSnapshot = await firebaseFirestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();

    followers = followersSnapshot.docs.length;
    following = followingSnapshot.docs.length;

    firebaseFirestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'username': name,
      'profilePic': profilePic,
      'likes': likes.toString(),
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'thumbnails': thumbnails
    };
    update();
  }

  followerUser() async {
    var followersSnapshot = await firebaseFirestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();

    if (!followersSnapshot.exists) {
      await firebaseFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});

      _user.value
          .update('followers', (value) => int.parse(value.toString()) + 1);
    } else {
      await firebaseFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      _user.value
          .update('followers', (value) => int.parse(value.toString()) - 1);
    }
    _user.value.update('isFollowing', (value) => !value);
  }
}
