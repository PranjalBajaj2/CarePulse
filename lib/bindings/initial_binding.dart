import 'package:get/get.dart';
import '../data/repositories/appointment_repository.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/chat_repository.dart';
import '../data/repositories/doctor_repository.dart';
import '../data/repositories/prescription_repository.dart';
import '../data/repositories/vitals_repository.dart';
import '../modules/appointments/controllers/appointments_controller.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/chat/controllers/chat_controller.dart';
import '../modules/doctors/controllers/doctors_controller.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/navigation/controllers/nav_controller.dart';
import '../modules/prescriptions/controllers/prescriptions_controller.dart';
import '../modules/profile/controllers/profile_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Repositories (Pluggable Mock / Live Firebase)
    Get.put<IAuthRepository>(AuthRepository(), permanent: true);
    Get.put<IDoctorRepository>(DoctorRepository(), permanent: true);
    Get.put<IAppointmentRepository>(AppointmentRepository(), permanent: true);
    Get.put<IPrescriptionRepository>(PrescriptionRepository(), permanent: true);
    Get.put<IChatRepository>(ChatRepository(), permanent: true);
    Get.put<IVitalsRepository>(VitalsRepository(), permanent: true);

    // 2. Navigation & Auth Controllers
    Get.put<NavigationController>(NavigationController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);

    // 3. Domain Feature Controllers
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<DoctorsController>(DoctorsController(), permanent: true);
    Get.put<AppointmentsController>(AppointmentsController(), permanent: true);
    Get.put<PrescriptionsController>(PrescriptionsController(), permanent: true);
    Get.put<ChatController>(ChatController(), permanent: true);
    Get.put<ProfileController>(ProfileController(), permanent: true);
  }
}
