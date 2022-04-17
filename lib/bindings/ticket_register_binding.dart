import 'package:belarasa_mobile/controllers/ticket_preview_controller.dart';
import 'package:belarasa_mobile/controllers/ticket_register_controller.dart';
import 'package:get/get.dart';

class TicketRegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TicketRegisterController>(TicketRegisterController());
  }
}
