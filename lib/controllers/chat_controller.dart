// import 'dart:convert';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
//
//
// String randomString() {
//   final random = Random.secure();
//   final values = List<int>.generate(16, (i) => random.nextInt(255));
//   return base64UrlEncode(values);
// }
// class ChatController extends GetxController {
//   final Rx<List<types.Message>> _messages = Rx<List<types.Message>>([]);
//   List<types.Message> get messages => _messages.value;
//
//
//   final types.User _user =  const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
//
//   types.User get user => _user;
//
//   void addMessage(types.Message message) {
//     _messages.value.insert(0, message);
//   }
//
//   void handleImageSelection() async {
//     final result = await ImagePicker().pickImage(
//       imageQuality: 70,
//       maxWidth: 1440,
//       source: ImageSource.gallery,
//     );
//
//     if (result != null) {
//       final bytes = await result.readAsBytes();
//       final image = await decodeImageFromList(bytes);
//
//       final message = types.ImageMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         height: image.height.toDouble(),
//         id: randomString(),
//         name: result.name,
//         size: bytes.length,
//         uri: result.path,
//         width: image.width.toDouble(),
//       );
//
//       addMessage(message);
//     }
//   }
//
//   void handleSendPressed(types.PartialText message) {
//     final textMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: randomString(),
//       text: message.text,
//     );
//     addMessage(textMessage);
//   }
// }
