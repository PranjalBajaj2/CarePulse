import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Patient Health Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: AppColors.primaryLight,
                      child: const Icon(Icons.person, color: AppColors.primary, size: 38),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: AppTextStyles.h2),
                          const SizedBox(height: 2),
                          Text(user.email, style: AppTextStyles.bodySmall),
                          const SizedBox(height: 2),
                          Text(user.phone, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Medical Passport Card (Blood group, allergies, etc.)
              const Text('Medical Passport', style: AppTextStyles.h3),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildMedicalRow(Icons.bloodtype_rounded, 'Blood Group', user.bloodGroup, AppColors.danger),
                    const Divider(height: 20),
                    _buildMedicalRow(Icons.cake_rounded, 'Date of Birth', user.dateOfBirth, AppColors.primary),
                    const Divider(height: 20),
                    _buildMedicalRow(
                      Icons.warning_amber_rounded,
                      'Known Allergies',
                      user.allergies.join(', '),
                      AppColors.warning,
                    ),
                    const Divider(height: 20),
                    _buildMedicalRow(
                      Icons.contact_phone_rounded,
                      'Emergency Contact',
                      user.emergencyContact,
                      AppColors.secondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Security & Privacy Settings
              const Text('Security & Privacy', style: AppTextStyles.h3),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.fingerprint_rounded, color: AppColors.primary, size: 20),
                      ),
                      title: const Text('Biometric Authentication', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text('Face ID / Fingerprint fast login', style: TextStyle(fontSize: 12)),
                      value: user.isBiometricsEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (val) => controller.toggleBiometrics(val),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.successLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified_user_rounded, color: AppColors.success, size: 20),
                      ),
                      title: const Text('HIPAA & GDPR Privacy Compliance', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text('Data encrypted at rest and in transit', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => controller.logout(),
                  icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
                  label: const Text('Sign Out of CarePulse', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.dangerLight, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMedicalRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}
