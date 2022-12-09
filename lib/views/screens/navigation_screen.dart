import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
            style: TextStyle(color: Colors.white),
          ),
          content: const Text("Time is up"),
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
          "https://images.unsplash.com/photo-1638864616275-9f0b291a2eb6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1064&q=80"
            ),
            fit: BoxFit.cover,
          ),
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

          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Text(
                "Your Daily Doom Scroll limit is 30 minutes",
                style: TextStyle(
                  color: authController.isLightTheme.value ? Colors.white : Colors.white,

                  fontSize: 12,
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
            fillColor: Colors.red,
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
              _checkThirtyMins();
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
