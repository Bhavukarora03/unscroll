import 'package:flutter/material.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: PageController(viewportFraction: 1, initialPage: 0),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              //VideoPlayerItem(videoUrl: videoUrl)

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
                          const Text(
                            'Title',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          const Text(
                            'Description',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.music_note,
                                color: Colors.white,
                              ),
                              Text(
                                'Song name',
                                style: TextStyle(
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
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Text("0"),
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
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")),
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
