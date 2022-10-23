import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/models/users.dart' as model;
import 'package:unscroll/views/screens/screens.dart';

class AuthController extends GetxController {

  static AuthController instance = Get.find();

  late Rx<User?> _user;

  User get user => _user.value!;

  late Rx<File?> _pickedImage;

  File? get pickedImage => _pickedImage.value;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser); //getting the current user
    _user.bindStream(firebaseAuth.authStateChanges()); //checking auth state if it changes it will update the user and it binds to the stream
    ever(_user, _initialScreen); // when user value changes call _initialScreen

  }


  ///persisting user state using ever
  _initialScreen(User? user ){
    if(user == null){
      Get.off(()=> LoginScreen());
    }else{
      Get.off(()=> const NavigationScreen());
    }

  }




  ///pickimage from ImageSource
  void  pickImage(ImageSource imageSource)async{
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
   Get.snackbar('success', "ez pz");
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
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
}
