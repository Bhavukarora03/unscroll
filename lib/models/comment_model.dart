import 'package:cloud_firestore/cloud_firestore.dart';

class Comment{
  String id;
  String comment;
  String userId;
  String profilePic;
  List likes;
  final DateTime createdAt;
  String username;

  Comment({
    required this.id,
    required this.comment,
    required this.userId,
    required this.profilePic,
    required this.likes,
    required this.createdAt,
    required this.username,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'userId': userId,
      'profilePic': profilePic,
      'likes': likes,
      'createdAt': createdAt,
      'username': username,
    };
  }

  static Comment fromJson(DocumentSnapshot doc){
    var snaps = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      comment: snaps['comment'],
      userId: snaps['userId'],
      profilePic: snaps['profilePic'],
      likes: snaps['likes'],
      createdAt: snaps['createdAt'].toDate(),
      username: snaps['username'],
    );
  }

}