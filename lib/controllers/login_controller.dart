import 'dart:convert';

import 'package:belarasa_mobile/data/providers/locale_provider.dart';
import 'package:belarasa_mobile/data/providers/login_provider.dart';
import 'package:belarasa_mobile/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final LoginProvider loginProvider;
  final LocaleProvider _localeProvider;

  LoginController(this.loginProvider, this._localeProvider);

  final loginFormKey = GlobalKey<FormState>();
  final emailOrPhoneController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = true.obs;

  final String emailKey = 'belarasa_email';
  final String passwordKey = 'belarasa_password';
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    emailOrPhoneController.text = await secureStorage.read(key: emailKey) ?? '';
    passwordController.text = await secureStorage.read(key: passwordKey) ?? '';
    super.onInit();
    if (emailOrPhoneController.text.isNotEmpty) {
      login();
    }
  }

  void switchLocale() {
    _localeProvider.switchLocale();
  }

  @override
  void onClose() {
    emailOrPhoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return 'required_field'.tr;
    }
    return null;
  }

  void toggleRememberMe() {
    rememberMe.toggle();
  }

  Future<bool> performLogin(String email, String password) async {
    Response loginResponse = await loginProvider.login(email, password);
    Map<String, dynamic> responseJson = jsonDecode(loginResponse.bodyString!);
    if (responseJson['response'] == 'success') {
      return true;
    }
    return false;
  }

  void login() async {
    if (!(loginFormKey.currentState?.validate() ?? false)) {
      return;
    }
    isLoading.value = true;
    try {
      bool loginSuccess = await performLogin(
          emailOrPhoneController.text, passwordController.text);
      if (loginSuccess) {
        FlutterSecureStorage secureStorage = const FlutterSecureStorage();
        if (rememberMe.value) {
          await secureStorage.write(
              key: emailKey, value: emailOrPhoneController.text);
          await secureStorage.write(
              key: passwordKey, value: passwordController.text);
        } else {
          await secureStorage.deleteAll();
        }
        emailOrPhoneController.clear();
        passwordController.clear();
        Get.offNamed(Routes.home);
      } else {
        Get.snackbar('login'.tr, 'invalid_email_password'.tr);
      }
    } catch (e) {
      Get.snackbar('login'.tr, 'login_error'.tr);
    } finally {
      isLoading.value = false;
    }
  }
}
