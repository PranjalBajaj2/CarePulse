import 'package:get/get.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/vitals_model.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/vitals_repository.dart';

class HomeController extends GetxController {
  final IAuthRepository _authRepo = Get.find<IAuthRepository>();
  final IAppointmentRepository _appointmentRepo = Get.find<IAppointmentRepository>();
  final IVitalsRepository _vitalsRepo = Get.find<IVitalsRepository>();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final Rx<AppointmentModel?> nextAppointment = Rx<AppointmentModel?>(null);
  final Rx<PatientVitalsModel?> vitals = Rx<PatientVitalsModel?>(null);
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      user.value = _authRepo.getCurrentUser();
      final appointments = await _appointmentRepo.getAppointments(status: AppointmentStatus.upcoming);
      if (appointments.isNotEmpty) {
        nextAppointment.value = appointments.first;
      } else {
        nextAppointment.value = null;
      }
      vitals.value = await _vitalsRepo.getVitals();
    } finally {
      isLoading.value = false;
    }
  }
}
