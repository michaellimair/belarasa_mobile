import 'package:belarasa_mobile/data/models/tickets_model.dart';
import 'package:belarasa_mobile/data/providers/tickets_provider.dart';
import 'package:belarasa_mobile/routes/pages.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_store/open_store.dart';

class TicketController extends GetxController {
  final TicketsProvider ticketsProvider;

  RxBool isLoading = false.obs;
  final ScrollController massListController = ScrollController();
  final RxSet<int> loadingDeleteTicketIndex = RxSet<int>();
  final RxSet<int> loadingResendTicketIndex = RxSet<int>();
  final RxSet<int> loadingShowTicketIndex = RxSet<int>();
  final RxnString selectedDate = RxnString();

  TicketController(this.ticketsProvider);

  RxList<TicketModel> tickets = [].cast<TicketModel>().obs;
  RxList<TicketModel> originalTickets = [].cast<TicketModel>().obs;

  Future<void> refreshTickets() {
    isLoading.value = true;
    return ticketsProvider.listTickets().then((value) {
      tickets.value = value.body!;
      // Hack to persist selected date
      if (selectedDate.value != null) {
        selectDate(selectedDate.value!);
      }
      originalTickets.value = value.body!;
      isLoading.value = false;
      if (massListController.hasClients) {
        massListController.jumpTo(0.0);
      }
    }).catchError((e) {
      Get.snackbar("error".tr, "ticket_fetch_error".tr);
      isLoading.value = false;
    });
  }

  void resendTicket(int index) async {
    loadingResendTicketIndex.add(index);
    update();
    TicketModel ticket = tickets[index];
    try {
      var ticketResponse = await ticketsProvider.resendTicket(ticket);
      if (ticketResponse.body!['response'] == 'success') {
        Get.snackbar("success".tr, "resend_ticket_success".tr);
      } else {
        Get.snackbar("error".tr, "resend_ticket_error".tr);
      }
    } catch (e) {
      Get.snackbar("error".tr, "resend_ticket_error".tr);
    }
    loadingResendTicketIndex.remove(index);
    update();
  }

  void deleteTicket(int index) async {
    loadingDeleteTicketIndex.add(index);
    update();
    TicketModel ticket = tickets[index];
    try {
      var ticketResponse = await ticketsProvider.deleteTicket(ticket);
      if (ticketResponse.body! == DeleteTicketResponse.success) {
        Get.snackbar("cancel_ticket_success_title".tr,
            "cancel_ticket_success_message".tr);
      } else {
        Get.snackbar(
            "cancel_ticket_error_title".tr, "cancel_ticket_error_message".tr);
      }
    } catch (e) {
      Get.snackbar(
          "cancel_ticket_error_title".tr, "cancel_ticket_error_message".tr);
    }
    loadingDeleteTicketIndex.remove(index);
    tickets.clear();
    originalTickets();
    refreshTickets();
    update();
  }

  void showTicket(int index) async {
    loadingShowTicketIndex.add(index);
    update();
    TicketModel ticket = tickets[index];
    var ticketResponse = await ticketsProvider.showTicket(ticket);
    String ticketHtml = ticketResponse.body!;
    loadingShowTicketIndex.remove(index);
    update();
    Get.toNamed(Routes.ticketPreview, arguments: [ticketHtml]);
  }

  void selectDate(String date) {
    selectedDate.value = date;
    tickets.value = originalTickets.where((p0) {
      return p0.massDate == date;
    }).toList();
    if (massListController.hasClients) {
      massListController.jumpTo(0.0);
    }
  }

  Future<void> _alertNoPeduliLindungi(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('cancel_ticket'.tr),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("no_pedulilindungi".tr),
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
            TextButton(
              child: Text('install_pedulilindungi'.tr),
              onPressed: () {
                Navigator.of(context).pop();
                OpenStore.instance.open(
                  appStoreId: '1504600374',
                  androidAppBundleId: 'com.telkom.tracencare',
                );
              },
            ),
          ],
        );
      },
    );
  }

  void launchPeduliLindungi(BuildContext context) async {
    dynamic isAppInstalledRaw = await LaunchApp.isAppInstalled(
        androidPackageName: 'com.telkom.tracencare',
        iosUrlScheme: 'pedulilindungi://');
    bool isAppInstalled = false;
    if (isAppInstalledRaw is int) {
      isAppInstalled = isAppInstalledRaw == 1;
    } else if (isAppInstalledRaw is bool) {
      isAppInstalled = isAppInstalledRaw;
    }
    if (!isAppInstalled) {
      _alertNoPeduliLindungi(context);
      return;
    }
    await LaunchApp.openApp(
      androidPackageName: 'com.telkom.tracencare',
      iosUrlScheme: 'pedulilindungi://',
      appStoreLink:
          'itms-apps://itunes.apple.com/id/app/pedulilindungi/id1504600374',
      openStore: false,
    );
  }

  void clearDate() {
    selectedDate.value = null;
    tickets.value = originalTickets;
  }

  @override
  void onInit() {
    super.onInit();
    refreshTickets();
  }
}
