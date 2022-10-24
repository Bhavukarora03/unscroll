import 'package:flutter/material.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person_add),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            height20,
            Align(
                alignment: Alignment.center,
                child: UserProfileImage.medium(
                    imageUrl: 'https://picsum.photos/200', radius: 50)),
            height40,
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('0'),
                      Text('Posts'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('0'),
                      Text('Followers'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('0'),
                      Text('Following'),
                    ],
                  ),
                ),
              ],
            ),
            height40,
            Divider(
              thickness: 1,
            indent: 20,
            endIndent: 20,

            )

          ],
        ),
      ),
    );
  }
}
