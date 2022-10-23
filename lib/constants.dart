import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';

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

//firebase
var firebaseAuth = FirebaseAuth.instance;
var firebaseFirestore = FirebaseFirestore.instance;
var firebaseStorage = FirebaseStorage.instance;

//Controller
var authController = AuthController.instance;
