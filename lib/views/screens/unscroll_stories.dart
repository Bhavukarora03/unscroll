import 'package:flutter/material.dart';
import 'package:story/story_page_view/story_page_view.dart';
import 'package:story_view/controller/story_controller.dart';

import '../../controllers/profile_controller.dart';
import '../../controllers/stories_controller.dart';
import "package:get/get.dart";

class UnscrollStories extends StatefulWidget {
  const UnscrollStories({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<UnscrollStories> createState() => _UnscrollStoriesState();
}

class _UnscrollStoriesState extends State<UnscrollStories> {
  final storiesController = Get.put(StoriesController());

  final profileController = Get.put(ProfileController());

  final controller = StoryController();

  @override
  void initState() {
    storiesController.getUserStories(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          body: StoryPageView(
        itemBuilder: (context, pageIndex, storyIndex) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    storiesController.urls[storyIndex]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        storyLength: (pageIndex) {
          return storiesController.stories[pageIndex].storyUrl.length;
        },
        pageLength: storiesController.stories.length,
      ));
    });
  }
}
