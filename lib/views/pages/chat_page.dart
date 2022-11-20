// import 'dart:convert';
// import 'dart:io';
//
// import 'package:bubble/bubble.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../controllers/chat_controller.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:http/http.dart' as http;
//
// final GlobalKey<ChatState> _chatKey = GlobalKey();
// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   final List<types.Message> _messages = [];
//   final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
//   int _page = 0;
//   @override
//   void initState() {
//     //_handleEndReached();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(
//       title: ListTile(
//         leading: CircleAvatar(
//           backgroundImage: NetworkImage(
//             'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_12 80.png',
//           ),
//         ),
//         title: Text('Bhavuk', style: TextStyle(color: Colors.white),),
//         subtitle: Text('Online',style: TextStyle(color: Colors.greenAccent),),
//       ),
//     ),
//     body: Chat(
//       key: _chatKey,
//       messages: _messages,
//       onAttachmentPressed: _handleAttachmentPressed,
//       onMessageTap: _handleMessageTap,
//       onPreviewDataFetched: _handlePreviewDataFetched,
//       onSendPressed: _handleSendPressed,
//       user: _user,
//       bubbleBuilder: _bubbleBuilder,
//       scrollToUnreadOptions: const ScrollToUnreadOptions(
//       lastReadMessageId: 'lastReadMessageId',
//       scrollOnOpen: true,
//     ),
//     ),
//   );
//
//   void _addMessage(types.Message message) {
//     setState(() {
//       _messages.insert(0, message);
//     });
//   }
//   Future<void> _handleEndReached() async {
//     final uri = Uri.parse(
//       'https://api.instantwebtools.net/v1/passenger?page=$_page&size=20',
//     );
//     final response = await http.get(uri);
//     final json = jsonDecode(response.body) as Map<String, dynamic>;
//     final data = json['data'] as List<dynamic>;
//     final messages = data
//         .map(
//           (e) => types.TextMessage(
//         author: _user,
//         id: e['_id'] as String,
//         text: e['name'] as String,
//       ),
//     )
//         .toList();
//     setState(() {
//       _messages.addAll(messages);
//       _page = _page + 1;
//     });
//   }
//
//   void _handleAttachmentPressed() {
//     showCupertinoModalBottomSheet(
//       topRadius: const Radius.circular(20),
//       barrierColor: Colors.black.withOpacity(0.5),
//       context: context,
//       builder: (BuildContext context) => Material(
//         child: Column(
//
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera),
//               onTap: () {
//                 Navigator.pop(context);
//                 _handleImageSelection();
//               },
//               title: Text('Photo', style: TextStyle(color: Colors.white),),
//             ),
//             ListTile(
//               leading: const Icon(Icons.file_copy),
//               onTap: () {
//                 Navigator.pop(context);
//                 _handleFileSelection();
//               },
//              title: Text('File', style: TextStyle(color: Colors.white),),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _handleFileSelection() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.any,
//     );
//
//     if (result != null && result.files.single.path != null) {
//       final message = types.FileMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         id: randomString(),
//         name: result.files.single.name,
//         size: result.files.single.size,
//         uri: result.files.single.path!,
//       );
//
//       _addMessage(message);
//     }
//   }
//
//   void _handleImageSelection() async {
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
//       _addMessage(message);
//     }
//   }
//
//   void _handleMessageTap(BuildContext _, types.Message message) async {
//     if (message is types.FileMessage) {
//       var localPath = message.uri;
//
//       if (message.uri.startsWith('http')) {
//         try {
//           final index =
//           _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//           (_messages[index] as types.FileMessage).copyWith(
//             isLoading: true,
//           );
//
//           setState(() {
//             _messages[index] = updatedMessage;
//           });
//
//           final client = http.Client();
//           final request = await client.get(Uri.parse(message.uri));
//           final bytes = request.bodyBytes;
//           final documentsDir = (await getApplicationDocumentsDirectory()).path;
//           localPath = '$documentsDir/${message.name}';
//
//           if (!File(localPath).existsSync()) {
//             final file = File(localPath);
//             await file.writeAsBytes(bytes);
//           }
//         } finally {
//           final index =
//           _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//           (_messages[index] as types.FileMessage).copyWith(
//             isLoading: null,
//           );
//
//           setState(() {
//             _messages[index] = updatedMessage;
//           });
//         }
//       }
//
//       await OpenFilex.open(localPath);
//     }
//   }
//
//   void _handlePreviewDataFetched(
//       types.TextMessage message,
//       types.PreviewData previewData,
//       ) {
//     final index = _messages.indexWhere((element) => element.id == message.id);
//     final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
//       previewData: previewData,
//     );
//
//     setState(() {
//       _messages[index] = updatedMessage;
//     });
//   }
//
//   void _handleSendPressed(types.PartialText message) {
//     final textMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: randomString(),
//       text: message.text,
//     );
//
//     _addMessage(textMessage);
//   }
//
//   Widget _bubbleBuilder(
//       Widget child, {
//         required message,
//         required nextMessageInGroup,
//       }) =>
//       Bubble(
//         child: child,
//         color: _user.id != message.author.id ||
//             message.type == types.MessageType.image
//             ? const Color(0xfff5f5f7)
//             : const Color(0xff6f61e8),
//         margin: nextMessageInGroup
//             ? const BubbleEdges.symmetric(horizontal: 6)
//             : null,
//         nip: nextMessageInGroup
//             ? BubbleNip.no
//             : _user.id != message.author.id
//             ? BubbleNip.leftBottom
//             : BubbleNip.rightBottom,
//       );
// }