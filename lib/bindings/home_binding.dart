import 'package:belarasa_mobile/controllers/home_controller.dart';
import 'package:belarasa_mobile/data/providers/auth_provider.dart';
import 'package:belarasa_mobile/data/providers/locale_provider.dart';
import 'package:belarasa_mobile/data/providers/masses_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(MassesProvider(), AuthProvider(), LocaleProvider(GetStorage())));
  }
}
