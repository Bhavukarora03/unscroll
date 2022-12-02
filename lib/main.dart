import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:unscroll/controllers/auth_controller.dart';
import 'package:unscroll/views/screens/splashScreen.dart';
import 'package:unscroll/views/widgets/timer.dart';
import 'controllers/bindings/bindings.dart';
import 'firebase_options.dart';


Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage? message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthController()));
  GetBindings().dependencies();

  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  await Purchases.setDebugLogsEnabled(true);

  runApp(const MyApp());
  const int helloAlarmID = 0;

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
        initialBinding: GetBindings(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            brightness: Brightness.dark,
            textTheme: GoogleFonts.aBeeZeeTextTheme(
              Theme.of(context).textTheme.copyWith(
                    bodyText1: const TextStyle(color: Colors.white),
                    bodyText2: const TextStyle(color: Colors.white),
                  ),
            ).copyWith(
              bodyText1: const TextStyle(color: Colors.white),
              bodyText2: const TextStyle(color: Colors.white),
            ),
            listTileTheme: const ListTileThemeData(
              textColor: Colors.white,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            )),
        // scaffoldBackgroundColor: ),
        home: const SplashScreen());
  }
}
