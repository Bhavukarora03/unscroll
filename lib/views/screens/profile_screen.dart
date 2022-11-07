import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.user.isEmpty) {
          return  Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
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
            child: Column(
              children: [
                height20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        UserProfileImage.medium(
                            imageUrl: profileController.user['profilePic'],
                            radius: 40),
                        height10,
                        Text(
                          profileController.user['username'],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          profileController.user['likes'],
                        ),
                        const Text('Posts')
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => FollowersCount());
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
                  ],
                ),
                height20,
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   
                  ),
                  label: Text(
                    widget.uid == authController.user.uid
                        ? 'Sign Out'
                        : profileController.user['isFollowing']
                            ? 'Unfollow'
                            : 'Follow',
                  ),
                  icon: widget.uid == authController.user.uid
                      ? const Icon(Icons.logout_sharp)
                      : const Icon(Icons.person_add),
                  onPressed: () {
                    if (widget.uid == authController.user.uid) {
                      authController.signOut();
                    } else {
                      profileController.followerUser();
                    }
                  },
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
          GridView.builder(
              itemCount: Get.find<ProfileController>().user['PostUrl'].length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 180,
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        Get.find<ProfileController>().user['PostUrl'][index],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
          GridView.builder(
            itemCount: Get.find<ProfileController>().user['thumbnails'].length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 250,
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
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
        ],
      ),
    );
  }
}
