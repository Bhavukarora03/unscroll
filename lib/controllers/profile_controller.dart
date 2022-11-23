import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  final Rx<List> _followers = Rx<List>([]);

  List get followers => _followers.value;

  final Rx<List<String>> _following = Rx<List<String>>([]);

  List<String> get following => _following.value;

  final Rx<String> _uid = "".obs;

  updateUSerId(String uid) {
    _uid.value = uid;
    getUserData();
    getFollowerCount();
  }

  getUserData() async {
    List<String> thumbnails = [];
    List<String> posts = [];
    List<dynamic> stories = [];
    var querySnapshot = await firebaseFirestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      thumbnails.add((querySnapshot.docs[i].data() as dynamic)['thumbnail']);
    }

    var querySnapshot2 = await firebaseFirestore
        .collection('posts')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < querySnapshot2.docs.length; i++) {
      posts.add((querySnapshot2.docs[i].data() as dynamic)['PostUrl']);
    }
    //
    var querySnapshot3 = await firebaseFirestore
        .collection('stories')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < querySnapshot3.docs.length; i++) {
      stories.add(
          (querySnapshot3.docs[i].data() as dynamic)['storyUrl'][0]['url']);
    }



    DocumentSnapshot documentSnapshot =
        await firebaseFirestore.collection('users').doc(_uid.value).get();

    var userData = documentSnapshot.data()! as dynamic;
    String name = userData['username'];
    String profilePic = userData['profilePic'];
    String bio = userData['bio'];
    int likes = 0;
    int storiesUrls = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var items in querySnapshot.docs) {
      likes += (items.data()['likes'] as List).length;
    }

    for (var items in querySnapshot3.docs) {
      storiesUrls += (items.data()['storyUrl'] as List<dynamic>).length;
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
      'thumbnails': thumbnails,
      'PostUrl': posts,
      'storyUrl': storiesUrls.toString(),
      'bio': bio,
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
          .set({


      });
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({
        'email': authController.user.email,
        'uid': _uid.value,
        'username': _user.value['username'],
        'profilePic': _user.value['profilePic']
      });

      _user.value
          .update('followers', (value) => (int.parse(value) + 1).toString());
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
          .update('following', (value) => (int.parse(value) - 1).toString());
    }
    _user.value.update('isFollowing', (value) => !value);
  }

getFollowerCount () async{
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

    _followers.value = followersSnapshot.docs;

    _following.value = followingSnapshot.docs.map((e) => e.id).toList();
    update();
}

unfollowUser()async{
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
          .update('following', (value) => (int.parse(value) - 1).toString());
      _user.value.update('isFollowing', (value) => !value);
      update();
}

}
