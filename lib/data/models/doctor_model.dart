class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String qualifications;
  final String hospital;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final double consultationFee;
  final String about;
  final List<String> availableDays;
  final List<String> availableSlots;
  final String avatarUrl;
  final bool isOnline;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualifications,
    required this.hospital,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.consultationFee,
    required this.about,
    required this.availableDays,
    required this.availableSlots,
    this.avatarUrl = '',
    this.isOnline = true,
  });
}
