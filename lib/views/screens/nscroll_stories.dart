import 'package:flutter/material.dart';
import 'package:story/story_page_view/story_page_view.dart';

class UnscrollStories extends StatelessWidget {
  const UnscrollStories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Minimum example to explain the usage.
    return Scaffold(
      body: StoryPageView(
        itemBuilder: (context, pageIndex, storyIndex) {
          return Center(
            child: Text(
                "Index of PageView: $pageIndex Index of story on each page: $storyIndex"),
          );
        },
        storyLength: (pageIndex) {
          return 3;
        },
        pageLength: 1,
      ),
    );
  }
}
