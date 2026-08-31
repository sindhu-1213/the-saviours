import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';

class IncidentVerifiedScreen extends StatelessWidget {
  const IncidentVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;
    final incidentId = active?.id ?? 'INC-2026-0819';
    final score = active?.aiConfidenceScore ?? 94;

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
                    Icons.check_circle_rounded,
                    size: 56,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              StatusPill.verified(label: 'AI VERIFIED • CONFIDENCE $score%'),

              const SizedBox(height: 16),

              Text(
                'Incident Verified!',
                style: AppTypography.displayMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Emergency dispatch triggered. The nearest 108 Ambulance and Traffic Police along the corridor have received priority coordinates.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // Incident Details Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('INCIDENT ID', style: AppTypography.caption),
                        Text(
                          incidentId,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.divider, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ASSIGNED VEHICLE', style: AppTypography.caption),
                        Text(
                          active?.assignedVehicle ?? 'Ambulance KA-01-EA-108',
                          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.divider, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ESTIMATED ARRIVAL', style: AppTypography.caption),
                        Text(
                          '~ ${incidentState.estimatedArrivalMinutes} Minutes',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.emergencyRed,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'TRACK AMBULANCE LIVE',
                icon: Icons.navigation_rounded,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.civilianLiveTracking,
                  );
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
