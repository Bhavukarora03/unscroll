import 'package:flutter/material.dart';
import 'package:unscroll/controllers/profile_controller.dart';
import 'package:get/get.dart';

class FollowersCount extends StatelessWidget {
  FollowersCount({Key? key, required this.uid}) : super(key: key);

  final String uid;
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Followers"),

        ),
        body: GetBuilder<ProfileController>(
            init: profileController,
            builder: (logic) {
          return ListView.builder(
            itemCount: profileController.following.length,
            itemBuilder: (context, index) {
              return ListTile(

                title: Text(profileController.following[index]),
                trailing: TextButton(onPressed: (){

                  profileController.unfollowUser();

                }, child: const Text("Unfollow")),


              );
            },
          );
        })

    );
  }
}
