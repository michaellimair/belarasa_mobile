import 'package:belarasa_mobile/data/models/tickets_model.dart';
import 'package:belarasa_mobile/data/providers/auth_provider.dart';
import 'package:belarasa_mobile/data/providers/tickets_provider.dart';
import 'package:belarasa_mobile/routes/pages.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final TicketsProvider ticketsProvider;
  final AuthProvider authProvider;

  RxBool isLoading = false.obs;
  final RxnInt showQrIndex = RxnInt();
  final RxnInt loadingShowTicketIndex = RxnInt();

  HomeController(this.ticketsProvider, this.authProvider);

  RxList<TicketModel> todayTickets = [].cast<TicketModel>().obs;

  Future<void> refreshTickets() {
    showQrIndex.value = null;
    isLoading.value = true;
    return ticketsProvider.listTickets().then((value) {
      String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      todayTickets.value =
          value.body!.where((element) => element.massDate == todayDate).toList();
      isLoading.value = false;
    }).catchError((e) {
      Get.snackbar("error".tr, "ticket_fetch_error".tr);
      isLoading.value = false;
    });
  }

  void showTicket(int index) async {
    loadingShowTicketIndex.value = index;
    TicketModel ticket = todayTickets[index];
    var ticketResponse = await ticketsProvider.showTicket(ticket);
    String ticketHtml = ticketResponse.body!;
    loadingShowTicketIndex.value = null;
    Get.toNamed(Routes.ticketPreview, arguments: [ticketHtml]);
  }

  void logout() async {
    await authProvider.logout();
  }

  void toggleQr(int index) {
    if (showQrIndex.value == index) {
      showQrIndex.value = null;
    } else {
      showQrIndex.value = index;
    }
  }

  @override
  void onInit() {
    super.onInit();
    refreshTickets();
  }
}
