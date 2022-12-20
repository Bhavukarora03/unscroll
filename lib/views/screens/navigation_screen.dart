import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unscroll/constants.dart';
import "package:unscroll/views/pages/pages.dart";
import 'package:unscroll/views/screens/prank_screen.dart';
import 'package:unscroll/views/screens/profile_screen.dart';
import 'package:unscroll/views/widgets/sharedprefs.dart';

int duration = 1800;

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool active = true;

  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  late CountDownController _controller;

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
          ),
          content: const Text("Your 30 minutes of doomsday is up"),
          actions: [
            TextButton(
                onPressed: () {
                  Get.offAll(() => const PrankScreen());
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
    authController.checkIfThirtyMinDone();
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
    } else if (state == AppLifecycleState.detached) {
      TextPreferences.setTime(duration);
      _controller.pause();
    }
  }

  final pages = [
    const PostsPage(),
    HomePage(),
    SearchPage(),
    const UploadPage(),
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
              title: appBarTimer(),
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

  GestureDetector appBarTimer() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Flexible(
              child: Text(
                "Easy there, you have 30 minutes to doomsday",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            counterTimer(),
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
            fillColor: Colors.blueAccent,
            fillGradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.redAccent,
                Colors.blueAccent,
              ],
            ),
            ringColor: Colors.grey[300]!,
            isReverse: true,
            isReverseAnimation: true,
            onChange: (value) {
              duration = int.parse(value.toString());
            },
            textStyle: const TextStyle(
              fontSize: 12,
            ),
            controller: _controller,
            onComplete: () {
              _checkThirtyMins();
            },
          );
        } else {
          return const Text("Restart");
        }
      },
    );
  }

  Widget _bottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        height: 80,
        elevation: 0,
        selectedIndex: _currentIndex.value,
        onDestinationSelected: (i) => setState(() => _onNavItemsSelected(i)),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
            selectedIcon: Icon(Icons.home_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library),
            label: "Unscroll",
            selectedIcon: Icon(Icons.video_library_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: "Search",
            selectedIcon: Icon(Icons.person_search_rounded),
          ),
          NavigationDestination(
            icon: Icon(Icons.upload_rounded),
            label: "Upload",
            selectedIcon: Icon(Icons.upload_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: "Profile",
            selectedIcon: Icon(Icons.person_add_alt_1_outlined),
          ),
        ],
      ),
    );
  }
}
