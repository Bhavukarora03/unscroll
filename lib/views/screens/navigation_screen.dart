import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import "package:unscroll/views/pages/pages.dart";

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final ValueNotifier<String> title = ValueNotifier<String>('Home');
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final pages =  [
    HomePage(),
    SearchPage(),
    UploadPage(),
    MessagePage(),
    ProfilePage(),
  ];

  final titles = [
    "Home",
    "Search",
    "Upload",
    "Messages",
    "Profile",
  ];

  void _onNavItemsSelected(i) {

    title.value = titles[i];
    _currentIndex.value = i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      appBar: AppBar(

        title: ValueListenableBuilder(
          valueListenable: title,
          builder: (BuildContext context, String value, _) {
            return Text(value);
          },
        ),
      ),
      body: SafeArea(

        child: Scaffold(
          resizeToAvoidBottomInset: false,
         body: ValueListenableBuilder(
            valueListenable: _currentIndex,
            builder: (BuildContext context, int value, _) {
              return pages[value];
            },
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return SalomonBottomBar(
      currentIndex: _currentIndex.value,
      onTap: (i) => setState(() => _onNavItemsSelected(i)),
      items: [
        /// Home
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
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
          selectedColor: Colors.pink,
        ),

        /// Messages
        SalomonBottomBarItem(
          icon: const Icon(Icons.message_outlined),
          title: const Text("Message"),
          selectedColor: Colors.orange,
        ),

        /// Profile
        SalomonBottomBarItem(
          icon: const Icon(Icons.person),
          title: const Text("Profile"),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }
}
