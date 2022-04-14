import 'package:belarasa_mobile/controllers/home_controller.dart';
import 'package:belarasa_mobile/data/providers/auth_provider.dart';
import 'package:belarasa_mobile/data/providers/masses_provider.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(MassesProvider(), AuthProvider()));
  }
}
