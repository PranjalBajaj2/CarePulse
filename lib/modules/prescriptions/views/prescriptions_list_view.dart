import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/models/prescription_model.dart';
import '../controllers/prescriptions_controller.dart';
import 'prescription_detail_view.dart';

class PrescriptionsListView extends GetView<PrescriptionsController> {
  const PrescriptionsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final filterOptions = ['All', 'Active', 'Refill Pending'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('E-Prescriptions & Refills'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              height: 38,
              child: Obx(
                () => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filterOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = filterOptions[index];
                    final isSelected = controller.selectedFilter.value == filter;
                    return ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surfaceMuted,
                      showCheckmark: false,
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                      onSelected: (_) => controller.selectedFilter.value = filter,
                    );
                  },
                ),
              ),
            ),
          ),
          const Divider(height: 1),

          // Prescriptions List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final list = controller.filteredPrescriptions;

              if (list.isEmpty) {
                return const EmptyState(
                  icon: Icons.medication_rounded,
                  title: 'No Prescriptions Found',
                  description: 'No active clinical prescriptions found under this filter.',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final rx = list[index];
                  final dateFormat = DateFormat('MMM d, yyyy');

                  Color badgeBg = AppColors.successLight;
                  Color badgeFg = AppColors.success;
                  String statusText = 'ACTIVE';

                  if (rx.status == PrescriptionStatus.refillPending) {
                    badgeBg = AppColors.warningLight;
                    badgeFg = AppColors.warning;
                    statusText = 'REFILL IN PROCESS';
                  } else if (rx.status == PrescriptionStatus.completed) {
                    badgeBg = AppColors.surfaceMuted;
                    badgeFg = AppColors.textMuted;
                    statusText = 'COURSE COMPLETED';
                  }

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              rx.rxNumber,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: badgeFg),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(rx.doctorName, style: AppTextStyles.h3),
                        Text('${rx.doctorSpecialty} • Issued ${dateFormat.format(rx.issuedDate)}', style: AppTextStyles.bodySmall),
                        const SizedBox(height: 12),

                        // Diagnosis
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.assignment_outlined, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Diagnosis: ${rx.diagnosis}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Medications chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: rx.medications.map((m) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.medication_liquid_rounded, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${m.name} (${m.dosage})',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Actions
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Get.to(() => PrescriptionDetailView(prescription: rx));
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textPrimary,
                                  side: const BorderSide(color: AppColors.border),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('View Rx Slip', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              ),
                            ),
                            if (rx.status == PrescriptionStatus.active) ...[
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => controller.requestRefill(rx),
                                  icon: const Icon(Icons.local_pharmacy_rounded, size: 16),
                                  label: const Text('Order Refill', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
