import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stories_editor/stories_editor.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/upload_posts_controller.dart';

class ConfirmStory extends StatefulWidget {
  const ConfirmStory({Key? key}) : super(key: key);

  @override
  State<ConfirmStory> createState() => _ConfirmStoryState();
}

class _ConfirmStoryState extends State<ConfirmStory> {
  final uploadController = Get.put(UploadPostsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StoriesEditor(

        isCustomFontList: false,
        middleBottomWidget: const Text(
          'Unscroll',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
        ),
        giphyKey: 'wnxu94r54TTX30ioxkDkbvN0fao2ZD29',
        onDone: (String value)  {
          EasyLoading.show(status: 'Uploading...');
          uploadController.uploadStories(value);
        },
      ),
    );
  }
}
