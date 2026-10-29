import '../models/doctor_model.dart';
import '../mock_data/mock_healthcare_data.dart';

abstract class IDoctorRepository {
  Future<List<DoctorModel>> getDoctors({String? specialty, String? searchQuery});
  Future<DoctorModel?> getDoctorById(String id);
  List<String> getSpecialties();
}

class DoctorRepository implements IDoctorRepository {
  final List<DoctorModel> _doctors = List.from(MockHealthcareData.doctors);

  @override
  List<String> getSpecialties() {
    return [
      'All Specialties',
      'Cardiologist',
      'Dermatologist',
      'Neurologist',
      'General Physician',
      'Pediatrician',
    ];
  }

  @override
  Future<List<DoctorModel>> getDoctors({String? specialty, String? searchQuery}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var results = List<DoctorModel>.from(_doctors);

    if (specialty != null && specialty != 'All Specialties') {
      results = results.where((doc) => doc.specialty.toLowerCase() == specialty.toLowerCase()).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      results = results
          .where((doc) =>
              doc.name.toLowerCase().contains(query) ||
              doc.specialty.toLowerCase().contains(query) ||
              doc.hospital.toLowerCase().contains(query))
          .toList();
    }

    return results;
  }

  @override
  Future<DoctorModel?> getDoctorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _doctors.firstWhere((doc) => doc.id == id);
    } catch (_) {
      return null;
    }
  }
}
