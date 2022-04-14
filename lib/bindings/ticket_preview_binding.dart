import 'package:belarasa_mobile/controllers/ticket_preview_controller.dart';
import 'package:get/get.dart';

class TicketPreviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TicketPreviewController>(TicketPreviewController());
  }
}
