import 'package:belarasa_mobile/routes/pages.dart';
import 'package:belarasa_mobile/services/cookie_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthProvider extends GetConnect {
  Future<void> logout() async {
    CookieService cookieService = Get.find<CookieService>();
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    await cookieService.clearCookies();
    await secureStorage.deleteAll();
    Get.offAllNamed(Routes.login);
  }
}
