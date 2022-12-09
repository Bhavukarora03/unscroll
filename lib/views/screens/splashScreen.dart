import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:unscroll/views/screens/auth/login_screen.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authController = Get.put(AuthController());

  Future<void> initializeSettings() async {
    authController.checkLoginStatus();
   // authController.checkAgain30Mins();
    //Simulate other services for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AnimatedSplashScreen(
              animationDuration: const Duration(seconds: 5),
              backgroundColor: Colors.black,
              splash: const Text(
                'Unscroll',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              nextScreen: authController.isLogged.value
                  ? const NavigationScreen()
                  : const LoginScreen(),
              splashTransition: SplashTransition.slideTransition,
            );
          } else {
            if (snapshot.hasError) {
              return errorView(snapshot);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        });
  }

  Scaffold errorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
  }

  Scaffold waitingView() {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
          Text('Loading...'),
        ],
      ),
    ));
  }
}
