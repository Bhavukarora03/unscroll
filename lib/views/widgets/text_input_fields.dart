import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final IconData prefixIcon;
  final bool obscureText;
  final String autofillHints;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  const TextInputField(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.prefixIcon,
      this.obscureText = false,
      this.keyboardType,
      this.textInputAction = TextInputAction.next, required this.autofillHints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: TextField(
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        autofillHints: [autofillHints],
        decoration: (InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70, width: 2.0),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          prefixIcon: Icon(prefixIcon, color: Colors.white70),
          label: Text(labelText!),
          labelStyle: const TextStyle(color: Colors.white70),
        )),
      ),
    );
  }
}
