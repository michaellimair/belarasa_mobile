import 'package:belarasa_mobile/data/models/tickets_model.dart';
import 'package:belarasa_mobile/data/providers/tickets_provider.dart';
import 'package:belarasa_mobile/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketController extends GetxController {
  final TicketsProvider ticketsProvider;

  RxBool isLoading = false.obs;
  final ScrollController massListController = ScrollController();
  final RxnInt showQrIndex = RxnInt();
  final RxSet<int> loadingResendTicketIndex = RxSet<int>();
  final RxnInt loadingShowTicketIndex = RxnInt();
  final RxnString selectedDate = RxnString();

  TicketController(this.ticketsProvider);

  RxList<TicketModel> tickets = [].cast<TicketModel>().obs;
  RxList<TicketModel> originalTickets = [].cast<TicketModel>().obs;

  Future<void> refreshTickets() {
    showQrIndex.value = null;
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

  void showTicket(int index) async {
    loadingShowTicketIndex.value = index;
    update();
    TicketModel ticket = tickets[index];
    var ticketResponse = await ticketsProvider.showTicket(ticket);
    String ticketHtml = ticketResponse.body!;
    loadingShowTicketIndex.value = null;
    update();
    Get.toNamed(Routes.ticketPreview, arguments: [ticketHtml]);
  }

  void selectDate(String date) {
    selectedDate.value = date;
    tickets.value = originalTickets.where((p0) {
      return p0.massDate == date;
    }).toList();
    massListController.jumpTo(0.0);
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
