import 'package:belarasa_mobile/bindings/login_binding.dart';
import 'package:belarasa_mobile/bindings/mass_binding.dart';
import 'package:belarasa_mobile/bindings/ticket_binding.dart';
import 'package:belarasa_mobile/bindings/ticket_preview_binding.dart';
import 'package:belarasa_mobile/modules/home/home_page.dart';
import 'package:belarasa_mobile/modules/login/login_page.dart';
import 'package:belarasa_mobile/modules/mass/mass_page.dart';
import 'package:belarasa_mobile/modules/ticket/ticket_page.dart';
import 'package:belarasa_mobile/modules/ticket_preview/ticket_preview_page.dart';
import 'package:get/get.dart';
part './routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.login, page: () => LoginPage(), binding: LoginBinding()),
    GetPage(name: Routes.home, page: () => HomePage()),
    GetPage(name: Routes.tickets, page: () => TicketPage(), binding: TicketBinding()),
    GetPage(name: Routes.ticketPreview, page: () => TicketPreviewPage(), binding: TicketPreviewBinding()),
    GetPage(name: Routes.masses, page: () => MassPage(), binding: MassBinding())
  ];
}
