import 'package:get/get.dart';
import 'package:unscroll/controllers/comment_controller.dart';
import 'package:unscroll/controllers/location_controller.dart';
import 'package:unscroll/controllers/post_controller.dart';
import 'package:unscroll/controllers/profile_controller.dart';
import 'package:unscroll/controllers/search_controller.dart';
import 'package:unscroll/controllers/stories_controller.dart';
import 'package:unscroll/controllers/upload_posts_controller.dart';

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
    Get.lazyPut(() => LocationController());
    Get.lazyPut(() => PostController());
    Get.lazyPut(() => UploadPostsController());
    Get.lazyPut(() => StoriesController());
  }
}
