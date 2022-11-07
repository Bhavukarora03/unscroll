import 'package:cloud_firestore/cloud_firestore.dart';

class StoriesModel {
  String uid;
  String username;
  String id;
  String profilePic;
  List likes;
  List<Map<String, dynamic>> storyUrl;
   DateTime createdAt;

  StoriesModel({
    required this.uid,
    required this.username,
    required this.id,
    required this.profilePic,
    required this.likes,
    required this.storyUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': username,
      'id': id,
      'profilePic': profilePic,
      'likes': likes,
      'storyUrl': storyUrl,
      'createdAt': createdAt,
    };
  }

  static StoriesModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return StoriesModel(
      createdAt: snap['createdAt'].toDate(),
      uid: snap['uid'],
      username: snap['name'],
      id: snap['id'],
      profilePic: snap['profilePic'],
      likes: snap['likes'],
      storyUrl: snap['storyUrl'],
    );
  }
}
