import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class ModelBottomSheetForCamera extends StatelessWidget {
  final String titleText;
  final VoidCallback onPressedCamera;
  final VoidCallback onPressedGallery;
  final IconData icon;
  final Color iconColor;
  final double topRadius;
  final double bottomRadius;
  const ModelBottomSheetForCamera({
    Key? key,
    required this.titleText,
    required this.onPressedCamera,
    required this.onPressedGallery,
    required this.icon,
    required this.iconColor,
    required this.topRadius,
    required this.bottomRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(topRadius),
              bottom: Radius.circular(bottomRadius),
            ),
          ),
        ),
        onPressed: () {
          showCupertinoModalBottomSheet(
              topRadius: const Radius.circular(20),
              barrierColor: Colors.black.withOpacity(0.5),
              context: context,
              builder: (context) => Material(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.minimize,
                          size: 30,
                        ),
                        height20,
                        ListTile(
                            leading: const Icon(CupertinoIcons.camera),
                            title: const Text("Camera"),
                            onTap: () {
                              onPressedCamera();
                              Navigator.pop(context);
                            }),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                        ListTile(
                          leading: const Icon(CupertinoIcons.photo),
                          title: const Text("Gallery"),
                          onTap: () {
                            onPressedGallery();
                            Navigator.pop(context);
                          },
                        ),
                        height60,
                      ],
                    ),
                  ));
        },
        icon: Icon(icon),
        label: Text(titleText));
  }
}
