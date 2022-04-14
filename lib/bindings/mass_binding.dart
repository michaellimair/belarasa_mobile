import 'package:belarasa_mobile/controllers/mass_controller.dart';
import 'package:belarasa_mobile/data/providers/auth_provider.dart';
import 'package:belarasa_mobile/data/providers/masses_provider.dart';
import 'package:get/get.dart';

class MassBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MassController>(MassController(MassesProvider(), AuthProvider()));
  }
}
