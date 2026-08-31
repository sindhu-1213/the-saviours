import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';

class TripSummaryScreen extends StatelessWidget {
  const TripSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mission Trip Summary'),
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
                  Text('INCIDENT #${active?.id ?? "INC-0819"}', style: AppTypography.caption),
                  StatusPill.verified(label: 'COMPLETED'),
                ],
              ),
              const SizedBox(height: 10),

              Text('Emergency Run Recap', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Full mission analytics from civilian alert to hospital trauma delivery.',
                style: AppTypography.bodyMedium,
              ),

              const SizedBox(height: 24),

              // Hero Stat Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.corridorGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Icon(Icons.flash_on_rounded, color: AppColors.corridorGreen, size: 30),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('8.4 MINUTES SAVED', style: AppTypography.statNumber.copyWith(fontSize: 22, color: Colors.black)),
                          const SizedBox(height: 2),
                          Text(
                            'Green Corridor cut transit time by 48% vs typical Bangalore traffic.',
                            style: AppTypography.caption.copyWith(color: Colors.black87, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2x2 Metric Grid
              Row(
                children: [
                  Expanded(
                    child: _buildMetric('TOTAL MISSION TIME', '14 Mins', Icons.timer, AppColors.infoBlue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetric('TOTAL DISTANCE', '5.2 Km', Icons.route, AppColors.primaryGreen),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetric('JUNCTIONS CLEARED', '4 Signals', Icons.traffic, AppColors.corridorGreen),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetric('AVG CORRIDOR SPEED', '54 Km/h', Icons.speed, AppColors.warningOrange),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Mission Route Overview
              Text('ROUTE CHECKPOINTS', style: AppTypography.caption),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildPointRow('Start Base', 'Indiranagar Fire & Ambulance Depot', true),
                    const Divider(color: AppColors.divider, height: 18),
                    _buildPointRow('Incident Spot', active?.locationName ?? '100ft Rd, Indiranagar', true),
                    const Divider(color: AppColors.divider, height: 18),
                    _buildPointRow('Delivery Hospital', active?.assignedHospitalName ?? 'Apollo Speciality Hospital', true),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'RETURN TO ON-DUTY DASHBOARD',
                icon: Icons.check_circle_rounded,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.driverHome,
                    (r) => false,
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(val, style: AppTypography.statNumber.copyWith(fontSize: 22)),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildPointRow(String type, String name, bool isDone) {
    return Row(
      children: [
        Icon(Icons.check_circle, size: 16, color: AppColors.primaryGreen),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type, style: AppTypography.caption.copyWith(fontSize: 10)),
              Text(name, style: AppTypography.titleMedium.copyWith(fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}
