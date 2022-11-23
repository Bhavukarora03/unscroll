import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/widgets/user_profileimg.dart';

class EditProfile extends StatelessWidget {
  EditProfile(
      {Key? key,
      required this.uid,
      required this.username,
      required this.profilePic})
      : super(key: key);

  final String uid;
  final String username;
  final String profilePic;

  TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController =
        TextEditingController(text: username);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Edit Profile'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
              child: Stack(children: [
            GestureDetector(
                child: UserProfileImage(imageUrl: profilePic, radius: 50))
          ])),
          const SizedBox(height: 20),
          TextField(
            controller: usernameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          TextField(
            controller: bioController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Add Bio',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              Future.delayed(const Duration(seconds: 1));
              await firebaseFirestore.collection('users').doc(uid).update({
                'username': usernameController.text,
                'bio': bioController.text,
              });

              Get.back();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
