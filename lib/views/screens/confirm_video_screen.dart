import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/widgets/text_input_fields.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/video_controller.dart';

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
  late VideoPlayerController controller;

  TextEditingController songNameController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  final videoController = Get.put(UploadVideoController());
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
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
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(children: [
        Stack(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: VideoPlayer(controller),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
                onPressed: () {
                  controller.pause();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close)),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 80,
            top: 80,
            right: 80,
            child: IconButton(
              onPressed: () {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
              },
              icon: const Icon(
                Icons.pause,
                color: Colors.white70,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
                onPressed: () {
                  controller.setVolume(0);
                },
                icon: const Icon(Icons.volume_mute_outlined)),
          ),
        ]),
        height20,
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Add a song to your video",
                  style: TextStyle(fontSize: 15)),
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
              height20,
              ElevatedButton.icon(
                onPressed: () => videoController.uploadVideo(
                    songNameController.text,
                    captionController.text,
                    widget.videoPath),
                icon: const Icon(Icons.upload),
                label: const Text("Upload"),
              )
            ],
          ),
        ),
      ]),
    )));
  }
}
