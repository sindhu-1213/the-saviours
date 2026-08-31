import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class CivilianAnalytics extends StatelessWidget {
  const CivilianAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Reporting Impact'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Contribution', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Personal statistics on accidents reported and verified emergency responses.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Hero Metric Card
              Container(
                width: double.infinity,
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
                        Text('VERIFICATION SUCCESS RATE', style: AppTypography.caption),
                        const Icon(Icons.verified, color: AppColors.primaryGreen, size: 20),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('94.8%', style: AppTypography.statNumber.copyWith(fontSize: 36, color: AppColors.primaryGreen)),
                    const SizedBox(height: 6),
                    Text(
                      'High AI credibility rating • 0 false reports flagged',
                      style: AppTypography.caption.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2x2 Metric Grid
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      'TOTAL REPORTS',
                      '12',
                      'Accidents submitted',
                      Icons.camera_alt_outlined,
                      AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      'LIVES ASSISTED',
                      '11',
                      'Timely hospitalization',
                      Icons.favorite_rounded,
                      AppColors.emergencyRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      'AVG AI SCAN',
                      '1.8s',
                      'Gemini Vision check',
                      Icons.speed_rounded,
                      AppColors.infoBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      'AVG DISPATCH',
                      '42s',
                      'Ambulance assignment',
                      Icons.bolt_rounded,
                      AppColors.warningOrange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Response Breakdown
              Text('OUTCOME BREAKDOWN', style: AppTypography.caption),
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
                    _buildBarRow('Verified & Dispatched', 11, 12, AppColors.primaryGreen),
                    const SizedBox(height: 16),
                    _buildBarRow('Referred via 108 Direct Call', 1, 12, AppColors.infoBlue),
                    const SizedBox(height: 16),
                    _buildBarRow('Unverified / Duplicate', 0, 12, AppColors.emergencyRed),
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

  Widget _buildMetricTile(String title, String value, String sub, IconData icon, Color color) {
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
          Text(value, style: AppTypography.statNumber.copyWith(fontSize: 24)),
          const SizedBox(height: 2),
          Text(title, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(sub, style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildBarRow(String label, int count, int total, Color color) {
    final double ratio = total > 0 ? (count / total) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.titleMedium.copyWith(fontSize: 13)),
            Text('$count reports', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
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
