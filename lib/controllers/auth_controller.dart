import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/models/users.dart' as model;
import 'package:unscroll/views/screens/prank_screen.dart';

import 'package:unscroll/views/screens/screens.dart';

enum AuthState { login, register }

class AuthController extends GetxController with CacheManager {
  ///controller instance
  static AuthController instance = Get.find();

  ///firebase auth user
  late Rx<User?> _user;
  User get user => _user.value!;

  ///boolean to check login value
  final isLogged = false.obs;

  ///Image picker
  Rx<File> _pickedImage = Rx<File>(File(''));
  File get pickedImage => _pickedImage.value;

  ///Internet Connection Checker
  final Rx<bool> _hasInternet = Rx<bool>(false);
  bool get hasInternet => _hasInternet.value;

  ///Google Sign In
  final GoogleSignIn googleSignIn = GoogleSignIn();

  ///firebaseMessaging Token
  final Rx<String> _firebaseMesToken = ''.obs;
  String get firebaseMesToken => _firebaseMesToken.value;

  ///flutter Notification PLugin
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ///Check Internet Connection
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  late StreamSubscription internetSubscription;

  ///token logout
  void logOut() {
    isLogged.value = false;
    removeToken();
  }

  ///check token login value
  void login(String? token) async {
    isLogged.value = true;
    await saveToken(token);
  }

  ///check login status
  void checkLoginStatus() {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
    }
  }

  ///on controller init
  @override
  void onInit() {
    requestNotificationPermission();
    getNotificationToken();
    getToken();
    initLocalNotifications();
    checkInternetConnection();

    super.onInit();
  }

  @override
  void dispose() {
    internetSubscription.cancel();
    super.dispose();
  }

  ///Called after init
  @override
  void onReady() {
    super.onReady();
    locationController.determinePosition();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  ///Check if user is logged in
  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      Get.offAll(() => const NavigationScreen());
    }
  }

  ///Check hasInternet
  checkInternetConnection() {
    internetSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      _hasInternet.value = hasInternet;
      hasInternet
          ? null
          : ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(content: Text('No Internet Connection')));
    });
  }

  ///init flutter local Notifications
  initLocalNotifications() {
    var andriodInit = const AndroidInitializationSettings('ic_launcher');
    var iosInit = const DarwinInitializationSettings();
    var initSettings =
        InitializationSettings(android: andriodInit, iOS: iosInit);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (response) async {
      try {
        if (response.payload != null) {
        } else {}
      } catch (e) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text('No Internet Connection')));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title,
        htmlFormatContentTitle: true,
        summaryText: message.notification!.title,
        htmlFormatSummaryText: true,
      );

      AndroidNotificationDetails andriodNotificationDetails =
          AndroidNotificationDetails('test', 'test',
              importance: Importance.max,
              priority: Priority.high,
              styleInformation: bigTextStyleInformation,
              ticker: 'test',
              playSound: true);

      NotificationDetails notificationDetails = NotificationDetails(
          android: andriodNotificationDetails,
          iOS: const DarwinNotificationDetails());
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, notificationDetails,
          payload: message.data['body']);
    });
  }

  ///request notification permission
  void requestNotificationPermission() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
  }

  checkThirtyMin() async {
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'thirtyMinDone': false,
    });
  }

  checkIfThirtyMinDone() async {
    var docs = await firebaseFirestore
        .collection('users')
        .where('thirtyMinDone', isEqualTo: true)
        .get();
    if (docs.docs.isNotEmpty) {
      isLogged.value = false;
      removeToken();
      Get.offAll(() => PrankScreen());
    }
  }

  ///Get firebase messaging token
  void getNotificationToken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.getToken().then((value) {
      _firebaseMesToken.value = value!;
      uploadTokenToFireStore(value);
    });
  }

  void uploadTokenToFireStore(String token) async {
    await firebaseFirestore
        .collection('usertokens')
        .doc(firebaseAuth.currentUser?.uid)
        .set({
      'token': token,
    });
  }

  ///pickimage from ImageSource
  Future<Rx<File>> pickImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);

    _pickedImage = Rx<File>(File(pickedImage!.path));
    await ImageCropper()
        .cropImage(sourcePath: pickedImage.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          activeControlsWidgetColor: Colors.blueAccent,
          toolbarTitle: 'Crop your unscroll',
          toolbarColor: Colors.blueAccent.shade100,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ]);

    update();

    return _pickedImage;
  }

  ///Uploads the image to firebase storage and returns the url
  Future<String> _uploadImageToStorage(File image) async {
    Reference reference = firebaseStorage
        .ref()
        .child("userProfileImages")
        .child(firebaseAuth.currentUser!.email!);
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  ///confirmationEmail
  void confirmationEmail() async {
    await firebaseAuth.currentUser!.sendEmailVerification();
  }

  ///register users with email and password
  void registerUser(
      String email, String username, String password, File? image) async {
    try {
      if (email.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        String downloadURl = await _uploadImageToStorage(image);
        model.User user = model.User(
          username: username,
          email: email,
          profilePic: downloadURl,
          uid: userCredential.user!.uid,
          bio: "Hey there! I'm using Unscroll",
          thirtyMinDone: false,
        );
        await firebaseFirestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(user.toJson());

        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text('Welcome to DoomScroll')));
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text('Please fill all the fields')));
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  ///login users with email and password
  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text('Welcome to DoomScroll')));
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text('Please fill all the fields')));
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  ///Sign out User
  void signOut() async {
    await firebaseAuth.signOut();
    Get.offAll(() => const LoginScreen());
  }

  ///Sign in with Google
  loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final authResult = await firebaseAuth.signInWithCredential(credential);

      final User? user = authResult.user;
      model.User googleUser = model.User(
        username: user!.displayName!,
        email: user.email!,
        profilePic: user.photoURL!,
        uid: user.uid,
        bio: "Hey there! I'm using Unscroll",
        thirtyMinDone: false,
      );
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(googleUser.toJson());

      return;
    } catch (e) {
      rethrow;
    }
  }
}

///Mixin to cache userAuth data
mixin CacheManager {
  Future<bool> saveToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.token.toString(), token);
    return true;
  }

  String? getToken() {
    final box = GetStorage();
    return box.read(CacheManagerKey.token.toString());
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.token.toString());
  }

  countDownTimer() {}
}

enum CacheManagerKey { token }
