import 'package:belarasa_mobile/routes/pages.dart';
import 'package:belarasa_mobile/services/cookie_service.dart';
import 'package:belarasa_mobile/theme/app_theme.dart';
import 'package:belarasa_mobile/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> initServices() async {
  await Get.putAsync(() => CookieService().init());
  await GetStorage.init();
}

void main() async {
  await initServices();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: Routes.login,
    theme: appThemeData,
    defaultTransition: Transition.fade,
    getPages: AppPages.pages,
    locale: const Locale('id', 'ID'),
    fallbackLocale: const Locale('en', 'US'),
    translationsKeys: AppTranslation.translations,
  ));
}
