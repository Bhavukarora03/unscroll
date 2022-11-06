import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
  const UserProfileImage.none(
      {Key? key, required this.imageUrl, this.radius = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        radius: radius,
      ),
      placeholder: (context, url) => Shimmer.fromColors(
          child: CircleAvatar(
            radius: radius,
          ),
          baseColor: Colors.black,
          highlightColor: Colors.transparent),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

class UserPostsImages extends StatelessWidget {
  final String imageUrl;

  const UserPostsImages({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.black38,
          highlightColor: Colors.white,
          child: Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
          )),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
