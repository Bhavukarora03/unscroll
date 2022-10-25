import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/screens/screens.dart';


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
    else{
      Get.snackbar("Error", "No Video Selected");
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
              onPressed: () => showCupertinoModalBottomSheet(
                topRadius: const Radius.circular(20),
                    barrierColor: Colors.black.withOpacity(0.5),
                    context: context,
                    builder: (context) => Material(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Icon(Icons.minimize, size: 30,),
                          height20,
                          ListTile(
                            leading: const Icon(Icons.camera),
                            title: const Text("Camera"),
                            onTap: () => uploadVideo(ImageSource.camera, context),
                          ),
                        const  Divider(
                            height: 1,
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                          ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text("Gallery"),
                            onTap: () => uploadVideo(ImageSource.gallery, context),
                          ),
                          height60,



                        ],
                      ),
                    )
                  ),
              icon: const Icon(Icons.video_call),
              label: const Text("Upload a video"))
        ],
      ),
    );
  }
}
