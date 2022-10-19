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

  _initialScreen(User? user ){
    if(user == null){
      Get.offAll(()=> LoginScreen());
    }else{
      Get.offAll(()=> const NavigationScreen());
    }

  }




  void  pickImage(ImageSource imageSource)async{
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
   Get.snackbar('success', "ez pz");
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }
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

  //register users
  void registerUser(
      String email, String name, String password, File? image) async {
    try {
      if (email.isNotEmpty &&
          name.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        String downloadURl = await _uploadImageToStorage(image);
        model.User user = model.User(
            name: name,
            email: email,
            profileImg: downloadURl,
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

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        Get.snackbar("Error", "Please fill all the fields");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
