import 'package:belarasa_mobile/controllers/home_controller.dart';
import 'package:belarasa_mobile/data/models/mass_model.dart';
import 'package:belarasa_mobile/modules/home/widgets/target_audience_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'logout'.tr,
            onPressed: () {
              controller.logout();
            },
          ),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: controller.viewTodayTickets,
                child: Text("my_tickets".tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("masses_list".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
          ),
          const SizedBox(height: 16),
          Expanded(child: Obx(() {
            if (controller.isLoading.value && controller.masses.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (controller.masses.isEmpty) {
              return Center(
                child: Text("no_masses".tr),
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
                      onTap: () {},
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
                              Text(mass.date),
                              Text(mass.time),
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
