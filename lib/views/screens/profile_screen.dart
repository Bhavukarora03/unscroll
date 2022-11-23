import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/profile_controller.dart';
import 'package:unscroll/views/screens/followers_count.dart';
import 'package:unscroll/views/screens/following_count.dart';

import 'package:unscroll/views/widgets/widgets.dart';
import 'package:get/get.dart';

import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final ProfileController profileController = Get.put(ProfileController());

  String uid = "";
  late TabController _tabController;

  getUserids() async {
    uid = widget.uid;
  }

  @override
  void initState() {
    profileController.updateUSerId(widget.uid);
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.user.isEmpty) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.teal,
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                height20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserProfileImage.medium(
                            imageUrl: profileController.user['profilePic'],
                            radius: 35),
                        height10,
                        Text(
                          profileController.user['username'],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        height10,
                        Text(
                           profileController.user['bio'],
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),

                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          profileController.user['PostUrl'].length.toString(),
                        ),
                        const Text('posts')
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => FollowersCount(
                              uid: widget.uid,

                        ));
                      },
                      child: Column(
                        children: [
                          Text(
                            profileController.user['followers'].toString(),
                          ),
                          const Text('Followers')
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => FollowingCount());
                      },
                      child: Column(
                        children: [
                          Text(
                            profileController.user['following'],
                          ),
                          const Text('Following')
                        ],
                      ),
                    ),
                    IconButton(onPressed: (){
                      showModalBottomSheet(context: context, builder: (context){
                        return SizedBox(
                          height: 125,
                          child: Column(
                            children: [
                              Icon(Icons.minimize),

                              ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text("Logout"),
                                onTap: (){
                                  authController.signOut();
                                },
                              ),
                            ],
                          ),
                        );
                      });

                    }, icon: const Icon(Icons.more_vert))
                  ],
                ),
                height20,
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          label: Text(
                            widget.uid == authController.user.uid
                                ? 'Edit Profile'
                                : profileController.user['isFollowing']
                                    ? 'Unfollow'
                                    : 'Follow',
                          ),
                          icon: widget.uid == authController.user.uid
                              ? const Icon(Icons.edit)
                              : const Icon(Icons.person_add),
                          onPressed: () {
                            if (widget.uid == authController.user.uid) {
                              Get.to(() => EditProfile(
                                  uid: widget.uid,
                                  username: profileController.user['username'],
                                  profilePic:
                                      profileController.user['profilePic']));
                            } else {
                              profileController.followerUser();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                height20,
                TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(
                      text: 'Posts',
                    ),
                    Tab(
                      text: 'Unscrolls',
                    ),
                  ],
                ),
                TabBarLibrary(tabController: _tabController),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TabBarLibrary extends StatefulWidget {
  const TabBarLibrary({
    Key? key,
    required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  State<TabBarLibrary> createState() => _TabBarLibraryState();
}

class _TabBarLibraryState extends State<TabBarLibrary> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        controller: widget._tabController,
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: GridView.builder(
                itemCount: profileController.user['PostUrl'].length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 150,
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 5),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          profileController.user['PostUrl'][index],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
          ),
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: GridView.builder(
              itemCount:
                  Get.find<ProfileController>().user['thumbnails'].length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 250,
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        Get.find<ProfileController>().user['thumbnails'][index],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
