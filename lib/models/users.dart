import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String profileImg;
  final String uid;
  User(
      {required this.name,
      required this.email,
      required this.profileImg,
      required this.uid});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'profileImg': profileImg,
        'uid': uid,
      };

  static User fromSnap(DocumentSnapshot snapshot){
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
      name: data['name'],
      email: data['email'],
      profileImg: data['profileImg'],
      uid: data['uid'],
    );
  }


}
