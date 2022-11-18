import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/comment_controller.dart';
import 'package:unscroll/controllers/upload_video_controller.dart';
import 'package:unscroll/controllers/video_controller.dart';
import 'package:unscroll/views/screens/comments_screen.dart';
import 'package:unscroll/views/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final VideoController videoController = Get.put(VideoController());
  final TextEditingController commentTextController = TextEditingController();
  final CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Obx(
      () => Scaffold(
          body: videoController.isLoaded
              ? PageView.builder(
                  itemCount: videoController.videoList.length,
                  scrollDirection: Axis.vertical,
                  controller: PageController(
                      viewportFraction: 1, initialPage: 0, keepPage: true),
                  itemBuilder: (context, index) {
                    final data = videoController.videoList[index];
                    final commentID = data.id;
                    commentController.updatePostID(commentID);
                    return SizedBox(
                      height: size.height,
                      width: size.width,
                      child: Stack(
                        children: [
                          VideoPlayerItem(
                            videoUrl: data.videoUrl,
                            onDoubleTap: () {
                              videoController.likeVideo(data.id);
                            },
                          ),
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: Colors.white,
                                                fontSize: 15),
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
                                  onTap: () =>
                                      videoController.likeVideo(data.id),
                                  child: Icon(
                                    data.likes.contains(authController.user.uid)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: data.likes
                                            .contains(authController.user.uid)
                                        ? Colors.red
                                        : Colors.white,
                                    size: 30,
                                  ),
                                ),
                                Text(data.likes.length.toString()),
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                        CommentsScreen(
                                            commentTextController:
                                                commentTextController),
                                        transition: Transition.rightToLeft);
                                  },
                                  child: const Icon(
                                    Icons.comment,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(data.commentCount.toString()),
                                InkWell(
                                  onTap: () {
                                    Share.share(
                                        'Check out this video on Unscroll: ${data.videoUrl}');
                                  },
                                  child: const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.find<UploadVideoController>()
                                        .saveVideo(data.videoUrl);
                                  },
                                  child: const Icon(
                                    Icons.bookmark_border,
                                    color: Colors.white,
                                  ),
                                ),
                                CircleAnimation(
                                    child:
                                        buildMusicAlbumImage(data.thumbnail)),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
              : Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                  ))),
    );
  }

  /// Build profile image
  buildProfileImage(String imgPath) {
    return Stack(
      children: [
        CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: UserProfileImage.medium(imageUrl: imgPath)),
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
        child: UserProfileImage.small(imageUrl: imgPath),
      ),
    );
  }



}
