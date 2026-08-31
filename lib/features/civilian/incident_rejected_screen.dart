import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';

class IncidentRejectedScreen extends StatelessWidget {
  const IncidentRejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emergencyRed.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.emergencyRed, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 56,
                    color: AppColors.emergencyRed,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              StatusPill.rejected(label: 'REPORT UNVERIFIED • LOW CONFIDENCE'),

              const SizedBox(height: 16),

              Text(
                'Report Not Verified',
                style: AppTypography.displayMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                'The AI vision analysis was unable to confirm a severe road collision scene or the captured image was obstructed. No emergency dispatch has been triggered.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ADVISORY NOTICE', style: AppTypography.caption),
                    const SizedBox(height: 8),
                    Text(
                      'If this is an active emergency requiring immediate assistance, please dial the 108 helpline directly or re-capture a clearer photo of the scene.',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'RE-CAPTURE SCENE',
                icon: Icons.camera_alt_rounded,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.civilianReportCamera);
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'BACK TO HOME DASHBOARD',
                variant: ButtonVariant.outline,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.civilianHome,
                    (r) => false,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
