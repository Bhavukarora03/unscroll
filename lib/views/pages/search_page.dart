import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unscroll/controllers/search_controller.dart';
import 'package:unscroll/models/users.dart';
import 'package:unscroll/views/screens/profile_screen.dart';
import 'package:unscroll/views/widgets/user_profileimg.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 100,
          title: TextField(
            decoration: const InputDecoration(
              hintText: 'Search',
              suffixIcon: Icon(Icons.search),
            ),
            onSubmitted: (value) {
              searchController.searchProfiles(value);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewInsets.top, left: 20, right: 20),
          child: Column(
            children: [
              searchController.searchUsers.isEmpty
                  ? const Align(
                  alignment: Alignment.bottomCenter, child: Text('No results'))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: searchController.searchUsers.length,
                        itemBuilder: (context, index) {
                          User user = searchController.searchUsers[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => ProfileScreen(uid: user.uid), transition: Transition.cupertinoDialog);
                            },
                            child: Card(
                              child: ListTile(
                                leading: UserProfileImage(
                                    imageUrl: user.profilePic, radius: 20),
                                title: Text(user.username),
                                subtitle: Text(user.email),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
