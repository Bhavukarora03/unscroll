import 'package:flutter/material.dart';
import 'package:story/story_page_view/story_page_view.dart';
import 'package:unscroll/constants.dart';

import '../../controllers/profile_controller.dart';
import '../../controllers/stories_controller.dart';
import "package:get/get.dart";

class UnscrollStories extends StatelessWidget {
  UnscrollStories({Key? key}) : super(key: key);

  final storiesController = Get.put(StoriesController());
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return StoryPageView(
          pageLength: storiesController.stories.length,
          itemBuilder: (context, pageIndex, storyIndex) {
            final data = storiesController.stories[pageIndex];
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(data.storyUrl),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          storyLength: (pageIndex) {
            return profileController.user['storyUrl'][pageIndex];
          },

        );
      }),
    );
  }
}
