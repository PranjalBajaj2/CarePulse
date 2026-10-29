import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/prescription_model.dart';
import '../../../data/repositories/prescription_repository.dart';

class PrescriptionsController extends GetxController {
  final IPrescriptionRepository _prescriptionRepo = Get.find<IPrescriptionRepository>();

  final RxList<PrescriptionModel> prescriptions = <PrescriptionModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedFilter = 'All'.obs; // All, Active, Refill Pending

  @override
  void onInit() {
    super.onInit();
    loadPrescriptions();
  }

  Future<void> loadPrescriptions() async {
    try {
      isLoading.value = true;
      final list = await _prescriptionRepo.getPrescriptions();
      prescriptions.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  List<PrescriptionModel> get filteredPrescriptions {
    if (selectedFilter.value == 'Active') {
      return prescriptions.where((rx) => rx.status == PrescriptionStatus.active).toList();
    } else if (selectedFilter.value == 'Refill Pending') {
      return prescriptions.where((rx) => rx.status == PrescriptionStatus.refillPending).toList();
    }
    return prescriptions;
  }

  Future<void> requestRefill(PrescriptionModel rx) async {
    final success = await _prescriptionRepo.requestRefill(rx.id);
    if (success) {
      await loadPrescriptions();
      Get.snackbar(
        'Refill Order Placed! 💊',
        'Your refill request for ${rx.rxNumber} has been transmitted to the partnering pharmacy for clinical approval and courier delivery.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }
}
