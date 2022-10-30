import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:unscroll/constants.dart';
import "package:unscroll/views/pages/pages.dart";
import 'package:unscroll/views/pages/posts_page.dart';
import 'package:unscroll/views/screens/profile_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final ValueNotifier<String> title = ValueNotifier<String>('Home');
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final pages = [
   PostsPage(),
    HomePage(),
    SearchPage(),
    const UploadPage(),
    ProfileScreen(uid: authController.user.uid),
  ];




  void _onNavItemsSelected(i) {
    _currentIndex.value = i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),

      body: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ValueListenableBuilder(
          valueListenable: _currentIndex,
          builder: (BuildContext context, int value, _) {
            return pages[value];
          },
        ),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SalomonBottomBar(
        currentIndex: _currentIndex.value,
        onTap: (i) => setState(() => _onNavItemsSelected(i)),
        items: [

          SalomonBottomBarItem(
            icon: const Icon(Icons.home ),
            title: const Text("Home"),
            selectedColor: Colors.green,
          ),

          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.video_collection_outlined),
            title: const Text("Unscroll"),
            selectedColor: Colors.purple,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text("Search"),
            selectedColor: Colors.white70,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.add),
            title: const Text("add"),
            selectedColor: const Color(0xff94CBED),
          ),


          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
