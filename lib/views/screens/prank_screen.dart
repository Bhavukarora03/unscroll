import 'dart:async';
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

      active = false;
      _stopWatchTimer.onStopTimer();
    } else if (state == AppLifecycleState.paused) {

      active = false;
      _stopWatchTimer.onStopTimer();
    } else if (state == AppLifecycleState.detached) {

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
                    //timer(snapshot),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget timer(AsyncSnapshot snapshot) {
    final data = snapshot.data;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// Display stop watch time
        StreamBuilder<int>(
          stream: data,
          initialData: 0,
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
                    ElevatedButton(
                        onPressed: () {

                        },
                        child: const Text("Ok"))
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
