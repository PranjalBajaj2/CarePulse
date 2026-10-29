import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/models/appointment_model.dart';
import '../../navigation/controllers/nav_controller.dart';
import '../controllers/appointments_controller.dart';
import 'appointment_detail_view.dart';

class AppointmentsListView extends GetView<AppointmentsController> {
  const AppointmentsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Appointments'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            children: [
              _buildAppointmentList(controller.upcomingAppointments, isUpcoming: true),
              _buildAppointmentList(controller.pastAppointments, isPast: true),
              _buildAppointmentList(controller.cancelledAppointments, isCancelled: true),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAppointmentList(
    List<AppointmentModel> list, {
    bool isUpcoming = false,
    bool isPast = false,
    bool isCancelled = false,
  }) {
    if (list.isEmpty) {
      return EmptyState(
        icon: Icons.event_busy_rounded,
        title: isUpcoming
            ? 'No Upcoming Appointments'
            : isPast
                ? 'No Past Consultations'
                : 'No Cancelled Appointments',
        description: isUpcoming
            ? 'You do not have any scheduled appointments. Find a doctor to book your next consultation.'
            : 'Your past medical appointment records will appear here.',
        actionText: isUpcoming ? 'Find a Specialist' : null,
        onAction: isUpcoming ? () => Get.find<NavigationController>().changeTab(1) : null,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final apt = list[index];
        final dateFormat = DateFormat('EEE, MMM d, yyyy');
        final dateStr = '${dateFormat.format(apt.appointmentDate)} at ${apt.timeSlot}';

        Color badgeBg = AppColors.primaryLight;
        Color badgeFg = AppColors.primaryDark;
        String statusLabel = 'Upcoming';

        if (apt.status == AppointmentStatus.completed) {
          badgeBg = AppColors.successLight;
          badgeFg = AppColors.success;
          statusLabel = 'Completed';
        } else if (apt.status == AppointmentStatus.cancelled) {
          badgeBg = AppColors.dangerLight;
          badgeFg = AppColors.danger;
          statusLabel = 'Cancelled';
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: badgeFg),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        apt.type == ConsultationType.video ? Icons.videocam_rounded : Icons.local_hospital_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        apt.type == ConsultationType.video ? 'Video Telehealth' : 'In-Clinic',
                        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      apt.doctorName.split(' ').length > 1
                          ? '${apt.doctorName.split(' ')[0][0]}${apt.doctorName.split(' ')[1][0]}'
                          : 'Dr',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(apt.doctorName, style: AppTextStyles.h3),
                        const SizedBox(height: 2),
                        Text('${apt.doctorSpecialty} • ${apt.doctorHospital}', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(dateStr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (isUpcoming) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => controller.cancelAppointment(apt.id),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Cancel Visit', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => AppointmentDetailView(appointment: apt));
                        },
                        icon: const Icon(Icons.videocam_rounded, size: 16),
                        label: const Text('Join Room', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Get.to(() => AppointmentDetailView(appointment: apt));
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('View Summary', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
