import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:unscroll/constants.dart';

import '../widgets/sharedprefs.dart';
import 'navigation_screen.dart';

class PrankScreen extends StatefulWidget {
  const PrankScreen({Key? key}) : super(key: key);

  @override
  State<PrankScreen> createState() => _PrankScreenState();
}

class _PrankScreenState extends State<PrankScreen> {
  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prank'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {


              },
              child: const Text('Start Prank'),
            ),

            ElevatedButton(
              onPressed: ()async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
             final val =  prefs.setInt('text', 50);
              print(val);
              Get.offAll(()=> const NavigationScreen());

              },

              child: const Text('Start Prank'),
            ),
          ],
        ),
      ),
    );
  }
}
