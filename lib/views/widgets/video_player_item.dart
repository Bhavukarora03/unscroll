import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with TickerProviderStateMixin {
  late VideoPlayerController controller;
  late AnimationController animationController;

  bool _isPlaying = false;
  bool _isMuted = false;


  @override
  void initState() {
    controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        controller.play();
        controller.setVolume(1);
        controller.setLooping(true);
      });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  isPlayingVideo() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying
          ? animationController.forward()
          : animationController.reverse();
      _isPlaying ? controller.pause() : controller.play();
    });
  }

  isMuteVideo() {
    setState(() {
      _isMuted = !_isMuted;
      _isMuted ? controller.setVolume(0) : controller.setVolume(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(children: [
          VideoPlayer(controller),
          Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: isPlayingVideo,
                  child: AnimatedIcon(
                    color: Colors.white24,
                    size: 80,
                    icon: AnimatedIcons.pause_play,
                    progress: animationController,
                  ),
                )),
          ),
          Positioned(
              child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: isMuteVideo,
              child: Icon(
                _isPlaying ? Icons.volume_up : Icons.volume_off,
                color: Colors.white24,
                size: 35,
              ),
            ),
          ))
        ]),

    );
  }
}
