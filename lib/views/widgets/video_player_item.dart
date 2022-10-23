import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController controller;
  @override
  void initState() {
    controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        controller.play();
        controller.setVolume(1);
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Stack(children: [
        VideoPlayer(controller),
        Positioned(
            child: IconButton(
                onPressed: () {
                  controller.setVolume(0);
                },
                icon: Icon(Icons.volume_mute))),
      ]),
    );
  }
}
