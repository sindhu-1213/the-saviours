import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class ActiveIncidentsList extends StatelessWidget {
  const ActiveIncidentsList({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final activeIncidents = incidentState.incidents.where((i) => i.status != IncidentStatus.completed).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Jurisdiction Emergency Feed'),
      ),
      body: SafeArea(
        child: activeIncidents.isEmpty
            ? Center(child: Text('No active incidents currently.', style: AppTypography.bodyMedium))
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                itemCount: activeIncidents.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final inc = activeIncidents[index];

                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.policeAssignedJunction);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
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
                              Text(inc.id, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                              StatusPill.critical(label: inc.status.name.toUpperCase()),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(inc.locationName, style: AppTypography.bodyLarge),
                          const Divider(color: AppColors.divider, height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Unit: ${inc.assignedVehicle ?? "KA-01-EA-108"}', style: AppTypography.caption),
                              Text('Tap to coordinate clearance →', style: AppTypography.caption.copyWith(color: AppColors.primaryGreen)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
