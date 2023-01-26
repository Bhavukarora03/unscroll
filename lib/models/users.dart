import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String email;
  String profilePic;
  String uid;
  bool thirtyMinDone;
  String bio;
  bool entitlementIsActive;
  User(
      {required this.username,
      required this.email,
      required this.profilePic,
      required this.uid,
      required this.thirtyMinDone,
      required this.bio,
      required this.entitlementIsActive});
  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'profilePic': profilePic,
        'uid': uid,
        'thirtyMinDone': thirtyMinDone,
        'bio': bio,
        'entitlementIsActive': entitlementIsActive,
      };
  static User fromSnap(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
      username: data['username'],
      email: data['email'],
      profilePic: data['profilePic'],
      uid: data['uid'],
      thirtyMinDone: data['thirtyMinDone'],
      bio: data['bio'],
      entitlementIsActive: data['entitlementIsActive'],
    );
  }
}
