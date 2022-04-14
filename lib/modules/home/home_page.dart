import 'package:belarasa_mobile/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
      ),
      body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Get.toNamed(Routes.masses);
            },
            icon: const Icon(Icons.list),
            label: Text("masses_list".tr)
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.toNamed(Routes.tickets);
            },
            icon: const Icon(Icons.list),
            label: Text("my_tickets".tr)
          )
        ],
      )),
    );
  }
}
