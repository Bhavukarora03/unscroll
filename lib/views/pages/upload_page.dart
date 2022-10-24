import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:unscroll/views/screens/screens.dart';
import 'package:unscroll/views/widgets/user_profileimg.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  uploadVideo(ImageSource src, BuildContext ctx) async {
    final vid = await ImagePicker().pickVideo(source: src);
    if (vid != null) {
      Get.off(() => ConfirmVideo(
            videoFile: File(vid.path),
            videoPath: vid.path,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         Image.asset('assets/images/upload.png'),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04A547)),
              onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, crossAxisSpacing: 5),
                      children: [
                        Card(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                uploadVideo(ImageSource.camera, context),
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 50,
                            ),
                            label: Text("Upload from Camera"),
                          ),
                        ),
                        Card(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                uploadVideo(ImageSource.gallery, context),
                            icon: const Icon(
                              Icons.photo_library,
                              size: 50,
                            ),
                            label: Text("Upload from Gallery"),
                          ),
                        ),
                      ],
                    ),
                  ),
              icon: const Icon(Icons.video_call),
              label: const Text("Upload a video"))
        ],
      ),
    );
  }
}
