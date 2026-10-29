import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../home/controllers/home_controller.dart';

class AppointmentsController extends GetxController {
  final IAppointmentRepository _appointmentRepo = Get.find<IAppointmentRepository>();

  final RxList<AppointmentModel> upcomingAppointments = <AppointmentModel>[].obs;
  final RxList<AppointmentModel> pastAppointments = <AppointmentModel>[].obs;
  final RxList<AppointmentModel> cancelledAppointments = <AppointmentModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      isLoading.value = true;
      final all = await _appointmentRepo.getAppointments();
      upcomingAppointments.assignAll(all.where((a) => a.status == AppointmentStatus.upcoming));
      pastAppointments.assignAll(all.where((a) => a.status == AppointmentStatus.completed));
      cancelledAppointments.assignAll(all.where((a) => a.status == AppointmentStatus.cancelled));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelAppointment(String id) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Cancel Appointment?'),
        content: const Text('Are you sure you want to cancel this scheduled consultation?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Keep Appointment')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _appointmentRepo.cancelAppointment(id);
      loadAppointments();
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().loadHomeData();
      }
      Get.snackbar(
        'Appointment Cancelled',
        'Your appointment has been successfully cancelled.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
