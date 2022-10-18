import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';

class AuthController extends GetxController {
  Future<String> _uploadImageToStorage(File image) async {
    Reference reference = firebaseStorage
        .ref()
        .child("userProfileImages/${DateTime.now().millisecondsSinceEpoch}")
        .child(firebaseAuth.currentUser!.uid);
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

       String downloadURl = await  _uploadImageToStorage(image);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
