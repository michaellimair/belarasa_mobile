import 'package:belarasa_mobile/controllers/home_controller.dart';
import 'package:belarasa_mobile/data/models/mass_model.dart';
import 'package:belarasa_mobile/modules/home/widgets/target_audience_chip.dart';
import 'package:belarasa_mobile/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          IconButton(
            onPressed: controller.switchLocale,
            icon: const Icon(Icons.language),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'logout'.tr,
            onPressed: () {
              Get.defaultDialog(
                title: "logout_belarasa_title".tr,
                middleText: "logout_belarasa_message".tr,
                textConfirm: "logout".tr,
                textCancel: "cancel".tr,
                onConfirm: () {
                  controller.logout();
                },
                buttonColor: Colors.red,
                confirmTextColor: Colors.white,
                titleStyle: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
                radius: 8,
              );
            },
          ),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.viewTickets,
                child: Text("my_tickets".tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    )),
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 0), child: Text("mass_registration".tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    )),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Obx(() => Expanded(
                    child: ElevatedButton.icon(onPressed: () async {
                    DateTime? selectedDateTime = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: controller.selectedDate.value != null
                            ? controller.selectedDate.value!
                            : DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1));
                    if (selectedDateTime != null) {
                      controller.selectDate(selectedDateTime);
                    }
                  }, icon: const Icon(Icons.calendar_month), label: Text(controller.selectedDate.value != null ? DateFormat('dd MMM yyyy').format(controller.selectedDate.value!) : "select_date".tr)))),
                Obx(() => controller.selectedDate.value != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: controller.clearDate)
                    : Container()),
              ],
            ),
          ),
          Expanded(child: Obx(() {
            if (controller.isLoading.value && controller.masses.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (controller.masses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("no_masses".tr),
                    const SizedBox(height: 16),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: controller.refreshMasses,
                    )
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                await controller.refreshMasses();
              },
              child: ListView.separated(
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.black),
                  itemCount: controller.masses.length,
                  itemBuilder: (BuildContext context, int index) {
                    MassModel mass = controller.masses[index];
                    return InkWell(
                      onTap: () {
                        Get.toNamed(Routes.ticketRegister, arguments: [mass.registrationLink]);
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(mass.eventName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: Colors.red,
                                        )),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: Colors.red,
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text("remaining_quota".tr,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.white)),
                                          Text("${mass.remainingQuota}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 28,
                                                  color: Colors.white))
                                        ],
                                      ))
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text("${mass.date} | ${mass.time}", style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              )),
                              if (mass.targetAudience != null)
                                const SizedBox(height: 4),
                              if (mass.targetAudience != null)
                                TargetAudienceChip(
                                  targetAudience: mass.targetAudience!,
                                ),
                              Text(mass.churchName,
                                  style: Theme.of(context).textTheme.headline6),
                              const SizedBox(height: 4),
                              Text(mass.region),
                              Text(mass.parish),
                              const SizedBox(height: 8),
                              Text(mass.territory),
                              Text(mass.neighborhood),
                            ],
                          )),
                    );
                  }),
            );
          }))
        ],
      )),
    );
  }
}
