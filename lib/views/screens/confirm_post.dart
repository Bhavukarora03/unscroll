import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:unscroll/constants.dart';
import 'package:get/get.dart';
import 'package:unscroll/controllers/location_controller.dart';
import 'package:unscroll/controllers/upload_posts_controller.dart';

class ConfirmPost extends StatefulWidget {
  const ConfirmPost({Key? key, required this.postImage, required this.imgPath})
      : super(key: key);

  final File postImage;
  final String imgPath;

  @override
  State<ConfirmPost> createState() => _ConfirmPostState();
}

class _ConfirmPostState extends State<ConfirmPost> {
  final TextEditingController _captionController = TextEditingController();
  final location = Get.find<LocationController>();
  final TextEditingController _locationController = TextEditingController(
      // text:
      //     "${locationController.placeMark[0].street!}, ${locationController.placeMark[0].locality!}, ${locationController.placeMark[0].country!}",
      );

  final UploadPostsController _postController =
      Get.put(UploadPostsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,



      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Text('Your post', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                EasyLoading.show(
                  dismissOnTap: false,
                  status: 'Uploading...',
                  maskType: EasyLoadingMaskType.black,
                );
                KeyboardUnFocus(context).hideKeyboard();
                _postController.uploadPost(
                  _captionController.text,
                  widget.imgPath,
                  _locationController.text,
                );
              },
              child: const Text('Confirm upload'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: InteractiveViewer(
                              child: Image.file(widget.postImage)),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(widget.postImage),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        colorFilter: const ColorFilter.mode(
                            Colors.black54, BlendMode.darken),
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                width20,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 4,
                      controller: _captionController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add a caption...',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _locationController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Add a location...',
                prefixIcon: IconButton(
                    onPressed: () {
                      locationController.determinePosition();
                      _locationController.text =
                          "${location.placeMark[0].street!}, ${location.placeMark[0].locality!}, ${location.placeMark[0].country!}";
                    },
                    icon: const Icon(Icons.location_on)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
