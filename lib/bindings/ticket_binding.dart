import 'package:belarasa_mobile/controllers/ticket_controller.dart';
import 'package:belarasa_mobile/data/providers/tickets_provider.dart';
import 'package:get/get.dart';

class TicketBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TicketController>(TicketController(TicketsProvider()));
  }
}
