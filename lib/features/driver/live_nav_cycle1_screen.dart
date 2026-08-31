import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/live_map_view.dart';
import '../../core/widgets/status_pill.dart';

class LiveNavCycle1Screen extends StatelessWidget {
  const LiveNavCycle1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;
    final isGreen = incidentState.isGreenCorridorActive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cycle 1: Route to Incident'),
        actions: [
          StatusPill(
            label: isGreen ? 'GREEN CORRIDOR' : 'DISPATCH ROUTE',
            color: isGreen ? AppColors.corridorGreen : AppColors.infoBlue,
            textColor: isGreen ? Colors.black : Colors.white,
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Turn-by-Turn Voice Direction Banner (High Contrast)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: isGreen ? const Color(0xFF003314) : AppColors.surfaceElevated,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isGreen ? AppColors.corridorGreen : AppColors.infoBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.turn_right_rounded,
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
                          'In 250m, Turn Right onto 100ft Rd',
                          style: AppTypography.titleLarge.copyWith(fontSize: 17),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isGreen
                              ? 'Traffic Police cleared MG Rd Junction • Full green'
                              : 'Ambulance GPS broadcasting to upcoming traffic posts',
                          style: AppTypography.caption.copyWith(
                            color: isGreen ? AppColors.corridorGreen : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Navigation Map
            Expanded(
              child: LiveMapView(
                ambulanceLat: incidentState.ambulanceLat,
                ambulanceLng: incidentState.ambulanceLng,
                destinationName: active?.locationName ?? '100ft Rd, Indiranagar',
                etaMinutes: incidentState.estimatedArrivalMinutes,
                isGreenCorridor: isGreen,
                height: double.infinity,
              ),
            ),

            // Bottom In-Vehicle Control HUD
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
                      _buildNavHUDItem('${incidentState.estimatedArrivalMinutes} MIN', 'ETA TO SCENE', AppColors.primaryGreen),
                      Container(width: 1, height: 32, color: AppColors.divider),
                      _buildNavHUDItem('1.8 KM', 'DISTANCE', Colors.white),
                      Container(width: 1, height: 32, color: AppColors.divider),
                      _buildNavHUDItem('58 KM/H', 'CORRIDOR SPEED', AppColors.infoBlue),
                    ],
                  ),
                  const SizedBox(height: 16),

                  CustomButton(
                    text: 'ARRIVED AT SPOT • PATIENT ONBOARD',
                    icon: Icons.person_add_alt_1_rounded,
                    variant: ButtonVariant.emergency,
                    height: 56,
                    onPressed: () {
                      incidentState.confirmPatientOnboard();
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.driverPatientOnboard,
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

  Widget _buildNavHUDItem(String val, String label, Color color) {
    return Column(
      children: [
        Text(val, style: AppTypography.statNumber.copyWith(fontSize: 20, color: color)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
