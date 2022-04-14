import 'package:belarasa_mobile/controllers/login_controller.dart';
import 'package:belarasa_mobile/data/providers/login_provider.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() {
      return LoginController(LoginProvider());
    });
  }
}
