import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class ClearanceHistory extends StatelessWidget {
  const ClearanceHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final clearances = MockEmergencyDatabase.sampleClearances;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Junction Clearance History'),
      ),
      body: SafeArea(
        child: clearances.isEmpty
            ? Center(child: Text('No previous clearances logged.', style: AppTypography.bodyMedium))
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                itemCount: clearances.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final clr = clearances[index];
                  final timeStr = DateFormat('MMM dd, yyyy • hh:mm a').format(clr.clearedAt);

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(clr.id, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                            StatusPill.cleared(label: 'CLEARED IN ${clr.secondsToClear}S'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(clr.junctionName, style: AppTypography.titleLarge.copyWith(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('Incident Ref: ${clr.incidentId} • ${clr.congestionLevel}', style: AppTypography.bodyMedium),
                        const Divider(color: AppColors.divider, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(timeStr, style: AppTypography.caption),
                            Text('Officer: ${clr.officerName}', style: AppTypography.caption.copyWith(color: AppColors.corridorGreen)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
