import 'dart:convert';

import 'package:belarasa_mobile/data/providers/login_provider.dart';
import 'package:belarasa_mobile/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final LoginProvider loginProvider;

  LoginController(this.loginProvider);

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

  // Api Simulation
  Future<bool> performLogin(String email, String password) async {
    try {
      isLoading.value = true;
      Response loginResponse = await loginProvider.login(email, password);
      isLoading.value = false;
      Map<String, dynamic> responseJson = jsonDecode(loginResponse.bodyString!);
      if (responseJson['response'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void login() {
    if (loginFormKey.currentState?.validate() ?? false) {
      performLogin(emailOrPhoneController.text, passwordController.text)
          .then((auth) async {
        if (auth) {
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
      });
    }
  }
}
