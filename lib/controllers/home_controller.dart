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

  HomeController(this.massesProvider, this.authProvider);

  RxList<MassModel> masses = [].cast<MassModel>().obs;

  Future<void> refreshMasses() {
    isLoading.value = true;
    return massesProvider.listMasses().then((value) {
      masses.value = value.body!;
      isLoading.value = false;
    }).catchError((e) {
      Get.snackbar("error".tr, "mass_fetch_error".tr);
      isLoading.value = false;
    });
  }

  void viewTodayTickets() {
    Get.toNamed(Routes.tickets,
        arguments: [DateFormat("yyyy-MM-dd").format(DateTime.now())]);
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
