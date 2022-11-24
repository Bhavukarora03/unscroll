import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:unscroll/constants.dart';

class PrankScreen extends StatefulWidget {
  PrankScreen({Key? key}) : super(key: key);

  @override
  State<PrankScreen> createState() => _PrankScreenState();
}

class _PrankScreenState extends State<PrankScreen> with WidgetsBindingObserver {
  bool active = true;
  final box = GetStorage();
  Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromHour(24),
    onEnded: () async {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'thirtyMinDone': false,
      });
    },
  );

  updateThirty() async {
    await functions.httpsCallable('updateThirty').call();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      active = true;
      _stopWatchTimer.onStartTimer();
    } else if (state == AppLifecycleState.inactive) {
      print("inactive");
      active = false;
      _stopWatchTimer.onStopTimer();
    } else if (state == AppLifecycleState.paused) {
      print("paused");
      active = false;
      _stopWatchTimer.onStopTimer();
    } else if (state == AppLifecycleState.detached) {
      print("detached");
      active = true;
      _stopWatchTimer.onStartTimer();
    }
  }

  Future<String> readValue() async {
    int value = box.read('timerValue');
    var valueData = StopWatchTimer.getDisplayTime(value);
    print(valueData);
    return valueData;
  }

  _checkthirtyMins() async {
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      if (value.data()!['thirtyMinDone'] == true) {
        if (active) {
          setState(() {
            _stopWatchTimer.onStartTimer();
          });
          box.write('timerValue', _stopWatchTimer.rawTime.value);
        }
      }
    });
  }

  @override
  void initState() {
    _checkthirtyMins();
    _stopWatchTimer.rawTime.listen(
        (value) => box.write('timerValue', _stopWatchTimer.rawTime.value));

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readValue(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          readValue();
                        },
                        child: Text("Read")),
                    SizedBox(
                      height: 20,
                    ),
                    // StreamBuilder<int>(
                    //   stream: _stopWatchTimer.rawTime,
                    //   initialData: _stopWatchTimer.rawTime.value,
                    //   builder: (context, snap) {
                    //     final value = snap.data!;
                    //     final displayTime = StopWatchTimer.getDisplayTime(value,
                    //         milliSecond: false);
                    //     return Text(
                    //       displayTime,
                    //       style: TextStyle(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );

          Widget timer() {
            final box = GetStorage();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    final displayTime = StopWatchTimer.getDisplayTime(value,
                        milliSecond: false);
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
        });
  }
}
