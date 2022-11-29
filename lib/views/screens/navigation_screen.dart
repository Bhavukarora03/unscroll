import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:unscroll/constants.dart';
import "package:unscroll/views/pages/pages.dart";
import 'package:unscroll/views/screens/prank_screen.dart';
import 'package:unscroll/views/screens/profile_screen.dart';

import '../widgets/timer.dart';




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
  final AndroidAlarmManager _alarmManager = AndroidAlarmManager();
  int alarmId = 1;

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



  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    super.dispose();
    AndroidAlarmManager.cancel(alarmId);
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      active = true;
    } else if (state == AppLifecycleState.inactive) {
      active = false;
    } else if (state == AppLifecycleState.paused) {
      active = false;
    } else if (state == AppLifecycleState.detached) {
      active = false;
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
              floating: false,
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
