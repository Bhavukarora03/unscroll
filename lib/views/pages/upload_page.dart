import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unscroll/views/screens/screens.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

 uploadVideo(ImageSource src, BuildContext ctx) async {
    final vid = await ImagePicker().pickVideo(source: src);
    if (vid != null) {
      Get.off(() => const ConfirmVideo());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300),
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: const Text("Upload"),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera),
                          title: const Text("Camera"),
                          onTap: () => uploadVideo(ImageSource.camera, context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text("Gallery"),
                          onTap: () => uploadVideo(ImageSource.gallery, context),
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
