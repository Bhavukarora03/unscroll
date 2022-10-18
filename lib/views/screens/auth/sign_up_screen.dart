
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
        //nice
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
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        // Text("Unscroll",
                        //     style: Theme.of(context).textTheme.headline1),
                        // const Spacer(),
                        Stack(children: [
                          UserProfileImage(),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 15,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                              ))
                        ]),
                      ]),
                    ),
                    height50,
                    TextInputField(
                        controller: _nameController,
                        labelText: "name",
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.name),
                    height20,
                    TextInputField(
                        controller: _emailController,
                        labelText: "mail",
                        prefixIcon: Icons.mail,
                        keyboardType: TextInputType.emailAddress),
                    height20,
                    TextInputField(
                        controller: _passwordController,
                        labelText: "password",
                        prefixIcon: Icons.key,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword),
                    height40,
                    ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Continue",
                        )),
                    height20,
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Get.back();
                            HapticFeedback.heavyImpact();
                          },
                          child: const Text("Login in"))
                    ])
                  ],
                )),
          ),
        ));
  }
}
