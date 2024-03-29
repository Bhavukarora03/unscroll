import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import 'controllers/auth_controller.dart';
import 'controllers/comment_controller.dart';
import 'controllers/location_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/stories_controller.dart';
import 'controllers/video_controller.dart';

//colors
const backgroundColor = Colors.black;
const buttonColor = Color(0xFFE5E5E5);
const borderColor = Color(0xFFE5E5E5);

//Sizedbox
const height10 = SizedBox(height: 10);
const height20 = SizedBox(height: 20);
const height30 = SizedBox(height: 30);
const height40 = SizedBox(height: 40);
const height50 = SizedBox(height: 50);
const height60 = SizedBox(height: 60);
const height70 = SizedBox(height: 70);
const height80 = SizedBox(height: 80);
const height90 = SizedBox(height: 90);
const height100 = SizedBox(height: 100);

//Sizedbox width
const width10 = SizedBox(width: 10);
const width20 = SizedBox(width: 20);
const width30 = SizedBox(width: 30);
const width40 = SizedBox(width: 40);
const width50 = SizedBox(width: 50);
const width60 = SizedBox(width: 60);
const width70 = SizedBox(width: 70);
const width80 = SizedBox(width: 80);
const width90 = SizedBox(width: 90);
const width100 = SizedBox(width: 100);

//firebase
var firebaseAuth = FirebaseAuth.instance;
var firebaseFirestore = FirebaseFirestore.instance;
var firebaseStorage = FirebaseStorage.instance;
var functions = FirebaseFunctions.instance;

//Controller
var authController = AuthController.instance;
var locationController = LocationController.instance;
var profileController = ProfileController.instance;
var videoController = VideoController.instance;
var storyController = StoriesController.instance;
var commentController = CommentController.instance;


const kSpinKit = SpinKitSpinningLines(
  color: Colors.blueAccent,
  size: 50.0,
);


const entitlementID = "premium";
const revenueAppKey = "goog_WyftrZXbtjpamOLzcBGOFjJvxQT";


extension ShimmerEffect on Widget {
  Widget get shimmer {
    return Shimmer.fromColors(
        baseColor: Colors.grey[850]!,
        highlightColor: Colors.grey[800]!,
        child: Container(
            decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
                child: this));

  }
}

extension KeyboardUnFocus on BuildContext {
  void hideKeyboard() {
    return WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScopeNode currentFocus = FocusScope.of(this);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    });
  }
}
