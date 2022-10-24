import 'package:flutter/material.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/comment_controller.dart';
import 'package:unscroll/controllers/video_controller.dart';
import 'package:unscroll/views/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as TimeAgo;

class HomePage extends StatelessWidget {

   HomePage({Key? key}) : super(key: key);

  final VideoController videoController = Get.put(VideoController());
  final TextEditingController commentTextController = TextEditingController( );
  final CommentController  commentController = Get.put(CommentController());


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
          final commentID = data.id;
          commentController.updatePostID(commentID);
          return SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
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
                        child: Icon(
                          data.likes.contains(authController.user.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: data.likes.contains(authController.user.uid)
                              ? Colors.red
                              : Colors.white,
                          size: 30,
                        ),
                      ),
                      Text(data.likes.length.toString()),
                      InkWell(
                        onTap: () {
                          showMaterialModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            bounce: true,
                            context: context,
                            builder: (context) => buildCommentSection(index, context)
                          );
                        },
                        child: const Icon(
                          Icons.comment,
                          color: Colors.white,
                        ),
                      ),
                       Text(data.commentCount.toString()),
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
                          child: buildMusicAlbumImage(data.thumbnail)),
                    ],
                  ),
                )
              ],
            ),
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

  ///buildCommentSection
  buildCommentSection(int index, BuildContext context) {
    final data = videoController.videoList[index];
    final comment = commentController.comments[index];

    return  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                Icons.remove,
                color: Colors.grey[600],
                size: 50,
              ),
            const  Padding(
                padding:
                 EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Comments",
                      style:  TextStyle(fontSize: 15),
                    )),
              ),

              Expanded(
                child: Obx(() =>
                  ListView.builder(
                    itemCount: commentController.comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        isThreeLine: true,
                        leading: UserProfileImage.small(imageUrl: data.profilePic),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:  [
                           const  Icon(Icons.favorite_border),
                            Text(comment.likes.length.toString(), style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Text(TimeAgo.format(comment.createdAt.toLocal()),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        title: Row(

                          children:  [
                            Text(
                              comment.username,
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.w400,
                              fontSize: 12),
                            ),
                            const Divider( indent: 20,),
                            Text(
                              comment.comment,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Card(
                  child: ListTile(
                    leading: buildProfileImage(
                     comment.profilePic,
                    ),
                    title:  TextFormField(
                      controller: commentTextController,
                      decoration: const InputDecoration(
                        hintText: "Add a comment...",
                        border: InputBorder.none,
                      ),
                    ),

                    trailing: IconButton(
                      onPressed: ()  {

                        commentController.postComment(commentTextController.text);
                        commentTextController.clear();
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }
}
