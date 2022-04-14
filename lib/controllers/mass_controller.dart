import 'package:belarasa_mobile/data/models/mass_model.dart';
import 'package:belarasa_mobile/data/providers/auth_provider.dart';
import 'package:belarasa_mobile/data/providers/masses_provider.dart';
import 'package:get/get.dart';

class MassController extends GetxController {
  final MassesProvider massesProvider;
  final AuthProvider authProvider;

  RxBool isLoading = false.obs;
  final RxnInt showQrIndex = RxnInt();

  MassController(this.massesProvider, this.authProvider);

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

  Future<void> logout() {
    return authProvider.logout();
  }

  @override
  void onInit() {
    super.onInit();
    refreshMasses();
  }
}
