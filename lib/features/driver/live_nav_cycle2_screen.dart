import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/live_map_view.dart';
import '../../core/widgets/status_pill.dart';

class LiveNavCycle2Screen extends StatelessWidget {
  const LiveNavCycle2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;
    final hospitalName = active?.assignedHospitalName ?? 'Apollo Speciality Hospital';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cycle 2: Route to Hospital'),
        actions: [
          StatusPill.cleared(label: 'GREEN CORRIDOR ACTIVE'),
          const SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Voice Instruction Banner (Corridor Green)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: const Color(0xFF003314),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.corridorGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.straight_rounded,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Continue Straight 1.2km to Emergency Bay',
                          style: AppTypography.titleLarge.copyWith(fontSize: 17),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Dest: $hospitalName • Green Corridor Secured',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.corridorGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Live Navigation Radar
            Expanded(
              child: LiveMapView(
                ambulanceLat: incidentState.ambulanceLat,
                ambulanceLng: incidentState.ambulanceLng,
                destinationName: hospitalName,
                etaMinutes: 4,
                isGreenCorridor: true,
                height: double.infinity,
              ),
            ),

            // In-Vehicle Action Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHUD('4 MIN', 'ETA TO BAY', AppColors.corridorGreen),
                      Container(width: 1, height: 32, color: AppColors.divider),
                      _buildHUD('3.2 KM', 'REMAINING', Colors.white),
                      Container(width: 1, height: 32, color: AppColors.divider),
                      _buildHUD('62 KM/H', 'SPEED', AppColors.infoBlue),
                    ],
                  ),
                  const SizedBox(height: 16),

                  CustomButton(
                    text: 'CONFIRM PATIENT HANDOVER AT EMERGENCY BAY',
                    icon: Icons.local_hospital_rounded,
                    variant: ButtonVariant.primary,
                    height: 56,
                    onPressed: () {
                      incidentState.confirmDropoff();
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.driverDropoffConfirmation,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHUD(String val, String label, Color color) {
    return Column(
      children: [
        Text(val, style: AppTypography.statNumber.copyWith(fontSize: 20, color: color)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
