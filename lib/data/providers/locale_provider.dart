import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleProvider {
  final GetStorage _getStorage;
  final String _localeLanguageCode = 'appLanguageCode';
  final String _localeCountryCode = 'appCountryCode';

  LocaleProvider(this._getStorage);

  Locale getStoredLocale([Locale fallbackLocale = const Locale('id', 'ID')]) {
    return Locale(
        _getStorage.read(_localeLanguageCode) ?? fallbackLocale.languageCode,
        _getStorage.read(_localeCountryCode) ?? fallbackLocale.countryCode);
  }

  void switchLocale() {
    const Locale idLocale = Locale('id', 'ID');
    const Locale enLocale = Locale('en', 'US');
    Locale targetLocale = Get.locale == idLocale ? enLocale : idLocale;
    Get.updateLocale(targetLocale);
    _getStorage.write(_localeLanguageCode, targetLocale.languageCode);
    _getStorage.write(_localeCountryCode, targetLocale.countryCode);
  }
}
