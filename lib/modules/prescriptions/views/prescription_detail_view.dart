import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../data/models/prescription_model.dart';
import '../controllers/prescriptions_controller.dart';

class PrescriptionDetailView extends StatelessWidget {
  final PrescriptionModel prescription;

  const PrescriptionDetailView({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM d, yyyy');
    final controller = Get.find<PrescriptionsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('E-Prescription Document'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              Get.snackbar(
                'Prescription Shared',
                'E-Prescription ${prescription.rxNumber} exported as encrypted PDF.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Medical Prescription Sheet
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clinic & Rx Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.local_hospital_rounded, color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CarePulse Clinic', style: AppTextStyles.h3),
                              Text('Licensed Telehealth Provider', style: AppTextStyles.caption),
                            ],
                          ),
                        ],
                      ),
                      const Text(
                        '℞',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          fontFamily: 'serif',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 1.5, color: AppColors.border),
                  const SizedBox(height: 14),

                  // Metadata Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Prescription ID', style: AppTextStyles.caption),
                          const SizedBox(height: 2),
                          Text(prescription.rxNumber, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Issue Date', style: AppTextStyles.caption),
                          const SizedBox(height: 2),
                          Text(dateFormat.format(prescription.issuedDate), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Patient & Doctor Information Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Patient: Pranjal Bajaj', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            Text('Blood: O+', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Prescribing Doctor: ${prescription.doctorName}', style: AppTextStyles.bodySmall),
                        Text('Specialty: ${prescription.doctorSpecialty}', style: AppTextStyles.caption),
                        const SizedBox(height: 6),
                        Text('Clinical Diagnosis: ${prescription.diagnosis}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Medications Section
                  const Text('Prescribed Medications & Regimen', style: AppTextStyles.h3),
                  const SizedBox(height: 12),
                  ...prescription.medications.map((m) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  m.name,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  m.dosage,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.primaryDark),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.schedule_rounded, size: 14, color: AppColors.secondary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(m.frequency, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Instructions: ${m.instructions}', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Duration: ${m.duration}', style: AppTextStyles.caption),
                              Text('${m.refillsRemaining} refills left', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 12),

                  // Clinical Advice
                  if (prescription.clinicalNotes.isNotEmpty) ...[
                    const Text('Clinician Directions:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(prescription.clinicalNotes, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 18),
                  ],

                  // Digital Signature Stamp
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Security Seal', style: AppTextStyles.caption),
                          Text('Digitally Verified & Encrypted', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            prescription.doctorName,
                            style: const TextStyle(fontFamily: 'serif', fontStyle: FontStyle.italic, fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          const Text('Digital Signature • Reg #MD-9042', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Refill Action
            if (prescription.status == PrescriptionStatus.active)
              CustomButton(
                text: 'Order Refill from Partner Pharmacy',
                icon: Icons.local_pharmacy_rounded,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  controller.requestRefill(prescription);
                  Get.back();
                },
              ),
          ],
        ),
      ),
    );
  }
}
