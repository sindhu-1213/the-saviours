import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class AllIncidentsScreen extends StatefulWidget {
  const AllIncidentsScreen({super.key});

  @override
  State<AllIncidentsScreen> createState() => _AllIncidentsScreenState();
}

class _AllIncidentsScreenState extends State<AllIncidentsScreen> {
  String _selectedFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    var incidents = incidentState.incidents;

    if (_selectedFilter == 'ACTIVE') {
      incidents = incidents.where((i) => i.status != IncidentStatus.completed).toList();
    } else if (_selectedFilter == 'COMPLETED') {
      incidents = incidents.where((i) => i.status == IncidentStatus.completed).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Master Incidents Registry'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['ALL', 'ACTIVE', 'COMPLETED'].map((f) {
                    final isSel = _selectedFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSel,
                        label: Text(f, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.primaryGreen,
                        labelStyle: TextStyle(color: isSel ? Colors.black : Colors.white),
                        side: const BorderSide(color: AppColors.divider),
                        onSelected: (_) => setState(() => _selectedFilter = f),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: incidents.isEmpty
                    ? Center(child: Text('No incidents recorded.', style: AppTypography.bodyMedium))
                    : ListView.separated(
                        itemCount: incidents.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final inc = incidents[index];
                          final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(inc.createdAt);

                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.adminIncidentAuditTrail);
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
                                      Text(inc.id, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                                      StatusPill(
                                        label: inc.status.name.toUpperCase(),
                                        color: inc.status == IncidentStatus.completed
                                            ? AppColors.primaryGreen
                                            : AppColors.emergencyRed,
                                        textColor: inc.status == IncidentStatus.completed ? Colors.black : Colors.white,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(inc.locationName, style: AppTypography.bodyLarge),
                                  const SizedBox(height: 4),
                                  Text('Reported by: ${inc.reporterName} • Pilot: ${inc.assignedDriverName ?? "Dispatched"}', style: AppTypography.caption),
                                  const Divider(color: AppColors.divider, height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formattedDate, style: AppTypography.caption),
                                      Text('View Full Audit Trail →', style: AppTypography.caption.copyWith(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
