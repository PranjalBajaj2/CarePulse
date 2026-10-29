import '../models/prescription_model.dart';
import '../mock_data/mock_healthcare_data.dart';

abstract class IPrescriptionRepository {
  Future<List<PrescriptionModel>> getPrescriptions({PrescriptionStatus? status});
  Future<PrescriptionModel?> getPrescriptionById(String id);
  Future<bool> requestRefill(String prescriptionId);
}

class PrescriptionRepository implements IPrescriptionRepository {
  final List<PrescriptionModel> _prescriptions = List.from(MockHealthcareData.prescriptions);

  @override
  Future<List<PrescriptionModel>> getPrescriptions({PrescriptionStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (status == null) return List.unmodifiable(_prescriptions);
    return _prescriptions.where((rx) => rx.status == status).toList();
  }

  @override
  Future<PrescriptionModel?> getPrescriptionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _prescriptions.firstWhere((rx) => rx.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> requestRefill(String prescriptionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _prescriptions.indexWhere((rx) => rx.id == prescriptionId);
    if (index != -1) {
      _prescriptions[index] = _prescriptions[index].copyWith(status: PrescriptionStatus.refillPending);
      return true;
    }
    return false;
  }
}
