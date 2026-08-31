import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class DriverAnalytics extends StatelessWidget {
  const DriverAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pilot Performance Analytics'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Driver Efficiency Metrics', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Personal performance benchmarks scoped to Unit KA-01-EA-108.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Hero Metric
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('AVERAGE RESPONSE TIME', style: AppTypography.caption),
                        const Icon(Icons.bolt, color: AppColors.primaryGreen, size: 22),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('6.4 MINS', style: AppTypography.statNumber.copyWith(fontSize: 34, color: AppColors.primaryGreen)),
                    const SizedBox(height: 6),
                    Text(
                      '1.6 mins faster than national emergency benchmark (8.0m SLA)',
                      style: AppTypography.caption.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildTile('TOTAL MISSIONS', '48', 'Lives transported', Icons.local_hospital_rounded, AppColors.emergencyRed),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTile('GREEN CORRIDOR', '96.2%', 'Signals cleared', Icons.traffic, AppColors.corridorGreen),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTile('AVG PICKUP-TO-HOSPITAL', '11.2m', 'Trauma transit', Icons.timer, AppColors.infoBlue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTile('DISTANCE LOGGED', '284 km', 'Past 30 days', Icons.route, AppColors.warningOrange),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Text('JUNCTION CLEARANCE BENCHMARKS', style: AppTypography.caption),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildRow('Signals Cleared Pre-Arrival', '182 / 190 (95.7%)', AppColors.primaryGreen),
                    const SizedBox(height: 14),
                    _buildRow('Dynamic Rerouting Adherence', '100%', AppColors.infoBlue),
                    const SizedBox(height: 14),
                    _buildRow('Emergency Bed Handoff SLA', '< 3 mins at bay', AppColors.corridorGreen),
                  ],
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(String label, String val, String sub, IconData icon, Color color) {
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
          const SizedBox(height: 10),
          Text(val, style: AppTypography.statNumber.copyWith(fontSize: 22)),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(sub, style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String val, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.bodyMedium.copyWith(color: Colors.white)),
        Text(val, style: AppTypography.titleMedium.copyWith(fontSize: 13, color: color)),
      ],
    );
  }
}
