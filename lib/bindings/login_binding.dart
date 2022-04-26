import 'package:belarasa_mobile/controllers/login_controller.dart';
import 'package:belarasa_mobile/data/providers/locale_provider.dart';
import 'package:belarasa_mobile/data/providers/login_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() {
      return LoginController(LoginProvider(), LocaleProvider(GetStorage()));
    });
  }
}
