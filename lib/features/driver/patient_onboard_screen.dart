import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';

class PatientOnboardScreen extends StatelessWidget {
  const PatientOnboardScreen({super.key});

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
                  color: AppColors.primaryGreen.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.primaryGreen, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.airline_seat_flat_rounded,
                    size: 56,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              StatusPill.verified(label: 'PHASE 2 COMPLETE • PATIENT SECURED'),

              const SizedBox(height: 16),

              Text(
                'Patient Onboard',
                style: AppTypography.displayMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Pickup timestamp has been recorded into the system audit trail. Phase 3 hospital routing engine is ready.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildCheck('Pickup timestamp synchronized with Control Room', true),
                    const Divider(color: AppColors.divider, height: 18),
                    _buildCheck('Patient vitals stabilized in ambulance unit', true),
                    const Divider(color: AppColors.divider, height: 18),
                    _buildCheck('Hospital beds & trauma capacity ranked by AI', true),
                  ],
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'OPEN HOSPITAL SUGGESTION ENGINE',
                icon: Icons.local_hospital_rounded,
                height: 56,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.driverHospitalSuggestion,
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

  Widget _buildCheck(String text, bool isDone) {
    return Row(
      children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 18),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTypography.bodyMedium)),
      ],
    );
  }
}
