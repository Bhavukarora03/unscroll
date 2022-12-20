import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../constants.dart';
import '../../widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        profileAvatar(context),
                        const SizedBox(
                          height: 100,
                          width: 100,
                          child: Text("Make your Free DoomScroll Account",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ),
                  height50,
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            autofillHints: const [AutofillHints.name],
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              hintText: 'Enter your name',
                              prefixIcon: Icon(CupertinoIcons.person),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),


                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Name is required'),
                              MinLengthValidator(3,
                                  errorText:
                                      'Name must be at least 3 digits long'),
                              MaxLengthValidator(15,
                                  errorText:
                                      'Name must be at most 15 digits long')
                            ]),
                          ),
                          height20,
                          TextFormField(
                            controller: _emailController,
                            enableSuggestions: true,
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'email is required'),
                              EmailValidator(
                                  errorText: 'enter a valid email address'),
                            ]),
                            decoration: const InputDecoration(
                              labelText: "Email",
                              hintText: "Enter your email",
                              prefixIcon: Icon(CupertinoIcons.mail),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),

                            ),
                          ),
                          height20,
                          TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureText,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Enter a valid password"),
                              MinLengthValidator(6,
                                  errorText:
                                      "Password must be at least 6 characters"),
                              MaxLengthValidator(15,
                                  errorText:
                                      "Password must be at most 15 characters"),
                            ]),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),

                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureText
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash,
                                    // color: Colors.white,
                                  )),
                              labelText: "Password",
                              hintText: "Enter your password",
                              prefixIcon: const Icon(CupertinoIcons.lock),
                            ),
                          ),

                        ],
                      )),
                  height40,
                  ElevatedButton(
                      onPressed: () {
                        KeyboardUnFocus(context).hideKeyboard();

                        if (authController.pickedImage.path.isEmpty) {
                          EasyLoading.showError(
                              'Please select a profile picture');
                        } else {
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show(status: 'Registering...');
                            authController.registerUser(
                                _emailController.text,
                                _nameController.text,
                                _passwordController.text,
                                authController.pickedImage);
                          }
                        }
                      },
                      child: const Text(
                        "Continue",
                      )),
                  height20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Get.back();
                            HapticFeedback.heavyImpact();
                          },
                          child: const Text("Login in"))
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Stack profileAvatar(BuildContext context) {
    return Stack(
      children: [
        GetBuilder(
          init: authController,
          builder: (controller) => authController.pickedImage.path.isNotEmpty
              ? CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      FileImage(File(authController.pickedImage.path)),
                )
              : const UserProfileImage(
                  imageUrl:
                      "https://images.unsplash.com/photo-1634896941598-b6b500a502a7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=756&q=80",
                  radius: 60),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 15,
            child: IconButton(
              onPressed: () {
                showCupertinoModalBottomSheet(
                  barrierColor: Colors.black.withOpacity(0.5),
                  context: context,
                  builder: (_) => Material(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        height10,
                        const Icon(Icons.linear_scale),
                        height20,
                        ListTile(
                            leading: const Icon(Icons.camera),
                            title: const Text("Camera"),
                            onTap: () {
                              authController.pickImage(ImageSource.camera);
                              Get.back();
                            }),
                        ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text("Gallery"),
                            onTap: () {
                              authController.pickImage(ImageSource.gallery);

                              Get.back();
                            }),
                        height80
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit,
                size: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
