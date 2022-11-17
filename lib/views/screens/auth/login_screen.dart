import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
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
                      padding: const EdgeInsets.only(
                        top: 100.0,
                      ),
                      child: Center(child: Image.asset("assets/icon/logo.png")),
                    ),
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
                    height50,
                    ElevatedButton(
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          });
                          if (_formKey.currentState!.validate()) {
                            authController.loginUser(_emailController.text,
                                _passwordController.text);
                          }
                        },
                        child: const Text(
                          "Continue",
                        )),
                    height50,
                    const Align(alignment: Alignment.center, child: Text("or")),
                    height50,
                    ElevatedButton.icon(
                        onPressed: () => authController.loginWithGoogle(),
                        icon: Image.asset(
                          "assets/images/logo.png",
                          height: 20,
                        ),
                        label: const Text("Continue with Google")),
                    height50,
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            Get.to(() => SignUpScreen(),
                                transition: Transition.rightToLeft);
                          },
                          child: const Text("Sign up"))
                    ])
                  ],
                )),
          ),
        ));
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
        labelStyle: TextStyle(color: Colors.white),
        hintText: "Enter your email",
        prefixIcon: Icon(Icons.email, color: Colors.white),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
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
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon: IconButton(
            onPressed: _toggle,
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            )),
        labelText: "Password",
        hintText: "Enter your password",
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.lock, color: Colors.white),
      ),
    );
  }
}
