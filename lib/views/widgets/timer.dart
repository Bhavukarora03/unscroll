import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerApp extends StatefulWidget {
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  late SharedPreferences prefs;
  late DateTime target;
  String timeLeft = "";
  bool running = true;

  @override
  void initState() {
    super.initState();
    getTimer();
  }

  @override
  void dispose() {
    prefs.setInt('target', target.millisecondsSinceEpoch);
    running = false;
    super.dispose();
  }

  void getTimer() async {
    prefs = await SharedPreferences.getInstance();
    target = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('target')!);
    if (target.isBefore(DateTime.now())) {
      target = DateTime.now().add(const Duration(minutes: 5));
    }
    executeTimer();
  }

  void executeTimer() async {
    while (running) {
      setState(() {
        timeLeft = DateTime.now().isAfter(target)
            ? '5 min expired. Restart app to reset.'
            : target.difference(DateTime.now()).toString();
      });
      await Future.delayed(const Duration(seconds: 1), () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          timeLeft,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
