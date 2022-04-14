import 'package:belarasa_mobile/data/models/tickets_model.dart';
import 'package:belarasa_mobile/data/providers/tickets_provider.dart';
import 'package:belarasa_mobile/routes/pages.dart';
import 'package:get/get.dart';

class TicketController extends GetxController {
  final TicketsProvider ticketsProvider;

  RxBool isLoading = false.obs;
  final RxnInt showQrIndex = RxnInt();
  final RxnInt loadingShowTicketIndex = RxnInt();
  final RxnString selectedDate = RxnString();

  TicketController(this.ticketsProvider);

  RxList<TicketModel> tickets = [].cast<TicketModel>().obs;
  RxList<TicketModel> originalTickets = [].cast<TicketModel>().obs;

  Future<void> refreshTickets() {
    selectedDate.value = null;
    showQrIndex.value = null;
    isLoading.value = true;
    return ticketsProvider.listTickets().then((value) {
      tickets.value = value.body!;
      originalTickets.value = value.body!;
      isLoading.value = false;
    }).catchError((e) {
      Get.snackbar("error".tr, "ticket_fetch_error".tr);
      isLoading.value = false;
    });
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
  }

  void clearDate() {
    selectedDate.value = null;
    tickets.value = originalTickets;
  }

  void toggleQr(int index) {
    if (showQrIndex.value == index) {
      showQrIndex.value = null;
    } else {
      showQrIndex.value = index;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    refreshTickets();
  }
}
