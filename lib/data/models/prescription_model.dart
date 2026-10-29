class MedicationItem {
  final String name;
  final String dosage; // e.g. "500 mg"
  final String frequency; // e.g. "Twice daily after meals"
  final String duration; // e.g. "14 days"
  final String instructions;
  final int refillsRemaining;
  final String pillShape; // e.g. "Capsule", "Tablet"

  const MedicationItem({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
    this.refillsRemaining = 2,
    this.pillShape = 'Tablet',
  });
}

enum PrescriptionStatus { active, refillPending, completed }

class PrescriptionModel {
  final String id;
  final String rxNumber;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final DateTime issuedDate;
  final DateTime expiryDate;
  final String diagnosis;
  final List<MedicationItem> medications;
  final PrescriptionStatus status;
  final String clinicalNotes;

  const PrescriptionModel({
    required this.id,
    required this.rxNumber,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.issuedDate,
    required this.expiryDate,
    required this.diagnosis,
    required this.medications,
    this.status = PrescriptionStatus.active,
    this.clinicalNotes = '',
  });

  PrescriptionModel copyWith({
    String? id,
    String? rxNumber,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialty,
    DateTime? issuedDate,
    DateTime? expiryDate,
    String? diagnosis,
    List<MedicationItem>? medications,
    PrescriptionStatus? status,
    String? clinicalNotes,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      rxNumber: rxNumber ?? this.rxNumber,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      issuedDate: issuedDate ?? this.issuedDate,
      expiryDate: expiryDate ?? this.expiryDate,
      diagnosis: diagnosis ?? this.diagnosis,
      medications: medications ?? this.medications,
      status: status ?? this.status,
      clinicalNotes: clinicalNotes ?? this.clinicalNotes,
    );
  }
}
