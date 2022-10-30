import 'package:flutter/material.dart';
import 'package:unscroll/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:unscroll/views/widgets/widgets.dart';

class FollowersCount extends StatelessWidget {
   FollowersCount({Key? key}) : super(key: key);

  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Followers"),

      ),
      body: ListView.builder(
          itemCount: profileController.user['followers'].length,
          itemBuilder: (context, index) {

        return   ListTile(
          leading:  UserProfileImage.medium(imageUrl: profileController.user['profilePic'],),
          title:  Text(profileController.user['username'][index]),
          trailing:  TextButton(onPressed: () {  },
          child: const Text("Remove")),
        );
      }),
    );

  }
}
