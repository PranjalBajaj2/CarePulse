import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../data/models/doctor_model.dart';
import '../controllers/doctors_controller.dart';
import 'book_appointment_view.dart';

class DoctorDetailView extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailView({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Doctor Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      doctor.name.split(' ').length > 1
                          ? '${doctor.name.split(' ')[0][0]}${doctor.name.split(' ')[1][0]}'
                          : 'Dr',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(doctor.name, style: AppTextStyles.h2, textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.qualifications,
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doctor.hospital,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Rating', '★ ${doctor.rating}', '${doctor.reviewCount} reviews'),
                      Container(height: 36, width: 1, color: AppColors.border),
                      _buildStatColumn('Experience', '${doctor.experienceYears}+ Yrs', 'Clinical Practice'),
                      Container(height: 36, width: 1, color: AppColors.border),
                      _buildStatColumn('Consultation', '\$${doctor.consultationFee.toStringAsFixed(0)}', 'Per session'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // About Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About Clinician', style: AppTextStyles.h3),
                  const SizedBox(height: 10),
                  Text(
                    doctor.about,
                    style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Availability Overview
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Consultation Schedule', style: AppTextStyles.h3),
                  const SizedBox(height: 12),
                  const Text('Available Days:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: doctor.availableDays.map((day) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          day,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  const Text('Daily Available Slots:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: doctor.availableSlots.map((slot) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          slot,
                          style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // CTA Button
            CustomButton(
              text: 'Book Consultation (\$${doctor.consultationFee.toStringAsFixed(0)})',
              icon: Icons.calendar_month_rounded,
              onPressed: () {
                controller.startBooking(doctor);
                Get.to(() => const BookAppointmentView());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String sub) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }
}
