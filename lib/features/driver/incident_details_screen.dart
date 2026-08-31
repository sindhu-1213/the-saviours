import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/live_map_view.dart';
import '../../core/widgets/status_pill.dart';

class IncidentDetailsScreen extends StatelessWidget {
  const IncidentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Mission Details #${active?.id ?? "INC-0819"}'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mini-Map Route Preview
              LiveMapView(
                ambulanceLat: incidentState.ambulanceLat,
                ambulanceLng: incidentState.ambulanceLng,
                destinationName: active?.locationName ?? 'Indiranagar 100ft Rd',
                etaMinutes: 6,
                isGreenCorridor: false,
                height: 220,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('INCIDENT OVERVIEW', style: AppTypography.caption),
                  StatusPill.verified(label: 'AI VALIDATED'),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      active?.locationName ?? '100ft Rd, Indiranagar, Bengaluru',
                      style: AppTypography.titleLarge.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Reported by: ${active?.reporterName ?? "Aarav Sharma"} (${active?.reporterPhone ?? "+91 98765 43210"})',
                      style: AppTypography.bodyMedium,
                    ),
                    const Divider(color: AppColors.divider, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TRAFFIC POSTS ON ROUTE', style: AppTypography.caption),
                        Text('3 Checkpoints Notified', style: AppTypography.caption.copyWith(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text('DISPATCH PROTOCOL', style: AppTypography.caption),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildBullet('Select patient criticality to set Green Corridor traffic priority level.'),
                    const SizedBox(height: 8),
                    _buildBullet('Turn-by-turn voice alerts and corridor polylines will update live.'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'SET CRITICALITY & START NAVIGATION',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.driverCriticalitySelection);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.primaryGreen, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTypography.bodyMedium)),
      ],
    );
  }
}
