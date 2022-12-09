import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/screens/auth/sign_up_screen.dart';



final _formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void onPressedLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    });
    if (_formKey.currentState!.validate()) {
      authController.loginUser(_emailController.text, _passwordController.text);
    }
  }
@override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        //nice
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: OnBoardingSlider(
            headerBackgroundColor: Colors.transparent,
            finishButtonText: 'Register',
            skipTextButton: const Text('Skip'),
            finishButtonColor: const Color(0xff7FC0C2),

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
              Image.asset('assets/images/landing.gif',
                  width: size.width, height: 400),
              const SizedBox.shrink()
            ],
            totalPage: 2,
            speed: 1.8,
            pageBodies: [
              Column(
                children:  <Widget>[
                  SizedBox(
                    height: 480,
                  ),
                  Text('Welcome to DoomScroll',
                      style: GoogleFonts.marckScript(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w400

                      ) ),
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
        prefixIcon: Icon(Icons.email),
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
              _obscureText ? Icons.visibility : Icons.visibility_off,
              // color: Colors.white,
            )),
        labelText: "Password",
        hintText: "Enter your password",
        prefixIcon: const Icon(Icons.lock),
      ),
    );
  }
}
