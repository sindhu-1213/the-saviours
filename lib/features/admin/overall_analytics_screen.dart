import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';

class OverallAnalyticsScreen extends StatelessWidget {
  const OverallAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Phase 4 System-Wide Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Export Reports',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.adminReportsExport),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('System-Wide Performance', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Aggregated emergency response time, green corridor efficiency, and AI verification metrics across all zones.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),

              // KPI Row
              Row(
                children: [
                  Expanded(
                    child: _buildKpiCard('AVG RESPONSE TIME', '6.2 MINS', '-42% vs baseline', AppColors.primaryGreen),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildKpiCard('AI ACCURACY', '96.8%', 'Gemini Vision', AppColors.infoBlue),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildKpiCard('GREEN CORRIDOR RATE', '97.2%', 'Signals cleared', AppColors.corridorGreen),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildKpiCard('TIME SAVED PER TRIP', '8.6 MINS', 'Congestion cut', AppColors.warningOrange),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Zone-wise Emergency Frequency Distribution
              Text('ZONE-WISE EMERGENCY INCIDENCE', style: AppTypography.caption),
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
                    _buildZoneRow('Zone 1: Indiranagar - HAL Corridor', 42, 110, AppColors.emergencyRed),
                    const SizedBox(height: 14),
                    _buildZoneRow('Zone 2: MG Road - Trinity - Domlur', 34, 110, AppColors.warningOrange),
                    const SizedBox(height: 14),
                    _buildZoneRow('Zone 3: Koramangala 80ft Arterial', 22, 110, AppColors.infoBlue),
                    const SizedBox(height: 14),
                    _buildZoneRow('Zone 4: Outer Ring Road Bellandur', 12, 110, AppColors.corridorGreen),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Hospital Emergency Bed Utilization
              Text('HOSPITAL TRAUMA LOAD DISTRIBUTION', style: AppTypography.caption),
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
                    _buildHospitalLoad('Apollo Speciality Hospital', '18/24 Beds Free', 0.75, AppColors.primaryGreen),
                    const SizedBox(height: 14),
                    _buildHospitalLoad('Manipal Hospital HAL', '12/16 Beds Free', 0.65, AppColors.infoBlue),
                    const SizedBox(height: 14),
                    _buildHospitalLoad('St. John’s Medical Center', '24/30 Beds Free', 0.80, AppColors.corridorGreen),
                    const SizedBox(height: 14),
                    _buildHospitalLoad('Fortis Hospital Richmond Rd', '4/10 Beds Free (Near Cap)', 0.40, AppColors.emergencyRed),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'EXPORT FULL SYSTEM AUDIT REPORT',
                icon: Icons.download_rounded,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.adminReportsExport),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String val, String sub, Color color) {
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
          Text(val, style: AppTypography.statNumber.copyWith(fontSize: 22, color: color)),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(sub, style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildZoneRow(String name, int incidents, int total, Color color) {
    final double ratio = total > 0 ? (incidents / total) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: AppTypography.titleMedium.copyWith(fontSize: 13)),
            Text('$incidents Incidents', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
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

  Widget _buildHospitalLoad(String name, String beds, double freeRatio, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: AppTypography.titleMedium.copyWith(fontSize: 13)),
            Text(beds, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: freeRatio,
            minHeight: 8,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
