import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/controllers/search_controller.dart';
import 'package:unscroll/controllers/video_controller.dart';
import 'package:unscroll/views/screens/profile_screen.dart';
import 'package:unscroll/views/widgets/user_profileimg.dart';

import '../../controllers/post_controller.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final SearchController searchController = Get.put(SearchController());
  final TextEditingController searchUserController = TextEditingController();
  final postController = Get.find<PostController>();
  final ScrollController _scrollController = ScrollController();
  final videoController = Get.find<VideoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            toolbarHeight: 100,
            title: TextField(
              controller: searchUserController,
              decoration: const InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.white,
              ),
              onEditingComplete: () {
                searchController.searchProfiles(searchUserController.text);
              },
              onChanged: (value) {
                searchController.searchProfiles(value);
              },
              onSubmitted: (value) {
                searchController.searchProfiles(value);
                searchUserController.clear();
              },
            ),
          ),
          body: searchController.searchUsers.isEmpty
              ? CustomScrollView(controller: _scrollController, slivers: [
                  unscrolls(),
                  SliverToBoxAdapter(
                      child: Column(
                    children: [
                      Divider(
                        color: Colors.grey.shade700,
                        thickness: 1,
                        indent: 50,
                        endIndent: 50,
                      ),
                      height30,
                    ],
                  )),
                  posts(),
                ])
              : SizedBox(
                  height: 300,
                  child: searchUsers(),
                ));
    });
  }

  Widget searchUsers() {
    return ListView.builder(
      itemCount: searchController.searchUsers.length,
      itemBuilder: (context, index) {
        final data = searchController.searchUsers[index];
        return ListTile(
          onTap: () {
            Get.to(() => ProfileScreen(
                  uid: data.uid,
                ));
          },
          leading: UserProfileImage(
            imageUrl: data.profilePic,
            radius: 30,
          ),
          trailing: IconButton(
            onPressed: () {
              searchController.removeSearchUsers(data.uid);
            },
            icon: const Icon(Icons.close),
          ),
          title: Text(
            data.username,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget unscrolls() {
    return SliverList(
        delegate: SliverChildListDelegate([
      SizedBox(
        height: 300,
        child: postController.postsLists.isEmpty
            ? ShimmerEffect(const SizedBox()).shimmer
            : GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: postController.postsLists.length,
                itemBuilder: (context, index) {
                  final data = postController.postsLists[index];
                  return Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(data.postURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 200,
                ),
              ),
      ),
    ]));
  }

  Widget posts() {
    return SliverList(
        delegate: SliverChildListDelegate([
      SizedBox(
        height: 280,
        child: videoController.videoList.isEmpty
            ? ShimmerEffect(const SizedBox()).shimmer
            : GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videoController.videoList.length,
                itemBuilder: (context, index) {
                  final data = videoController.videoList[index];
                  return Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(data.thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 200,
                ),
              ),
      ),
    ]));
  }
}
