import 'package:belarasa_mobile/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login_to_belarasa'.tr),
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
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.passwordController,
              decoration: InputDecoration(labelText: 'password'.tr),
              obscureText: true,
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
            Obx(() => ElevatedButton(
              onPressed: !controller.isLoading.value ? controller.login : null,
              child: Text('login'.tr),
            )),
          ],
        ),
      ),
    );
  }
}
