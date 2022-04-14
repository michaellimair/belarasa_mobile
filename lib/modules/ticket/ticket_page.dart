import 'package:belarasa_mobile/controllers/ticket_controller.dart';
import 'package:belarasa_mobile/data/models/tickets_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TicketPage extends GetView<TicketController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_tickets'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'select_date'.tr,
            onPressed: () async {
              DateTime? selectedDateTime = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2021),
                  initialDate: controller.selectedDate.value != null
                      ? DateTime.parse(controller.selectedDate.value!)
                      : DateTime.now(),
                  lastDate: DateTime(2023));
              if (selectedDateTime != null) {
                String dt = DateFormat("yyyy-MM-dd").format(selectedDateTime);
                controller.selectDate(dt);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'refresh_tickets'.tr,
            onPressed: () {
              controller.refreshTickets();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'logout'.tr,
            onPressed: () {
              controller.logout();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (controller.tickets.isEmpty) {
          return Center(
            child: Text("no_tickets".tr),
          );
        }
        return ListView.separated(
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Colors.black),
            itemCount: controller.tickets.length,
            itemBuilder: (BuildContext context, int index) {
              TicketModel ticket = controller.tickets[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0 && controller.selectedDate.value != null)
                    Container(
                        color: Colors.red[100],
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("showing_mass_date".trParams({
                              "date": DateFormat("dd MMM yyyy").format(
                                  DateTime.parse(
                                      controller.selectedDate.value!))
                            })),
                            const SizedBox(width: 8),
                            IconButton(
                                onPressed: () {
                                  controller.clearDate();
                                },
                                icon: const Icon(Icons.clear))
                          ],
                        )),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ticket.eventName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.red,
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(ticket.registrantName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(ticket.diocese),
                        Text(ticket.location),
                        Text(ticket.churchName),
                        const SizedBox(height: 8),
                        Obx(() => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    controller.toggleQr(index);
                                  },
                                  child: Text(
                                      controller.showQrIndex.value == index
                                          ? "hide_qr".tr
                                          : "show_qr".tr)),
                            )),
                        const SizedBox(height: 8),
                        Obx(() => controller.showQrIndex.value == index
                            ? Image.network(ticket.qrCodeUrl)
                            : Container()),
                        SizedBox(
                          width: double.infinity,
                          child: Obx(() => ElevatedButton(
                              onPressed: controller.loadingShowTicketIndex.value != index ? () {
                                controller.showTicket(index);
                              } : null,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green.shade800,
                              ),
                              child: Text("show_ticket".tr))),
                        )
                      ],
                    ),
                  )
                ],
              );
            });
      }),
    );
  }
}