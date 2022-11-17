import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/stories_controller.dart';
import "package:get/get.dart";

class UnscrollStories extends StatefulWidget {
  const UnscrollStories({Key? key, required this.uid }) : super(key: key);

 final String uid;



  @override
  State<UnscrollStories> createState() => _UnscrollStoriesState();
}

class _UnscrollStoriesState extends State<UnscrollStories> {
  final storiesController = Get.put(StoriesController());

  final profileController = Get.put(ProfileController());

  final controller = StoryController();



String uid = "";

getUserStory() {
  uid = widget.uid;
}


  @override
  void initState() {
    storiesController.getUserStories(widget.uid);
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: storiesController.stories.isEmpty
            ? const Center(
                child: Text('No stories'),
              )
            : StoryView(
                storyItems: [
                  for (var i = 0; i < storiesController.urls.length; i++)
                    StoryItem.pageImage(
                      url: storiesController.urls[i],
                      controller: controller,
                      imageFit: BoxFit.cover,
                    ),

                ],
                controller: controller,
                onComplete: () {
                  Get.back();
                },
                progressPosition: ProgressPosition.top,
                repeat: false,
                inline: false,
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Navigator.pop(context);
                  }
                }, //
                onStoryShow: (s) {

                },
              ),
      );
    });
  }
}
