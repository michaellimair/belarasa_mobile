import 'package:belarasa_mobile/routes/pages.dart';
import 'package:belarasa_mobile/services/cookie_service.dart';
import 'package:get/get.dart';

class AuthProvider extends GetConnect {
  Future<void> logout() async {
    CookieService cookieService = Get.find<CookieService>();
    await cookieService.clearCookies();
    Get.offNamed(Routes.login);
  }
}