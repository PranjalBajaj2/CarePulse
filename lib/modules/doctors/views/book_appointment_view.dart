import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../data/models/appointment_model.dart';
import '../controllers/doctors_controller.dart';

class BookAppointmentView extends GetView<DoctorsController> {
  const BookAppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = controller.selectedDoctor.value;
    if (doctor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Appointment')),
        body: const Center(child: Text('No doctor selected')),
      );
    }

    final dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i + 1)));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Schedule Consultation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Doctor Brief
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      doctor.name.split(' ').length > 1
                          ? '${doctor.name.split(' ')[0][0]}${doctor.name.split(' ')[1][0]}'
                          : 'Dr',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctor.name, style: AppTextStyles.h3),
                        const SizedBox(height: 2),
                        Text('${doctor.specialty} • ${doctor.hospital}', style: AppTextStyles.bodySmall),
                        const SizedBox(height: 2),
                        Text(
                          'Fee: \$${doctor.consultationFee.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Consultation Mode Selector
            const Text('Consultation Mode', style: AppTextStyles.h3),
            const SizedBox(height: 10),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _buildTypeOption(
                      title: 'Video Consultation',
                      subtitle: 'Secure HD Telehealth',
                      icon: Icons.videocam_rounded,
                      type: ConsultationType.video,
                      isSelected: controller.selectedConsultationType.value == ConsultationType.video,
                      onTap: () => controller.selectedConsultationType.value = ConsultationType.video,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeOption(
                      title: 'In-Clinic Visit',
                      subtitle: 'Hospital Consultation',
                      icon: Icons.local_hospital_rounded,
                      type: ConsultationType.inClinic,
                      isSelected: controller.selectedConsultationType.value == ConsultationType.inClinic,
                      onTap: () => controller.selectedConsultationType.value = ConsultationType.inClinic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Date Picker (Next 7 days)
            const Text('Select Date', style: AppTextStyles.h3),
            const SizedBox(height: 10),
            SizedBox(
              height: 74,
              child: Obx(
                () => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final d = dates[index];
                    final isSelected = DateFormat('yyyy-MM-dd').format(controller.selectedDate.value) ==
                        DateFormat('yyyy-MM-dd').format(d);

                    return GestureDetector(
                      onTap: () => controller.selectedDate.value = d,
                      child: Container(
                        width: 60,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEE').format(d),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white70 : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('d').format(d),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Time Slots Selection
            const Text('Select Time Slot', style: AppTextStyles.h3),
            const SizedBox(height: 10),
            Obx(
              () => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: doctor.availableSlots.map((slot) {
                  final isSelected = controller.selectedSlot.value == slot;
                  return ChoiceChip(
                    label: Text(
                      slot,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    showCheckmark: false,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    onSelected: (_) => controller.selectedSlot.value = slot,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 22),

            // Reason for Visit Input
            CustomTextField(
              controller: controller.reasonController,
              label: 'Reason for Visit / Symptoms',
              hintText: 'e.g., Routine cardiac follow-up, headache, rash...',
              maxLines: 3,
            ),
            const SizedBox(height: 22),

            // Fee Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Consultation Fee', style: AppTextStyles.bodyMedium),
                      Text('\$${doctor.consultationFee.toStringAsFixed(2)}', style: AppTextStyles.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Telehealth Booking Fee', style: AppTextStyles.bodyMedium),
                      Text('FREE', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Payable', style: AppTextStyles.h3),
                      Text(
                        '\$${doctor.consultationFee.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),

            // Submit Button
            Obx(
              () => CustomButton(
                text: 'Confirm & Book Appointment',
                icon: Icons.check_circle_outline_rounded,
                isLoading: controller.isBooking.value,
                onPressed: () => controller.confirmAppointment(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required ConsultationType type,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 22),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
