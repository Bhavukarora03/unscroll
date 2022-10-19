import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/bindings/bindings.dart';
import 'firebase_options.dart';
import 'views/screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put(() => AuthController());
  });
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
            textTheme: const TextTheme(
              headline1: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w600,
              ),
            ).apply(fontFamily: 'GTWalsheim'),
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
        home: LoginScreen());
  }
}
