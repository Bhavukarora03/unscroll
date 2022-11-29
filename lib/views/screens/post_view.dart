import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:unscroll/views/widgets/user_profileimg.dart';
import 'package:get/get.dart';
import '../../controllers/post_controller.dart';

class PostView extends StatelessWidget {
  PostView(
      {Key? key,
      required this.postUrl,
      required this.uid,
      required this.username,
      required this.profileUrl})
      : super(key: key);

  final String postUrl;
  final String uid;
  final String username;
  final String profileUrl;

  final postController = Get.find<PostController>();
  Future<PaletteGenerator> _updatePaletteGenerator(
      ImageProvider imageProvider) async {
    var paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);

    return paletteGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _updatePaletteGenerator(CachedNetworkImageProvider(postUrl)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),
            body: Column(
              children: [
                ListTile(
                    title: Text(username),
                    leading: UserProfileImage(imageUrl: profileUrl, radius: 20)),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 30.0, bottom: 30.0, top: 10.0),
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(postUrl),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: snapshot.data!.dominantColor!.color,
                          spreadRadius: 5,
                          blurRadius: 50,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
