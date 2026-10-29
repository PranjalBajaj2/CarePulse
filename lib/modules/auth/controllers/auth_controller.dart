import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final IAuthRepository _authRepository = Get.find<IAuthRepository>();

  final emailController = TextEditingController(text: 'p.bajaj212@gmail.com');
  final passwordController = TextEditingController(text: 'CarePulse@2026');

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isBiometricScanning = false.obs;
  final RxBool obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _authRepository.getCurrentUser();
  }

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your email and password.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isLoading.value = true;
      final user = await _authRepository.login(email, password);
      currentUser.value = user;
      Get.snackbar(
        'Welcome Back!',
        'Successfully authenticated to CarePulse.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.teal.shade700,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Authentication Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      isBiometricScanning.value = true;
      final user = await _authRepository.loginWithBiometrics();
      currentUser.value = user;
      return true;
    } catch (_) {
      return false;
    } finally {
      isBiometricScanning.value = false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    Get.offAllNamed('/login');
  }

  void toggleBiometrics(bool enabled) {
    if (currentUser.value != null) {
      currentUser.value = currentUser.value!.copyWith(isBiometricsEnabled: enabled);
      _authRepository.updateProfile(currentUser.value!);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
