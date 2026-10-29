import '../models/vitals_model.dart';
import '../mock_data/mock_healthcare_data.dart';

abstract class IVitalsRepository {
  Future<PatientVitalsModel> getVitals();
}

class VitalsRepository implements IVitalsRepository {
  @override
  Future<PatientVitalsModel> getVitals() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockHealthcareData.vitals;
  }
}
