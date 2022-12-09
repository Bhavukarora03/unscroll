import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:story/story_page_view/story_page_view.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/widgets/widgets.dart';

import '../../controllers/profile_controller.dart';
import '../../controllers/stories_controller.dart';
import "package:get/get.dart";

class UnscrollStories extends StatefulWidget {
  const UnscrollStories({Key? key}) : super(key: key);

  @override
  State<UnscrollStories> createState() => _UnscrollStoriesState();
}

class _UnscrollStoriesState extends State<UnscrollStories> {
  final storiesController = Get.put(StoriesController());

  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          body: StoryPageView(
        onPageLimitReached: () {
          Get.back();
        },
        itemBuilder: (context, pageIndex, storyIndex) {
          return Stack(children: [
            Positioned.fill(
              child: CachedNetworkImage(
                  imageUrl:
                      storiesController.stories[pageIndex].storyUrl[storyIndex],
                  fit: BoxFit.cover),
            ),
            //userprofile image
            Positioned(
              top: 60,
              left: 20,
              child: Row(
                children: [
                  UserProfileImage.small(
                      imageUrl:
                          storiesController.stories[pageIndex].profilePic),
                  height10,
                  Text(
                    storiesController.stories[pageIndex].username,
                    style: const TextStyle( fontSize: 20),
                  ),
                 Positioned(
                   top: 60,
                    right: 20,
                   child: IconButton(onPressed: (){}, icon: const Icon(Icons.heart_broken)),
                 )
                ],
              ),
            ),
          ]);
        },
        storyLength: (pageIndex) {
          return storiesController.stories[pageIndex].storyUrl.length;
        },
        pageLength: storiesController.stories.length,
      ));
    });
  }
}
