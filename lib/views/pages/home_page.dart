import 'package:flutter/material.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/video_controller.dart';
import 'package:unscroll/views/widgets/widgets.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final VideoController videoController = Get.put(VideoController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(
      () => PageView.builder(
    itemCount: videoController.videoList.length,
    scrollDirection: Axis.vertical,
    controller: PageController(viewportFraction: 1, initialPage: 0),
    itemBuilder: (context, index) {
      final data = videoController.videoList[index];
      return Stack(
        children: [
          VideoPlayerItem(videoUrl: data.videoUrl),

          Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        data.username,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        data.caption,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.music_note,
                            color: Colors.white,
                          ),
                          Text(
                            data.songName,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      height20,
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 100,
            margin: EdgeInsets.only(
                top: size.height / 4, left: size.width / 1.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildProfileImage(
                  data.profilePic,
                ),
                InkWell(
                  onTap: () => videoController.likeVideo(data.id),
                  child:  Icon(
                    data.likes.contains(authController.user.uid) ?  Icons.favorite : Icons.favorite_border ,
                    color: data.likes.contains(authController.user.uid) ? Colors.red :Colors.white,
                    size: 30,
                  ),
                ),
                Text(data.likes.length.toString()),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.comment,
                    color: Colors.white,
                  ),
                ),
                const Text("0"),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
                const Text("0"),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                  ),
                ),
                CircleAnimation(
                    child: buildMusicAlbumImage(
                        data.thumbnail)),
              ],
            ),
          )
        ],
      );
    },
      ),
    );
  }

  /// Build profile image
  buildProfileImage(String imgPath) {
    return Stack(
      children: [
        CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: UserProfileImage(imageUrl: imgPath)),
        const Positioned(
            bottom: 0,
            left: 30,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.add, color: Colors.white, size: 15),
            )),
      ],
    );
  }

  ///build music album image
  buildMusicAlbumImage(String imgPath) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.black,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.black,
        child: UserProfileImage(imageUrl: imgPath),
      ),
    );
  }
}
