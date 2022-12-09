import 'package:flutter/material.dart';

class ScaffoldMessenger extends StatelessWidget {
  const ScaffoldMessenger({Key? key, required this.snackBar, this.onPressed})
      : super(key: key);
  final String snackBar;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(snackBar),
      action: SnackBarAction(label: "Undo", onPressed: onPressed!),
    );
  }
}
