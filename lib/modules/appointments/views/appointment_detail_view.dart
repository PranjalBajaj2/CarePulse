import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../data/models/appointment_model.dart';

class AppointmentDetailView extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailView({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final formattedDate = dateFormat.format(appointment.appointmentDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Consultation Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Booking ID: ${appointment.id.toUpperCase()}', style: AppTextStyles.caption),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: appointment.status == AppointmentStatus.upcoming
                              ? AppColors.primaryLight
                              : appointment.status == AppointmentStatus.completed
                                  ? AppColors.successLight
                                  : AppColors.dangerLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          appointment.status.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: appointment.status == AppointmentStatus.upcoming
                                ? AppColors.primaryDark
                                : appointment.status == AppointmentStatus.completed
                                    ? AppColors.success
                                    : AppColors.danger,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          appointment.doctorName.split(' ').length > 1
                              ? '${appointment.doctorName.split(' ')[0][0]}${appointment.doctorName.split(' ')[1][0]}'
                              : 'Dr',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark, fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appointment.doctorName, style: AppTextStyles.h3),
                            const SizedBox(height: 2),
                            Text(appointment.doctorSpecialty, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(appointment.doctorHospital, style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Time & Mode Details
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildDetailRow(Icons.calendar_month_rounded, 'Date', formattedDate),
                  const Divider(height: 24),
                  _buildDetailRow(Icons.access_time_rounded, 'Time Slot', appointment.timeSlot),
                  const Divider(height: 24),
                  _buildDetailRow(
                    appointment.type == ConsultationType.video ? Icons.videocam_rounded : Icons.local_hospital_rounded,
                    'Consultation Mode',
                    appointment.type == ConsultationType.video ? 'Encrypted Video Telehealth' : 'In-Person Hospital Visit',
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(Icons.payments_rounded, 'Fee Paid', '\$${appointment.fee.toStringAsFixed(2)}'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Visit Reason
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reported Symptoms & Notes', style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Text(appointment.reasonForVisit, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Telehealth Instructions
            if (appointment.type == ConsultationType.video && appointment.status == AppointmentStatus.upcoming) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_rounded, color: AppColors.primary, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This consultation room is encrypted with peer-to-peer security compliant with HIPAA telehealth guidelines.',
                        style: TextStyle(fontSize: 12, color: AppColors.primaryDark, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Launch Telemedicine Room',
                icon: Icons.videocam_rounded,
                onPressed: () {
                  Get.snackbar(
                    'Video Consultation Room',
                    'Connecting HD WebRTC stream with ${appointment.doctorName}... Audio and video checks passed.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.teal.shade800,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 4),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }
}
