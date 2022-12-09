import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/themes.dart';
import 'package:unscroll/views/screens/splashScreen.dart';

import 'package:unscroll/views/screens/navigation_screen.dart';
import 'package:unscroll/views/widgets/sharedprefs.dart';
import 'controllers/bindings/bindings.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage? message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GetBindings().dependencies();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Purchases.setDebugLogsEnabled(true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _getThemeStatus() async {
    var _isLight = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('theme') ?? true;
    }).obs;
    authController.isLightTheme.value = await _isLight.value;
    Get.changeThemeMode(
        authController.isLightTheme.value ? ThemeMode.light : ThemeMode.dark);
  }

  MyApp() {
    _getThemeStatus();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
        initialBinding: GetBindings(),
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        theme: lightTheme,
        builder: EasyLoading.init(),
        // scaffoldBackgroundColor: ),
        home: const SplashScreen());
  }
}
