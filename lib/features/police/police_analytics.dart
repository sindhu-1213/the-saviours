import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class PoliceAnalytics extends StatelessWidget {
  const PoliceAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Traffic Clearance Analytics'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Clearance Efficiency', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Personal performance metrics for Inspector Vikram Rao (Badge #TP-BLR-502).',
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
                        Text('AVG JUNCTION CLEARANCE SPEED', style: AppTypography.caption),
                        const Icon(Icons.timer, color: AppColors.corridorGreen, size: 22),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('36 SECONDS', style: AppTypography.statNumber.copyWith(fontSize: 34, color: AppColors.corridorGreen)),
                    const SizedBox(height: 6),
                    Text(
                      'Well within the 60s emergency standard • 100% ambulance clearance rate',
                      style: AppTypography.caption.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildTile('JUNCTIONS CLEARED', '52', 'MG Rd & Trinity', Icons.traffic_rounded, AppColors.corridorGreen),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTile('CORRIDOR SUCCESS', '98.4%', 'Zero blockage', Icons.check_circle, AppColors.primaryGreen),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTile('INCIDENTS ESCORTED', '38', 'Past 30 days', Icons.local_hospital_rounded, AppColors.infoBlue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTile('TIME SAVED FOR AMBULANCES', '~4.8 hrs', 'Total delay cut', Icons.bolt, AppColors.warningOrange),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Text('HOURLY CLEARANCE DISTRIBUTION', style: AppTypography.caption),
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
                    _buildBar('Morning Peak (08:00 - 11:00)', 18, 52, AppColors.emergencyRed),
                    const SizedBox(height: 14),
                    _buildBar('Evening Peak (17:00 - 21:00)', 24, 52, AppColors.warningOrange),
                    const SizedBox(height: 14),
                    _buildBar('Non-Peak Hours', 10, 52, AppColors.corridorGreen),
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

  Widget _buildBar(String label, int val, int total, Color color) {
    final double ratio = total > 0 ? (val / total) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.titleMedium.copyWith(fontSize: 13)),
            Text('$val clearances', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
