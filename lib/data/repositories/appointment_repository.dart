import '../models/appointment_model.dart';
import '../mock_data/mock_healthcare_data.dart';

abstract class IAppointmentRepository {
  Future<List<AppointmentModel>> getAppointments({AppointmentStatus? status});
  Future<AppointmentModel> bookAppointment(AppointmentModel appointment);
  Future<bool> cancelAppointment(String id);
}

class AppointmentRepository implements IAppointmentRepository {
  final List<AppointmentModel> _appointments = List.from(MockHealthcareData.appointments);

  @override
  Future<List<AppointmentModel>> getAppointments({AppointmentStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (status == null) return List.unmodifiable(_appointments);
    return _appointments.where((apt) => apt.status == status).toList();
  }

  @override
  Future<AppointmentModel> bookAppointment(AppointmentModel appointment) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _appointments.insert(0, appointment);
    return appointment;
  }

  @override
  Future<bool> cancelAppointment(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _appointments.indexWhere((apt) => apt.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(status: AppointmentStatus.cancelled);
      return true;
    }
    return false;
  }
}
