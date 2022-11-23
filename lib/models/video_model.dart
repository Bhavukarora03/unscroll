import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String username;
  String songName;
  String caption;
  List likes;
  int shareCount;
  int commentCount;
  String uid;
  String id;
  String videoUrl;
  String thumbnail;
  String profilePic;
  final DateTime createdAt;

  VideoModel(
      {required this.username,
      required this.songName,
      required this.caption,
      required this.likes,
      required this.shareCount,
      required this.commentCount,
      required this.uid,
      required this.id,
      required this.videoUrl,
      required this.thumbnail,
      required this.profilePic,
      required this.createdAt});


  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'songName': songName,
      'caption': caption,
      'likes': likes,
      'shareCount': shareCount,
      'commentCount': commentCount,
      'uid': uid,
      'id': id,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'profilePic': profilePic,
      'createdAt': createdAt,
    };
  }

  static VideoModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return VideoModel(
      username: snap['username'],
      songName: snap['songName'],
      caption: snap['caption'],
      likes: snap['likes'],
      shareCount: snap['shareCount'],
      commentCount: snap['commentCount'],
      uid: snap['uid'],
      id: snap['id'],
      videoUrl: snap['videoUrl'],
      thumbnail: snap['thumbnail'],
      profilePic: snap['profilePic'],
      createdAt: snap['createdAt'].toDate(),
    );
  }
}
