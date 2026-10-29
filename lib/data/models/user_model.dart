class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String bloodGroup;
  final List<String> allergies;
  final List<String> chronicConditions;
  final String emergencyContact;
  final bool isBiometricsEnabled;
  final String avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.bloodGroup,
    this.allergies = const [],
    this.chronicConditions = const [],
    required this.emergencyContact,
    this.isBiometricsEnabled = true,
    this.avatarUrl = '',
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? bloodGroup,
    List<String>? allergies,
    List<String>? chronicConditions,
    String? emergencyContact,
    bool? isBiometricsEnabled,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
