class VitalReading {
  final String title;
  final String value;
  final String unit;
  final String status;
  final bool isHealthy;
  final String icon; // Icon identifier
  final String lastUpdated;

  const VitalReading({
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.isHealthy,
    required this.icon,
    required this.lastUpdated,
  });
}

class PatientVitalsModel {
  final VitalReading heartRate;
  final VitalReading bloodPressure;
  final VitalReading bloodGlucose;
  final VitalReading oxygenSaturation;
  final VitalReading weight;

  const PatientVitalsModel({
    required this.heartRate,
    required this.bloodPressure,
    required this.bloodGlucose,
    required this.oxygenSaturation,
    required this.weight,
  });
}
