import 'dart:io';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            OutlinedButton(
              onPressed: () async {
                KeyboardUnFocus(context).hideKeyboard();
                await videoController.uploadVideo(songNameController.text,
                    captionController.text, widget.videoPath);
              },
              child: const Text('Confirm Post'),
            ),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            Stack(children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 10,
                      blurRadius: 100,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.3,
                child: CachedVideoPlayer(controller),
              ),
            ]),
            height20,
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  height30,
                  TextInputField(
                    controller: songNameController,
                    labelText: 'Song Name',
                    prefixIcon: Icons.music_note,
                    autofillHints: AutofillHints.name,
                  ),
                  height20,
                  TextInputField(
                    controller: captionController,
                    labelText: "Add a caption",
                    prefixIcon: Icons.closed_caption,
                    autofillHints: 'caption',
                  ),
                ],
              ),
            ),
          ]),
        )));
  }
}
