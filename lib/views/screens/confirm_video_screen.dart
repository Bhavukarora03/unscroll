import 'dart:io';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/widgets/text_input_fields.dart';
import '../../controllers/upload_video_controller.dart';

class ConfirmVideo extends StatefulWidget {
  const ConfirmVideo(
      {Key? key, required this.videoFile, required this.videoPath})
      : super(key: key);

  final File videoFile;
  final String videoPath;

  @override
  State<ConfirmVideo> createState() => _ConfirmVideoState();
}

class _ConfirmVideoState extends State<ConfirmVideo> {
  late CachedVideoPlayerController controller;

  TextEditingController songNameController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  final videoController = Get.put(UploadVideoController());
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      controller = CachedVideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,

        title: const Text('Your Unscroll', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                EasyLoading.show(
                  dismissOnTap: false,
                  status: 'Uploading...',
                  maskType: EasyLoadingMaskType.black,
                );
                KeyboardUnFocus(context).hideKeyboard();

                await videoController.uploadVideo(songNameController.text,
                    captionController.text, widget.videoPath);
              },
              child: const Text('Confirm Upload'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

            children: [
              height50,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  height30,
                  Flexible(
                    child: SizedBox(
                      width: 200,
                      child: TextInputField(
                        controller: songNameController,
                        labelText: 'Song Name',
                        prefixIcon: Icons.music_note,
                        autofillHints: AutofillHints.name,
                      ),
                    ),
                  ),

                  Flexible(
                    child: SizedBox(
                      width: 200,
                      child: TextInputField(
                        controller: captionController,
                        labelText: "Add a caption",
                        prefixIcon: Icons.closed_caption,
                        autofillHints: 'caption',
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  height: 550,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedVideoPlayer(controller),
                  ),
                ),
              ),
              height10,

            ],
          ),
        ),
      ),
    );
  }
}
