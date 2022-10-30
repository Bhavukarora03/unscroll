import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:unscroll/models/users.dart';

import '../constants.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _searchUsers = Rx<List<User>>([]);
  List<User> get searchUsers => _searchUsers.value;

  searchProfiles(String typedUsers) async {
    _searchUsers.bindStream(firebaseFirestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: typedUsers)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<User> temp = [];
      for (var doc in querySnapshot.docs) {
        temp.add(User.fromSnap(doc));
      }
      return temp;
    }));
  }

  removeSearchUsers(String removedUsers) {
    _searchUsers.bindStream(firebaseFirestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: removedUsers)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<User> temp = [];
      for (var doc in querySnapshot.docs) {
        temp.remove(User.fromSnap(doc));
      }
      return temp;
    }));
  }
}
