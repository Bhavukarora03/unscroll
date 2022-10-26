import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../constants.dart';
import '../../widgets/widgets.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            const UserProfileImage.medium(
                              imageUrl:
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
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
                                        barrierColor:
                                            Colors.black.withOpacity(0.5),
                                        context: context,
                                        builder: (_) => Material(
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    height10,
                                                    const Icon(
                                                        Icons.linear_scale),
                                                    height20,
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.camera),
                                                      title:
                                                          const Text("Camera"),
                                                      onTap: () {
                                                          authController
                                                              .pickImage(
                                                                  ImageSource
                                                                      .camera);
                                                          Get.back();
                                                      }
                                                    ),
                                                    ListTile(
                                                        leading: const Icon(
                                                            Icons.image),
                                                        title: const Text(
                                                            "Gallery"),
                                                        onTap: () {
                                                          authController
                                                              .pickImage(
                                                                  ImageSource
                                                                      .gallery);

                                                          Get.back();
                                                        }),
                                                    height80
                                                  ]),
                                            ));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  height50,
                  TextInputField(
                      autofillHints: AutofillHints.name,
                      controller: _nameController,
                      labelText: "name",
                      prefixIcon: Icons.person,
                      keyboardType: TextInputType.name),
                  height20,
                  TextInputField(
                      autofillHints: AutofillHints.email,
                      controller: _emailController,
                      labelText: "email",
                      prefixIcon: Icons.mail,
                      keyboardType: TextInputType.emailAddress),
                  height20,
                  TextInputField(
                    autofillHints: AutofillHints.password,
                    controller: _passwordController,
                    labelText: "password",
                    prefixIcon: Icons.key,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ),
                  height40,
                  ElevatedButton(
                      onPressed: () {
                        authController.registerUser(
                            _emailController.text,
                            _nameController.text,
                            _passwordController.text,
                            authController.pickedImage);
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
}
