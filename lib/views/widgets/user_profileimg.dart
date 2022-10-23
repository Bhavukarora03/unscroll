import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  final String imageUrl;
  const UserProfileImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
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
