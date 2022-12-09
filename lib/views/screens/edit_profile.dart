import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';

import '../widgets/user_profileimg.dart';

class EditProfile extends StatelessWidget {
  const EditProfile(
      {super.key,
      required this.uid,
      required this.username,
      required this.profilePic,
      required this.bio});
  final String uid;
  final String bio;
  final String username;
  final String profilePic;

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController =
        TextEditingController(text: username);
    TextEditingController bioController = TextEditingController(text: bio);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            onPressed: () async{
              await firebaseFirestore.collection('users').doc(uid).update({
                'username': usernameController.text,
                'bio': bioController.text,
              });

              Get.back();
            },
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
                child: Stack(children: [
              GestureDetector(
                  child: UserProfileImage(
                imageUrl: profilePic,
                radius: 50,
              ))
            ])),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(
                labelText: 'Add Bio',
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
