import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/screens/auth/sign_up_screen.dart';
import 'package:unscroll/views/screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

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
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),

        //nice
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: OnBoardingSlider(
            indicatorAbove: false,
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
            background: const [Text(""), SizedBox.shrink()],
            totalPage: 2,
            speed: 1.8,
            pageBodies: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/walking-girl.png',
                    height: size.height * 0.3,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50),
                    child: RichText(
                      text: TextSpan(
                        text: 'Welcome \nto\n',
                        style: TextStyle(
                          color: authController.isLightTheme.value
                              ? Colors.black87
                              : Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                        children: [
                          TextSpan(
                            text: 'Unscroll..\n',
                            style: GoogleFonts.cedarvilleCursive(
                                color: Colors.blueAccent,
                                fontSize: 50,
                                height: 1.5,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "By continuing, you agree to our Terms of Service and ",
                  style: TextStyle(
                      color: authController.isLightTheme.value
                          ? Colors.black87
                          : Colors.white),
                  children: [
                    TextSpan(
                        text: 'Privacy Policy. ',
                        style: const TextStyle(color: Colors.blueAccent),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final Uri _policyUrl = Uri.parse(
                                'https://www.privacypolicygenerator.info/live.php?token=IlpPFFeTuVICmMdJSxXYqFYbv2fzW2QE');
                            if (!await launchUrl(_policyUrl)) {
                              throw 'Could not launch $_policyUrl';
                            }
                          }),
                    TextSpan(text: 'and '),
                    TextSpan(
                        text: 'terms and conditions',
                        style: const TextStyle(color: Colors.blueAccent),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final Uri _policyUrl = Uri.parse(
                                'https://www.termsandconditionsgenerator.com/live.php?token=MZk1iVmk0JX0C8IaGQIFQYgTEyT5YkmU');
                            if (!await launchUrl(_policyUrl)) {
                              throw 'Could not launch $_policyUrl';
                            }
                          }),


                  ])),
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
