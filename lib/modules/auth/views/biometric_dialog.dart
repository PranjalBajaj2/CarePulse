import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class BiometricDialog extends StatefulWidget {
  final Future<bool> Function() onAuthenticate;
  final VoidCallback onSuccess;

  const BiometricDialog({
    super.key,
    required this.onAuthenticate,
    required this.onSuccess,
  });

  @override
  State<BiometricDialog> createState() => _BiometricDialogState();
}

class _BiometricDialogState extends State<BiometricDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _isVerifying = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _triggerAuth();
  }

  void _triggerAuth() async {
    setState(() => _isVerifying = true);
    final success = await widget.onAuthenticate();
    if (mounted) {
      if (success) {
        setState(() {
          _isVerifying = false;
          _isSuccess = true;
        });
        await Future.delayed(const Duration(milliseconds: 400));
        Get.back();
        widget.onSuccess();
      } else {
        setState(() => _isVerifying = false);
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isSuccess
                    ? AppColors.successLight
                    : AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: _isSuccess
                  ? const Icon(Icons.check_circle_rounded, size: 54, color: AppColors.success)
                  : AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.95 + (_animController.value * 0.1),
                          child: const Icon(
                            Icons.fingerprint_rounded,
                            size: 54,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              _isSuccess ? 'Identity Verified' : 'Biometric Security',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 8),
            Text(
              _isSuccess
                  ? 'Access granted to encrypted patient health portal.'
                  : 'Scan fingerprint or Face ID to securely log in to CarePulse.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            if (!_isSuccess) ...[
              if (_isVerifying)
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              else
                TextButton(
                  onPressed: _triggerAuth,
                  child: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Use Password Instead', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
