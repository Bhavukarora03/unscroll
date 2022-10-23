
import 'package:get/get.dart';

import 'package:unscroll/controllers/upload_video_controller.dart';
import 'package:unscroll/controllers/video_controller.dart';

import '../auth_controller.dart';

class GetBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => UploadVideoController());
    Get.lazyPut(() => VideoController());
  }
}