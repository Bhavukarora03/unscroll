import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:unscroll/constants.dart';


class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final VoidCallback onDoubleTap;
  const VideoPlayerItem(
      {Key? key, required this.videoUrl, required this.onDoubleTap})
      : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with TickerProviderStateMixin {
  late CachedVideoPlayerController videoController;
  late AnimationController animationController;

  bool _isPlaying = true;
  bool _isMuted = false;

  @override
  void initState() {
    videoController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {

        videoController.play();
        videoController.setVolume(1);
        videoController.setLooping(true);
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
    videoController.dispose();
    animationController.dispose();
    super.dispose();
  }

  isPlayingVideo() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying
          ? animationController.forward()
          : animationController.reverse();
      _isPlaying ? videoController.pause() : videoController.play();
    });
  }

  isMuteVideo() {
    setState(() {
      _isMuted = !_isMuted;
      _isMuted ? videoController.setVolume(0) : videoController.setVolume(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(children: [
          GestureDetector(
            onLongPress: () {
              isPlayingVideo();
              HapticFeedback.heavyImpact();
              showCupertinoModalBottomSheet(
                barrierColor: Colors.black.withOpacity(0.5),
                context: context,
                builder: (context) => Material(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.linear_scale),
                      ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text("Share"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.save),
                        title: const Text("Save"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text("Delete"),
                        onTap: () {},
                      ),
                      height50
                    ],
                  ),
                ),
              );
            },
            onTap: () {
              isMuteVideo();
            },
            onDoubleTap: widget.onDoubleTap,
            child: CachedVideoPlayer(videoController),
          ),
          Visibility(
            visible: _isMuted,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: isMuteVideo,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.volume_up : Icons.volume_off,
                    color: Colors.white24,
                    size: 35,
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
