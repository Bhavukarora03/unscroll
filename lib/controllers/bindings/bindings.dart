import 'package:get/get.dart';
import 'package:unscroll/controllers/comment_controller.dart';
import 'package:unscroll/controllers/profile_controller.dart';
import 'package:unscroll/controllers/search_controller.dart';

import 'package:unscroll/controllers/upload_video_controller.dart';
import 'package:unscroll/controllers/video_controller.dart';

import '../auth_controller.dart';

class GetBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => UploadVideoController());
    Get.lazyPut(() => VideoController());
    Get.lazyPut(() => CommentController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => SearchController());
  }
}
