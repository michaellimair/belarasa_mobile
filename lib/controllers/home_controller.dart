import 'package:belarasa_mobile/data/models/mass_model.dart';
import 'package:belarasa_mobile/data/providers/auth_provider.dart';
import 'package:belarasa_mobile/data/providers/masses_provider.dart';
import 'package:belarasa_mobile/routes/pages.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final AuthProvider authProvider;
  final MassesProvider massesProvider;

  RxBool isLoading = false.obs;
  final Rxn<DateTime?> selectedDate = Rxn<DateTime?>();

  HomeController(this.massesProvider, this.authProvider);

  RxList<MassModel> masses = [].cast<MassModel>().obs;
  RxList<MassModel> originalMasses = [].cast<MassModel>().obs;

  Future<void> refreshMasses() {
    isLoading.value = true;
    return massesProvider.listMasses().then((value) {
      masses.value = value.body!;
      if (selectedDate.value != null) {
        selectDate(selectedDate.value!);
      }
      originalMasses.value = value.body!;
      isLoading.value = false;
    }).catchError((e) {
      Get.snackbar("error".tr, "mass_fetch_error".tr);
      isLoading.value = false;
    });
  }

  void viewTickets() {
    Get.toNamed(Routes.tickets);
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    DateFormat fmt = DateFormat("dd MMM yyyy");
    DateFormat altFmt = DateFormat("dd MMMM yyyy");
    // Use date string contains since there is no proper date data present in the HTML
    masses.value = originalMasses.where((p0) {
      return [p0.date, p0.eventName].any((dt) =>
          dt.contains(fmt.format(date)) || dt.contains(altFmt.format(date)));
    }).toList();
  }

  void clearDate() {
    selectedDate.value = null;
    masses.value = originalMasses;
  }

  void logout() async {
    await authProvider.logout();
  }

  @override
  void onInit() {
    super.onInit();
    refreshMasses();
  }
}
