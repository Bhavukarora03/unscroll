import 'package:flutter/material.dart';


import '../../controllers/profile_controller.dart';
import 'package:get/get.dart';

class FollowingCount extends StatelessWidget {
  FollowingCount({Key? key}) : super(key: key);
final ProfileController profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Following"),
      ),
      body: ListView.builder(
          itemCount: profileController.user['following'].length,
          itemBuilder: (context, index) {
        return const ListTile(
        );
      }),
    );
  }
}
