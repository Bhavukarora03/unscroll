import 'package:flutter/material.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/video_controller.dart';
import 'package:unscroll/views/widgets/widgets.dart';
import 'package:get/get.dart';


class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final VideoController videoController = Get.put(VideoController());
  final TextEditingController commentController = TextEditingController();

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
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return buildCommentSection();
                            });
                      },
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
                        child: buildMusicAlbumImage(data.thumbnail)),
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

  ///buildCommentSection
  buildCommentSection() {
    return DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.8,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Icon(
                    Icons.remove,
                    color: Colors.grey[600],
                    size: 50,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Comments",
                          style: TextStyle(fontSize: 15),
                        )),
                  ),
                   Card(
                    child: TextFormField(
                      controller: commentController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add a comment...",
                          prefixIcon: Icon(Icons.add_comment),
                           suffixIcon: Icon(Icons.send)


                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: 1,
                      itemBuilder: (_, index) {
                        return Column(
                          children: [
                            ListTile(
                              isThreeLine: true,
                              leading: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.black,
                                  child: UserProfileImage(
                                      imageUrl:
                                          "https://images.unsplash.com/photo-1620922478183-8b2b2b2b2b2b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
                                ),
                              ),
                              title: Row(
                                children: const [
                                  Text(
                                    "Username",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    indent: 40,
                                  ),
                                 Text(
                                    "datetime",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )
                                ],
                              ),
                              subtitle: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: const [
                                      Text("Comment"),
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        "10 Likes",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              trailing: InkWell(
                                  onTap: () {},
                                  child: const Icon(Icons.favorite_border)),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ));
  }
}
