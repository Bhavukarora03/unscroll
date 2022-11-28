import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:unscroll/constants.dart';
import "package:unscroll/views/pages/pages.dart";
import 'package:unscroll/views/screens/prank_screen.dart';
import 'package:unscroll/views/screens/profile_screen.dart';

int timerValue = 0;

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
  late final AsyncSnapshot snap;

  ///StopWatch Timer
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(30),

    onStopped: () {
      final box = GetStorage();
      box.write('TimerValue', timerValue);
      print("Timer Stopped at $timerValue");
    },
    onEnded: () async {
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
    },
  );

  Future<int> readTimer() async {
    final box = GetStorage();
    int value = await box.read('TimerValue');

    return value;
  }

  _checkThirtyMins() async {
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      if (value.data()!['thirtyMinDone'] == false) {
        if (active) {
          setState(() {
            _stopWatchTimer.onStartTimer();
          });
        }
      } else {
        Get.offAll(() => PrankScreen());
      }
    });
  }

  @override
  void initState() {
    // setState(() {
    //   _stopWatchTimer.minuteTime.listen((event) {
    //     timerValue = event;
    //   });
    // });
    //
    // _checkThirtyMins();
    super.initState();
   // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

    await _stopWatchTimer.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      active = true;
      _stopWatchTimer.onStartTimer();
    } else if (state == AppLifecycleState.inactive) {
      active = false;
      _stopWatchTimer.onStopTimer();
    } else if (state == AppLifecycleState.paused) {
      active = false;
      _stopWatchTimer.onStopTimer();
    } else if (state == AppLifecycleState.detached) {
      active = false;
      _stopWatchTimer.onStopTimer();
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
              title: Row(
                children: [
                  FutureBuilder(
                      future: readTimer(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: [
                              timer(snapshot),
                              Text(
                                "Time Left: ${snapshot.data!}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          );
                        } else {
                          return const Text("Loading");
                        }
                      }),
                ],
              ),
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

  Widget timer(AsyncSnapshot snapshot) {
    final data = snapshot.data;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// Display stop watch time
        StreamBuilder<int>(
          stream: _stopWatchTimer.rawTime,
          initialData: data,
          builder: (context, snap) {
            final value = snap.data!;
            final displayTime =
                StopWatchTimer.getDisplayTime(value, milliSecond: false);
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_clock),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        displayTime,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
