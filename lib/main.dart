import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unscroll/views/screens/splashScreen.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialBinding: GetBindings(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            textTheme: GoogleFonts.aBeeZeeTextTheme(

              Theme.of(context).textTheme.copyWith(
                    bodyText1: const TextStyle(color: Colors.white),
                    bodyText2: const TextStyle(color: Colors.white),
                  ),


            ).copyWith(
              bodyText1: const TextStyle(color: Colors.white),
              bodyText2: const TextStyle(color: Colors.white),


            ),
            listTileTheme: ListTileThemeData(
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
