import 'package:belarasa_mobile/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login_to_belarasa'.tr),
        actions: [
          IconButton(
            onPressed: controller.switchLocale,
            icon: const Icon(Icons.language),
          )
        ],
      ),
      body: Form(
        key: controller.loginFormKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: controller.emailOrPhoneController,
              decoration: InputDecoration(labelText: 'email_or_phone'.tr),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.passwordController,
              decoration: InputDecoration(labelText: 'password'.tr),
              obscureText: true,
              onFieldSubmitted: (String value) {
                controller.login();
              },
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            Obx(() => CheckboxListTile(
                  title: Text('remember_me'.tr),
                  value: controller.rememberMe.value,
                  onChanged: (bool? value) {
                    controller.toggleRememberMe();
                  },
                )),
            const SizedBox(height: 16),
            Obx(() => SizedBox(
              height: 60,
              child: ElevatedButton(
                    onPressed:
                        !controller.isLoading.value ? controller.login : null,
                    child: !controller.isLoading.value ? Text('login'.tr, style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    )) : const CircularProgressIndicator(),
                  ),
            )),
          ],
        ),
      ),
    );
  }
}
