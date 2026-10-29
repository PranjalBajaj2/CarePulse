import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/appointment_model.dart';
import '../../navigation/controllers/nav_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.loadHomeData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: User Greeting & Notification
                Obx(() {
                  final user = controller.user.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primaryLight,
                            child: const Icon(Icons.person, color: AppColors.primary, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                              Text(
                                user?.name ?? 'Patient',
                                style: AppTextStyles.h2,
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Get.snackbar(
                            'Notifications',
                            'No pending critical health alerts.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: AppColors.primaryDark,
                            colorText: Colors.white,
                          );
                        },
                        icon: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 22),
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.danger,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 20),

                // Search Banner
                GestureDetector(
                  onTap: () => navController.changeTab(1), // Go to Doctors tab
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 22),
                        SizedBox(width: 12),
                        Text(
                          'Search doctors, specialties, clinics...',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Upcoming Appointment Banner
                Obx(() {
                  final apt = controller.nextAppointment.value;
                  if (apt == null) return const SizedBox.shrink();

                  final dateFormat = DateFormat('EEE, MMM d • h:mm a');
                  final dateStr = '${dateFormat.format(apt.appointmentDate)} (${apt.timeSlot})';

                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    apt.type == ConsultationType.video
                                        ? Icons.videocam_rounded
                                        : Icons.local_hospital_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    apt.type == ConsultationType.video ? 'Video Consultation' : 'In-Clinic Visit',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'Upcoming',
                              style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          apt.doctorName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${apt.doctorSpecialty} • ${apt.doctorHospital}',
                          style: const TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(dateStr, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.snackbar(
                              'Telemedicine Video Room',
                              'Connecting encrypted HIPAA-compliant consultation session with ${apt.doctorName}...',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.teal.shade800,
                              colorText: Colors.white,
                            );
                          },
                          icon: const Icon(Icons.videocam_rounded, size: 18, color: AppColors.primary),
                          label: const Text('Join Consultation Call', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Quick Services Action Grid
                const SectionHeader(title: 'Clinical Services'),
                Row(
                  children: [
                    _buildServiceTile(
                      icon: Icons.person_search_rounded,
                      label: 'Find Doctor',
                      color: AppColors.primary,
                      onTap: () => navController.changeTab(1),
                    ),
                    const SizedBox(width: 12),
                    _buildServiceTile(
                      icon: Icons.medication_rounded,
                      label: 'Prescriptions',
                      color: AppColors.secondary,
                      onTap: () => navController.changeTab(3),
                    ),
                    const SizedBox(width: 12),
                    _buildServiceTile(
                      icon: Icons.chat_rounded,
                      label: 'Doctor Chat',
                      color: AppColors.info,
                      onTap: () => navController.changeTab(4),
                    ),
                    const SizedBox(width: 12),
                    _buildServiceTile(
                      icon: Icons.event_note_rounded,
                      label: 'Appointments',
                      color: AppColors.warning,
                      onTap: () => navController.changeTab(2),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Health Vitals Overview
                SectionHeader(
                  title: 'Patient Health Vitals',
                  subtitle: 'Continuous health monitoring summary',
                  actionText: 'View All',
                  onAction: () => navController.changeTab(0),
                ),
                Obx(() {
                  final vitals = controller.vitals.value;
                  if (vitals == null) return const SizedBox.shrink();

                  return Row(
                    children: [
                      Expanded(
                        child: _buildVitalCard(
                          title: vitals.heartRate.title,
                          value: vitals.heartRate.value,
                          unit: vitals.heartRate.unit,
                          status: vitals.heartRate.status,
                          icon: Icons.favorite_rounded,
                          color: AppColors.danger,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildVitalCard(
                          title: vitals.bloodPressure.title,
                          value: vitals.bloodPressure.value,
                          unit: vitals.bloodPressure.unit,
                          status: vitals.bloodPressure.status,
                          icon: Icons.speed_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 12),
                Obx(() {
                  final vitals = controller.vitals.value;
                  if (vitals == null) return const SizedBox.shrink();

                  return Row(
                    children: [
                      Expanded(
                        child: _buildVitalCard(
                          title: vitals.bloodGlucose.title,
                          value: vitals.bloodGlucose.value,
                          unit: vitals.bloodGlucose.unit,
                          status: vitals.bloodGlucose.status,
                          icon: Icons.water_drop_rounded,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildVitalCard(
                          title: vitals.oxygenSaturation.title,
                          value: vitals.oxygenSaturation.value,
                          unit: vitals.oxygenSaturation.unit,
                          status: vitals.oxygenSaturation.status,
                          icon: Icons.air_rounded,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVitalCard({
    required String title,
    required String value,
    required String unit,
    required String status,
    required IconData icon,
    required Color color,
  }) {
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.bodySmall),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary)),
              const SizedBox(width: 4),
              Text(unit, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
