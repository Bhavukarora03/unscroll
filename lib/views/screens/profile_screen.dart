import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/profile_controller.dart';
import 'package:unscroll/views/screens/about_app.dart';
import 'package:unscroll/views/screens/post_view.dart';
import 'package:unscroll/views/widgets/sharedprefs.dart';
import 'package:unscroll/views/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final Uri _policyUrl = Uri.parse('https://www.privacypolicygenerator.info/live.php?token=IlpPFFeTuVICmMdJSxXYqFYbv2fzW2QE');

  Uri get policyUrl => _policyUrl;

  @override
  void initState() {
    profileController.updateUSerId(widget.uid);
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  _saveThemeStatus() async {
   TextPreferences.setTheme(authController.isLightTheme.value);
  }



  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  Future<void> _launchUrl() async {
    if (!await launchUrl(_policyUrl)) {
      throw 'Could not launch $_policyUrl';
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.user.isEmpty) {
          return const Scaffold(
            body: Center(child: kSpinKit),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.updateUSerId(widget.uid);
          },
          child: SafeArea(
            child: Scaffold(
              appBar: widget.uid == authController.user.uid ? null: AppBar(
                backgroundColor: Colors.transparent,
              ),
              resizeToAvoidBottomInset: true,
              body: Column(
                children: [
                  height10,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                       //   Get.to(() => FollowingsCount(uid: widget.uid));
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

                      widget.uid == authController.user.uid
                          ? IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 350,
                                        child: Column(
                                          children: [
                                            const Icon(Icons.minimize),
                                            ListTile(
                                              leading: const Icon(Icons.person),
                                              title: const Text('About / Support'),
                                              onTap: () async {
                                                Get.to(() => const AboutScreen());
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.nightlight_outlined),
                                              title: const Text("Switch theme"),
                                              trailing: ObxValue(
                                                    (data) => Switch(
                                                  inactiveThumbColor: Colors.blueAccent,
                                                  activeColor: Colors.amber,
                                                  value: authController.isLightTheme.value,
                                                  onChanged: (val) {
                                                    authController.isLightTheme.value = val;
                                                    Get.changeThemeMode(
                                                      authController.isLightTheme.value ? ThemeMode.light : ThemeMode.dark,
                                                    );
                                                    _saveThemeStatus();
                                                  },
                                                ),
                                                false.obs,
                                              ),

                                            ),
                                            ListTile(
                                              onTap: () {
                                                _launchUrl();

                                              },
                                              leading: const Icon(Icons.privacy_tip),
                                              title: const Text('Privacy and policy'),

                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.cached),
                                              title: const Text('Clear cache'),
                                              onTap: () async {
                                                Get.back();
                                                EasyLoading.show(status: 'Clearing cache');
                                                profileController.deleteCacheDir();
                                              },
                                            ),

                                            ListTile(
                                              leading: const Icon(Icons.logout),
                                              title: const Text("Logout"),
                                              onTap: () async{

                                             showDialog(context: context, builder: (context){
                                               return AlertDialog(
                                                 title: const Text('Logout'),
                                                 content: const Text('Are you sure you want to logout? We prefer you to stay with us, but if you want to leave, we will miss you. Also you can change your mind anytime.'),
                                                 actions: [
                                                   TextButton(onPressed: (){
                                                     Get.back();
                                                   }, child: const Text('Cancel')),
                                                   TextButton(onPressed: () async{
                                                     Get.back();
                                                     Get.back();

                                                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No, you are not leaving us. Learn to control your actions.')));
                                                   }, child: const Text('Logout & exit')),
                                                 ],
                                                );
                                              });



                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              icon: const Icon(Icons.more_vert))
                          : const SizedBox(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:  25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("${profileController.user['bio']}",
                        style:  const TextStyle(
                            color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ),
                  height20,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
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
                                  bio: profileController.user['bio'],
                                  uid: widget.uid,
                                  username:
                                      profileController.user['username'],
                                  profilePic:
                                      profileController.user['profilePic']));
                            } else {
                              profileController.followerUser();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  height20,
                  TabBar(
                    indicatorColor: Colors.blueAccent.shade100,
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
                  TabBarLibrary(
                    tabController: _tabController,
                    uid: widget.uid,
                  ),
                ],
              ),
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
    required this.uid,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;
  final String uid;

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
            child: profileController.user['PostUrl'].length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(CupertinoIcons.photo_fill_on_rectangle_fill,
                          size: 100),
                      height50,
                      Center(
                        child: Text(
                          'No Posts Yet',
                        ),
                      ),
                    ],
                  )
                : GridView.builder(
                    itemCount: profileController.user['PostUrl'].length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 150,
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {

                            Get.to(() => PostView(
                                  postUrl: profileController.user['PostUrl']
                                      [index],
                                  uid: widget.uid,
                                  username: profileController.user['username'],
                                  profileUrl:
                                      profileController.user['profilePic'],
                                ), transition: Transition.cupertino);



                        },
                        child: Container(
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
                        ),
                      );
                    }),
          ),
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: profileController.user['thumbnails'].length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.video_collection_outlined,
                          size: 100, ),
                      height50,
                      Center(
                        child: Text(
                          'No Unscrolls Yet',
                        ),
                      ),
                    ],
                  )
                : GridView.builder(
                    itemCount:
                        Get.find<ProfileController>().user['thumbnails'].length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                              Get.find<ProfileController>().user['thumbnails']
                                  [index],
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
