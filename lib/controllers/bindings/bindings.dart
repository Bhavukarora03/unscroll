
import 'package:get/get.dart';
import 'package:unscroll/controllers/auth_controller.dart';

class GetBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}