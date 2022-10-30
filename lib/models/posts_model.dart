import 'package:cloud_firestore/cloud_firestore.dart';

class PostsModel {
  String username;
  String profilePic;
  String postURL;
  String caption;
  String id;
  String uid;
  List likes;
  int commentCount;

  PostsModel(
      {required this.username,
      required this.profilePic,
      required this.postURL,
      required this.caption,
      required this.id,
      required this.uid,
      required this.likes,
      required this.commentCount});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'profilePic': profilePic,
      'PostUrl': postURL,
      'caption': caption,
      'id': id,
      'uid': uid,
      'likes': likes,
      'commentCount': commentCount,
    };
  }
  static PostsModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return PostsModel(
      username: snap['username'],
      profilePic: snap['profilePic'],
      postURL: snap['PostUrl'],
      caption: snap['caption'],
      id: snap['id'],
      uid: snap['uid'],
      likes: snap['likes'],
      commentCount: snap['commentCount'],
    );
  }
}
