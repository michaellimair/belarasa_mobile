import 'package:belarasa_mobile/bindings/home_binding.dart';
import 'package:belarasa_mobile/bindings/login_binding.dart';
import 'package:belarasa_mobile/bindings/ticket_binding.dart';
import 'package:belarasa_mobile/bindings/ticket_preview_binding.dart';
import 'package:belarasa_mobile/bindings/ticket_register_binding.dart';
import 'package:belarasa_mobile/modules/home/home_page.dart';
import 'package:belarasa_mobile/modules/login/login_page.dart';
import 'package:belarasa_mobile/modules/ticket/ticket_page.dart';
import 'package:belarasa_mobile/modules/ticket_preview/ticket_preview_page.dart';
import 'package:belarasa_mobile/modules/ticket_register/ticket_register_page.dart';
import 'package:get/get.dart';
part './routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.login, page: () => LoginPage(), binding: LoginBinding()),
    GetPage(name: Routes.home, page: () => HomePage(), binding: HomeBinding()),
    GetPage(name: Routes.tickets, page: () => TicketPage(), binding: TicketBinding()),
    GetPage(name: Routes.ticketPreview, page: () => TicketPreviewPage(), binding: TicketPreviewBinding()),
    GetPage(name: Routes.ticketRegister, page: () => TicketRegisterPage(), binding: TicketRegisterBinding()),
  ];
}
