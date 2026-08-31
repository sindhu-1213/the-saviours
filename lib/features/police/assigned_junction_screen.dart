import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';

class AssignedJunctionScreen extends StatelessWidget {
  const AssignedJunctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assigned Junction (Geo-fenced)'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('GEO-FENCE RADIUS: 500M', style: AppTypography.caption),
                  StatusPill.critical(label: 'ALERT TRIGGERED'),
                ],
              ),
              const SizedBox(height: 10),

              Text('Trinity Circle - MG Road', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Ambulance KA-01-EA-108 has entered your jurisdiction zone.',
                style: AppTypography.bodyMedium,
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildRow('Incident Reference', active?.id ?? 'INC-2026-0819'),
                    const Divider(color: AppColors.divider, height: 18),
                    _buildRow('Approaching Vehicle', active?.assignedVehicle ?? 'Ambulance KA-01-EA-108'),
                    const Divider(color: AppColors.divider, height: 18),
                    _buildRow('ETA to Junction', '~ ${incidentState.estimatedArrivalMinutes} Minutes'),
                    const Divider(color: AppColors.divider, height: 18),
                    _buildRow('Criticality Tier', 'Critical (Highest Siren Priority)'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('CLEARANCE PROTOCOL', style: AppTypography.caption),
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
                    _buildBullet('Halt converging traffic from Old Airport Rd & MG Rd.'),
                    const SizedBox(height: 8),
                    _buildBullet('Open middle emergency corridor lane.'),
                    const SizedBox(height: 8),
                    _buildBullet('Press "Traffic Cleared" button to turn ambulance route green.'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'PROCEED TO CLEARANCE CONSOLE',
                icon: Icons.traffic_rounded,
                variant: ButtonVariant.primary,
                height: 54,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.policeTrafficClearance);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.caption),
        Text(val, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.corridorGreen, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTypography.bodyMedium)),
      ],
    );
  }
}
