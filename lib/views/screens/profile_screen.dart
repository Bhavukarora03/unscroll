import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/profile_controller.dart';
import 'package:unscroll/views/screens/followers_count.dart';
import 'package:unscroll/views/screens/following_count.dart';
import 'package:unscroll/views/widgets/widgets.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  String uid = "";

  getUserids() async {
    uid = widget.uid;
  }

  final options = const LiveOptions(
    delay: Duration(milliseconds: 100),
    showItemInterval: Duration(milliseconds: 500),
    showItemDuration: Duration(seconds: 1),
    visibleFraction: 0.05,
    reAnimateOnVisibility: false,
  );

  @override
  void initState() {
    profileController.updateUSerId(widget.uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_add),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    height20,
                    Align(
                        alignment: Alignment.center,
                        child: UserProfileImage.medium(
                            imageUrl: profileController.user['profilePic'],
                            radius: 50)),
                    height40,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Expanded(
                            child: Column(
                              children: [
                                Text(profileController.user['likes']),
                                const Text('likes'),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Get.to(() => FollowersCount()),
                          child: Expanded(
                            child: Column(
                              children: [
                                Text(profileController.user['followers']),
                                const Text('Followers'),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Get.to(() => FollowingCount()),
                          child: Expanded(
                            child: Column(
                              children: [
                                Text(profileController.user['following']),
                                const Text('Following'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    height40,
                    const Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Container(
                      width: 140,
                      height: 47,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            if (widget.uid == authController.user.uid) {
                              authController.signOut();
                            } else {
                              profileController.followerUser();
                            }
                          },
                          child: Text(
                            widget.uid == authController.user.uid
                                ? 'Sign Out'
                                : profileController.user['isFollowing']
                                    ? 'Unfollow'
                                    : 'Follow',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    LiveGrid.options(
                      options: options,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: profileController.user['thumbnails'].length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 250,
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5),
                        itemBuilder: buildAnimatedItem
                        )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildAnimatedItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) =>
      // For example wrap with fade transition
      FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        // And slide transition
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.1),
            end: Offset.zero,
          ).animate(animation),
          // Paste you Widget
          child: SizedBox(
            width: 100,
            height: 100,
            child: CachedNetworkImage(
              imageUrl: profileController.user['thumbnails'][index],
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}
