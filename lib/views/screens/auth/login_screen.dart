import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/screens/auth/sign_up_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void onPressedLogin() {
    EasyLoading.show(status: 'logging...');
    KeyboardUnFocus(context).hideKeyboard();
    if (_formKey.currentState!.validate()) {
      authController.loginUser(_emailController.text, _passwordController.text);
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
        ),

        //nice
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: OnBoardingSlider(
            headerBackgroundColor: Colors.transparent,
            finishButtonText: 'Register',
            skipTextButton: const Text('Skip'),
            finishButtonColor: Colors.blueAccent,
            
            onFinish: () {
              Get.to(() => SignUpScreen());
            },
            trailingFunction: () {
              onPressedLogin();
            },
            
            trailing: const Text(
              'Login',
            ),
            background: [
              Image.asset('assets/images/landing.png',
                  width: size.width, height: 400),
              const SizedBox.shrink()
            ],
            totalPage: 2,
            speed: 1.8,
            pageBodies: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 450,
                    ),
                    const Text('Welcome to DoomScroll!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                    height20,
                    Center(
                      child: Text(
                        "OUR BRAIN ACTUALLY LOOKS FOR BAD NEWS, HOPING TO CONTROL IT, BUT IT'S NOT POSSIBLE. WE MAY READ BAD NEWS BUT IT'S A MATTER OF TRYING NOT TO LET"
                                " IT AFFECT US. WE CAN'T STOP IT, BUT WE CAN TRY TO CONTROL IT. "
                            .toLowerCase(),style: const TextStyle(
                        fontSize: 15,
                      ),
                      ),
                    )
                  ],
                ),
              ),
              loginData(context)
            ],
          ),
        ));
  }

  Widget loginData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: AutofillGroup(
              child: Column(
                children: [
                  buildEmailTextFormField(),
                  height20,
                  buildPasswordTextFormField()
                ],
              ),
            ),
          ),
          height30,
          const Center(child: Text('Or')),
          height30,
          ElevatedButton.icon(
              onPressed: () => authController.loginWithGoogle(),
              icon: Image.asset(
                "assets/images/logo.png",
                height: 20,
              ),
              label: const Text("Continue with Google")),
          height50,
          const Center(child: Text("Don't have an account with us?"))
        ],
      ),
    );
  }

  /// Email Text Form Field
  TextFormField buildEmailTextFormField() {
    return TextFormField(
      controller: _emailController,
      enableInteractiveSelection: true,
      enableSuggestions: true,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      validator: EmailValidator(errorText: "Enter a valid email"),
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        prefixIcon: Icon(CupertinoIcons.mail),
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
    );
  }

  ///Password TextForm Field
  TextFormField buildPasswordTextFormField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      enableInteractiveSelection: true,
      enableSuggestions: true,
      validator: MultiValidator([
        RequiredValidator(errorText: "Enter a valid password"),
        MinLengthValidator(6,
            errorText: "Password must be at least 6 characters"),
        MaxLengthValidator(15,
            errorText: "Password must be at most 15 characters"),
      ]),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        suffixIcon: IconButton(
            onPressed: _toggle,
            icon: Icon(
              _obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
              // color: Colors.white,
            )),
        labelText: "Password",
        hintText: "Enter your password",
        prefixIcon: const Icon(CupertinoIcons.lock),
      ),
    );
  }
}
