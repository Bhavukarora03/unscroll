import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/screens/auth/sign_up_screen.dart';
import 'package:unscroll/views/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwprdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //nice
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0, ),
                      child: Center(child: Image.asset("assets/icon/logo.png")),),

                    TextInputField(
                      autofillHints: AutofillHints.name,
                        controller: _emailController,
                        labelText: "mail",
                        prefixIcon: Icons.mail,
                        keyboardType: TextInputType.emailAddress),
                    height20,
                    TextInputField(
                      autofillHints: AutofillHints.password,
                        controller: _passwprdController,
                        labelText: "password",
                        prefixIcon: Icons.key,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword),
                    height40,
                    ElevatedButton(
                        onPressed: () => authController.loginUser(_emailController.text, _passwprdController.text),
                        child: const Text(
                          "Continue",
                        )),
                    height20,
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Don't have an account?"),
                      TextButton(

                          onPressed: () {

                            HapticFeedback.heavyImpact();
                            Get.to(()=> SignUpScreen(), transition: Transition.rightToLeft);
                          },
                          child: const Text("Sign up"))
                    ])
                  ],
                )),
          ),
        )
    );
  }
}
