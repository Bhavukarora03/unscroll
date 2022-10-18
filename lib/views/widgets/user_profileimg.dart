import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
      "https://i.kinja-img.com/gawker-media/image/upload/t_original/ijsi5fzb1nbkbhxa2gc1.png",
      imageBuilder: (context, imageProvider) =>
          CircleAvatar(
            backgroundImage: imageProvider,
            radius: 50,
          ),
      placeholder: (context, url) =>
      const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
      const Icon(Icons.error),
    );
  }
}
