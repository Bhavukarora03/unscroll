import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'package:unscroll/constants.dart';
import 'package:unscroll/models/users.dart' as model;
import 'package:unscroll/views/screens/screens.dart';

enum AuthState { login, register }

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;

  User get user => _user.value!;

  Rx<File> _pickedImage = Rx<File>(File(''));

  File get pickedImage => _pickedImage.value;

  final Rx<bool> _hasInternet = Rx<bool>(false);

  bool get hasInternet => _hasInternet.value;

  RxString _imagePath = RxString('');
  String get imagePath => _imagePath.value;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser); //getting the current user
    _user.bindStream(firebaseAuth
        .authStateChanges()); //checking auth state if it changes it will update the user and it binds to the stream
    ever(_user, _initialScreen); // when user value changes call _initialScreen
  }

  ///persisting user state using ever
  _initialScreen(User? user) {
    if (user != null) {
      Get.offAll(() => const NavigationScreen());
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  ///pickimage from ImageSource
  Future<Rx<File>> pickImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      Get.snackbar('success', "ez pz");
    }
    _pickedImage = Rx<File>(File(pickedImage!.path));
    _imagePath = pickedImage.path.obs;

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



      File image = File(user!.photoURL!).absolute.existsSync() ? File(user.photoURL!) : File('assets/images/upload.png') ;
      String downloadURl = await _uploadImageToStorage(image);



      model.User googleUser = model.User(
          username: user.displayName!,
          email: user.email!,
          profilePic: downloadURl,
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
