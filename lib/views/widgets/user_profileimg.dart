import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  const UserProfileImage(
      {Key? key, required this.imageUrl, required this.radius})
      : super(key: key);
  const UserProfileImage.medium(
      {Key? key, required this.imageUrl, this.radius = 50})
      : super(key: key);
  const UserProfileImage.small(
      {Key? key, required this.imageUrl, this.radius = 15})
      : super(key: key);
  const UserProfileImage.large(
      {Key? key, required this.imageUrl, this.radius = 80})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        radius: radius,
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
