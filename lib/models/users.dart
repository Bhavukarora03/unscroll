import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String email;
  String profilePic;
  String uid;
  bool thirtyMinDone;
  User(
      {required this.username,
      required this.email,
      required this.profilePic,
      required this.uid,
      required this.thirtyMinDone});


  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'profilePic': profilePic,
        'uid': uid,
        'thirtyMinDone': thirtyMinDone,
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
      username: data['username'],
      email: data['email'],
      profilePic: data['profilePic'],
      uid: data['uid'],
      thirtyMinDone: data['thirtyMinDone'],
    );
  }
}
