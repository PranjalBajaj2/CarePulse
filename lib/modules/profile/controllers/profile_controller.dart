import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final IAuthRepository _authRepo = Get.find<IAuthRepository>();
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    user.value = _authRepo.getCurrentUser();
  }

  void toggleBiometrics(bool enabled) {
    if (user.value != null) {
      user.value = user.value!.copyWith(isBiometricsEnabled: enabled);
      _authRepo.updateProfile(user.value!);
      if (Get.isRegistered<AuthController>()) {
        Get.find<AuthController>().toggleBiometrics(enabled);
      }
    }
  }

  Future<void> logout() async {
    if (Get.isRegistered<AuthController>()) {
      await Get.find<AuthController>().logout();
    } else {
      Get.offAllNamed('/login');
    }
  }
}
