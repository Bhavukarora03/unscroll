import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/widgets/sharedprefs.dart';
import 'package:url_launcher/url_launcher.dart';

class PrankScreen extends StatefulWidget {
  const PrankScreen({Key? key}) : super(key: key);

  @override
  State<PrankScreen> createState() => _PrankScreenState();
}

class _PrankScreenState extends State<PrankScreen>
    with TickerProviderStateMixin {
  late CachedVideoPlayerController videoController;
  @override
  void initState() {
    authController.checkIfTwentyFourHrsIsDone();
    videoController = CachedVideoPlayerController.network(
        "https://firebasestorage.googleapis.com/v0/b/unscroll.appspot.com/o/videos%2Fanimegurls.mp4?alt=media&token=bf86943b-d62f-4511-9bfa-3c136ff92e35")
      ..initialize().then((_) {
        videoController.play();
        videoController.setVolume(0.1);
        videoController.setLooping(true);
        videoController.seekTo(const Duration(seconds: 1));
      });

    super.initState();
  }

  final Uri _url = Uri.parse('https://www.youtube.com/watch?v=vq5NvJvr55Q');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(children: [
        Positioned.fill(child: CachedVideoPlayer(videoController)),
        Positioned(
          child: Container(
              decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Unscroll',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              height10,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  authController.addingInAppPurchases();
                },
                child: Text('Remove ads?'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: _launchUrl,
                child: Text('Watch the video'),
              ),
              BackButton(
                color: Colors.white,
                onPressed: () async {
                  TextPreferences.setTime(1800);
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        ),
      ]);

  }
}
