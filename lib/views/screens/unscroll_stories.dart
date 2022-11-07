import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story/story_page_view/story_page_view.dart';
import 'package:unscroll/views/widgets/user_profileimg.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/stories_controller.dart';
import "package:get/get.dart";

class UnscrollStories extends StatelessWidget {
  UnscrollStories({Key? key}) : super(key: key);

  final storiesController = Get.put(StoriesController());

  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          body: StoryPageView(
              itemBuilder: (context, pageIndex, storyIndex) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        controller.user['storyUrl'][storyIndex],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              storyLength: (pageIndex) {
                return controller.user['storyUrl'].length;
              },
              pageLength: 1),
        );
      },
    );
  }
}
