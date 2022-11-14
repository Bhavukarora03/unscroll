import 'package:cloud_firestore/cloud_firestore.dart';

class StoriesModel {
  String uid;
  String username;
  String id;
  String profilePic;
  List likes;
  List<dynamic> storyUrl;
  final DateTime createdAt;

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
      'username': username,
      'id': id,
      'profilePic': profilePic,
      'likes': likes,
      'storyUrl': storyUrl,
      'createdAt': createdAt,
    };
  }
static StoriesModel fromSnap(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return StoriesModel(
      uid: data['uid'],
      username: data['username'],
      id: data['id'],
      profilePic: data['profilePic'],
      likes: data['likes'],
      storyUrl: data['storyUrl'],
      createdAt: data['createdAt'].toDate(),
    );
  }
}
