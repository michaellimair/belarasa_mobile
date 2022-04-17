import 'package:belarasa_mobile/controllers/ticket_controller.dart';
import 'package:belarasa_mobile/data/models/tickets_model.dart';
import 'package:belarasa_mobile/modules/ticket/widgets/padded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TicketPage extends GetView<TicketController> {
  Widget _buildHeader(BuildContext context) {
    if (controller.selectedDate.value == null) {
      return Container();
    }
    return Container(
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
              "date": DateFormat("dd MMM yyyy")
                  .format(DateTime.parse(controller.selectedDate.value!))
            })),
            const SizedBox(width: 8),
            IconButton(
                onPressed: () {
                  controller.clearDate();
                },
                icon: const Icon(Icons.clear))
          ],
        ));
  }

  Future<void> _showQrDialog(BuildContext context, TicketModel ticket) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('qr_code'.tr),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(ticket.eventName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                Text(
                  ticket.registrantName,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(ticket.qrCodeUrl),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('close'.tr),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailsDisplay(BuildContext context, TicketModel ticket) {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ticket.registrantName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(ticket.diocese),
            Text(ticket.location),
            Text(ticket.churchName),
          ],
        )),
        PaddedButton(
          onTap: () {
            _showQrDialog(context, ticket);
          },
          text: "qr_code".tr,
          color: Colors.red.shade800,
        ),
      ],
    );
  }

  Widget _buildTicketContent(BuildContext context, int index) {
    TicketModel ticket = controller.tickets[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              _buildDetailsDisplay(context, ticket),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                    onPressed:
                        !controller.loadingResendTicketIndex.contains(index)
                            ? () {
                                controller.resendTicket(index);
                              }
                            : null,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade800,
                    ),
                    child: Text("resend_ticket".tr))),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                    onPressed: controller.loadingShowTicketIndex.value != index
                        ? () {
                            controller.showTicket(index);
                          }
                        : null,
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
  }

  Widget _buildTicketList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshTickets,
      child: ListView.separated(
          controller: controller.massListController,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Colors.black),
          itemCount: controller.tickets.length,
          itemBuilder: _buildTicketContent),
    );
  }

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
                  firstDate: DateTime(DateTime.now().year - 1),
                  initialDate: controller.selectedDate.value != null
                      ? DateTime.parse(controller.selectedDate.value!)
                      : DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1));
              if (selectedDateTime != null) {
                String dt = DateFormat("yyyy-MM-dd").format(selectedDateTime);
                controller.selectDate(dt);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.tickets.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (controller.tickets.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("no_tickets".tr),
                const SizedBox(height: 16),
                IconButton(
                    onPressed: () {
                      controller.refreshTickets();
                    },
                    icon: const Icon(Icons.refresh))
              ],
            )),
          );
        }
        return Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildTicketList(context))
          ],
        );
      }),
    );
  }
}
