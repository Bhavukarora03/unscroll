import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:unscroll/constants.dart';
import 'package:unscroll/models/users.dart' as model;

import 'package:unscroll/views/screens/screens.dart';

enum AuthState { login, register }

class AuthController extends GetxController with CacheManager{
  static AuthController instance = Get.find();

  late Rx<User?> _user;

  final isLogged = false.obs;

  User get user => _user.value!;

  Rx<File> _pickedImage = Rx<File>(File(''));

  File get pickedImage => _pickedImage.value;

  final Rx<bool> _hasInternet = Rx<bool>(false);

  bool get hasInternet => _hasInternet.value;


  final GoogleSignIn googleSignIn = GoogleSignIn();


  void logOut() {
    isLogged.value = false;
    removeToken();
  }

  void login(String? token) async {
    isLogged.value = true;
    //Token is cached
    await saveToken(token);
  }

  void checkLoginStatus() {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
    }
  }

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {


      Get.offAll(() => const NavigationScreen());

    }
  }

  ///pickimage from ImageSource
  Future<Rx<File>> pickImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      Get.snackbar('success', "ez pz");
    }
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
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
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
            uid: userCredential.user!.uid);
        await firebaseFirestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar("success", "Successfully selected image");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  ///login users with email and password
  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        Get.snackbar("Success", "Logged in with mail and password");
      } else {
        Get.snackbar("Error", "Please fill all the fields");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
    Get.offAll(() => LoginScreen());
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
          uid: user.uid);
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(googleUser.toJson());
      // navigate to your wanted page
      return;
    } catch (e) {
      rethrow;
    }
  }
}

mixin CacheManager {
  Future<bool> saveToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TOKEN.toString(), token);
    return true;
  }

  String? getToken() {
    final box = GetStorage();
    return box.read(CacheManagerKey.TOKEN.toString());
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.TOKEN.toString());
  }
}

enum CacheManagerKey { TOKEN }