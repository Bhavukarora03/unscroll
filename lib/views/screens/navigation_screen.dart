import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unscroll/constants.dart';
import "package:unscroll/views/pages/pages.dart";
import 'package:unscroll/views/screens/prank_screen.dart';

import 'package:unscroll/views/screens/profile_screen.dart';
import 'package:unscroll/views/widgets/sharedprefs.dart';

import '../widgets/timer.dart';

int duration = 1800;

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool active = true;

  final ValueNotifier<Widget> title = ValueNotifier<Widget>(const SizedBox());
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  late CountDownController _controller;

  late int newValue;
  _checkThirtyMins() async {
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update(
      {
        'thirtyMinDone': true,
      },
    );
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Time is up",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text("Time is up"),
          actions: [
            TextButton(
                onPressed: () {
                  authController.checkIfThirtyMinDone();
                },
                child: const Text("Ok"))
          ],
        );
      },
    );
  }

  Future<int> readTimer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt('text')!;

    return value;
  }

  @override
  initState() {
    authController.getNotificationToken();
    _controller = CountDownController();

    _controller.start();

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    super.dispose();
    TextPreferences.setTime(duration);

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _controller.resume();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      TextPreferences.setTime(duration);
      _controller.pause();

      print("inactive");
    } else if (state == AppLifecycleState.detached) {
      print("detached");
      TextPreferences.setTime(duration);
      _controller.pause();
    }
  }

  final pages = [
    const PostsPage(),
    HomePage(),
    SearchPage(),
    UploadPage(),
    ProfileScreen(
      uid: authController.user.uid,
    ),
  ];

  void _onNavItemsSelected(i) {
    _currentIndex.value = i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              toolbarHeight: 100,
              title: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(-20, 20),
                        color: Colors.red,
                        blurRadius: 15,
                        spreadRadius: -20,
                      ),
                      BoxShadow(
                        offset: Offset(-20, -20),
                        color: Colors.orange,
                        blurRadius: 15,
                        spreadRadius: -20,
                      ),
                      BoxShadow(
                        offset: Offset(20, -20),
                        color: Colors.blue,
                        blurRadius: 15,
                        spreadRadius: -20,
                      ),
                      BoxShadow(
                        offset: Offset(20, 20),
                        color: Colors.deepPurple,
                        blurRadius: 15,
                        spreadRadius: -20,
                      )
                    ],
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Text(
                          "Your Daily Doom Scroll limit is 30 minutes",
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      counterTimer(),
                    ],
                  ),
                ),
              ),
              floating: true,
              elevation: 0,
            ),
            SliverFillRemaining(
              child: ValueListenableBuilder(
                valueListenable: _currentIndex,
                builder: (context, value, child) {
                  return pages[value];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///counterTimer
  FutureBuilder<int> counterTimer() {
    return FutureBuilder(
      future: readTimer(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CircularCountDownTimer(
            width: 60,
            height: 60,
            textFormat: CountdownTextFormat.S,
            duration: snapshot.data as int,
            fillColor: Colors.teal,
            ringColor: Colors.white54,
            isReverse: true,
            isReverseAnimation: true,
            onChange: (value) {
              duration = int.parse(value.toString());
            },
            textStyle: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            controller: _controller,
            onComplete: () {
              showDialog(
                barrierDismissible: false,
                context: Get.context!,
                builder: (_) {
                  return AlertDialog(
                    title: const Text(
                      "Time is up",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text("Time is up"),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            Get.offAll(() => const PrankScreen());
                            //authController.checkIfThirtyMinDone();
                          },
                          child: const Text("Ok"))
                    ],
                  );
                },
              );
            },
          );
        } else {
          return const Text("Restart the app");
        }
      },
    );
  }

  Widget _bottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SalomonBottomBar(
        currentIndex: _currentIndex.value,
        onTap: (i) => setState(() => _onNavItemsSelected(i)),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.green,
          ),

          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.video_collection_outlined),
            title: const Text("Unscroll"),
            selectedColor: Colors.purple,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text("Search"),
            selectedColor: Colors.white70,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.add),
            title: const Text("add"),
            selectedColor: const Color(0xff94CBED),
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
