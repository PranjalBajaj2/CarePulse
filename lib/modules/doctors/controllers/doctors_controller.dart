import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../appointments/controllers/appointments_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../navigation/controllers/nav_controller.dart';

class DoctorsController extends GetxController {
  final IDoctorRepository _doctorRepo = Get.find<IDoctorRepository>();
  final IAppointmentRepository _appointmentRepo = Get.find<IAppointmentRepository>();

  final RxList<DoctorModel> doctors = <DoctorModel>[].obs;
  final RxList<String> specialties = <String>[].obs;
  final RxString selectedSpecialty = 'All Specialties'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;

  // Booking State
  final Rx<DoctorModel?> selectedDoctor = Rx<DoctorModel?>(null);
  final Rx<DateTime> selectedDate = DateTime.now().add(const Duration(days: 1)).obs;
  final RxString selectedSlot = ''.obs;
  final Rx<ConsultationType> selectedConsultationType = ConsultationType.video.obs;
  final TextEditingController reasonController = TextEditingController();
  final RxBool isBooking = false.obs;

  @override
  void onInit() {
    super.onInit();
    specialties.assignAll(_doctorRepo.getSpecialties());
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      isLoading.value = true;
      final result = await _doctorRepo.getDoctors(
        specialty: selectedSpecialty.value,
        searchQuery: searchQuery.value,
      );
      doctors.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  void filterBySpecialty(String specialty) {
    selectedSpecialty.value = specialty;
    loadDoctors();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    loadDoctors();
  }

  void startBooking(DoctorModel doctor) {
    selectedDoctor.value = doctor;
    selectedSlot.value = doctor.availableSlots.isNotEmpty ? doctor.availableSlots.first : '10:00 AM';
    selectedDate.value = DateTime.now().add(const Duration(days: 1));
    reasonController.clear();
  }

  Future<bool> confirmAppointment() async {
    final doc = selectedDoctor.value;
    if (doc == null) return false;

    if (reasonController.text.trim().isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter a brief reason for your visit.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isBooking.value = true;
      final newApt = AppointmentModel(
        id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
        doctorId: doc.id,
        doctorName: doc.name,
        doctorSpecialty: doc.specialty,
        doctorHospital: doc.hospital,
        appointmentDate: selectedDate.value,
        timeSlot: selectedSlot.value,
        type: selectedConsultationType.value,
        status: AppointmentStatus.upcoming,
        reasonForVisit: reasonController.text.trim(),
        fee: doc.consultationFee,
      );

      await _appointmentRepo.bookAppointment(newApt);

      // Refresh appointments and home controllers
      if (Get.isRegistered<AppointmentsController>()) {
        Get.find<AppointmentsController>().loadAppointments();
      }
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().loadHomeData();
      }

      Get.back(); // close booking view
      Get.find<NavigationController>().changeTab(2); // navigate to appointments tab

      Get.snackbar(
        'Appointment Confirmed! 🎉',
        'Your ${selectedConsultationType.value == ConsultationType.video ? "Video" : "In-Clinic"} session with ${doc.name} is scheduled.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return true;
    } finally {
      isBooking.value = false;
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
