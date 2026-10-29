enum AppointmentStatus { upcoming, completed, cancelled }

enum ConsultationType { video, audio, inClinic }

class AppointmentModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorHospital;
  final String doctorAvatar;
  final DateTime appointmentDate;
  final String timeSlot;
  final ConsultationType type;
  final AppointmentStatus status;
  final String reasonForVisit;
  final double fee;

  const AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorHospital,
    this.doctorAvatar = '',
    required this.appointmentDate,
    required this.timeSlot,
    required this.type,
    this.status = AppointmentStatus.upcoming,
    required this.reasonForVisit,
    required this.fee,
  });

  AppointmentModel copyWith({
    String? id,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialty,
    String? doctorHospital,
    String? doctorAvatar,
    DateTime? appointmentDate,
    String? timeSlot,
    ConsultationType? type,
    AppointmentStatus? status,
    String? reasonForVisit,
    double? fee,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      doctorHospital: doctorHospital ?? this.doctorHospital,
      doctorAvatar: doctorAvatar ?? this.doctorAvatar,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      timeSlot: timeSlot ?? this.timeSlot,
      type: type ?? this.type,
      status: status ?? this.status,
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      fee: fee ?? this.fee,
    );
  }
}
