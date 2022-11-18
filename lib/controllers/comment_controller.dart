import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/models/comment_model.dart' as com_model;

class CommentController extends GetxController {
  static CommentController get instance => Get.find();
  final Rx<List<com_model.Comment>> _unscrollComments = Rx<List<com_model.Comment>>([]);
  List<com_model.Comment> get unscrollComments => _unscrollComments.value;

  final Rx<List<com_model.Comment>> _postsComment = Rx<List<com_model.Comment>>([]);
  List<com_model.Comment> get postsComment => _postsComment.value;

  String _postId = '';

  updatePostID(String commentID) {
    _postId = commentID;
    getComment();
  }



  getComment() async {
    _unscrollComments.bindStream(firebaseFirestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<com_model.Comment> temp = [];
      for (var doc in querySnapshot.docs) {
        temp.add(com_model.Comment.fromJson(doc));
      }
      return temp;
    }));

    _postsComment.bindStream(firebaseFirestore
        .collection('posts')
        .doc(_postId)
        .collection('comments')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<com_model.Comment> temp = [];
      for (var doc in querySnapshot.docs) {
        temp.add(com_model.Comment.fromJson(doc));
      }
      return temp;
    }));

  }

  postComment(String commentText, String collection) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDocs = await firebaseFirestore
            .collection('users')
            .doc(authController.user.uid)
            .get();

        var allDocs = await firebaseFirestore
            .collection(collection)
            .doc(_postId)
            .collection('comments')
            .get();

        int length = allDocs.docs.length;

        com_model.Comment comments = com_model.Comment(
          id: 'Comment $length',
          username: (userDocs.data()! as dynamic)['username'],
          comment: commentText.trim(),
          userId: authController.user.uid,
          profilePic: (userDocs.data()! as dynamic)['profilePic'],
          likes: [],
          createdAt: DateTime.now(),
        );

        await firebaseFirestore
            .collection(collection)
            .doc(_postId)
            .collection('comments')
            .doc('comment $length')
            .set(comments.toJson());

        DocumentSnapshot snapshot =
            await firebaseFirestore.collection(collection).doc(_postId).get();
        await firebaseFirestore.collection(collection).doc(_postId).update({
          'commentCount': (snapshot.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar('error', e.toString());
    }
  }



  likeComment(String id, String collection) async {
    String uid = authController.user.uid;
    DocumentSnapshot snapshot = await firebaseFirestore
        .collection(collection)
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    if ((snapshot.data()! as dynamic)['likes'].contains(uid)) {
      await firebaseFirestore
          .collection(collection)
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firebaseFirestore
          .collection(collection)
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}

