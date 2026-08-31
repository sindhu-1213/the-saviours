import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  String _selectedFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    var list = incidentState.incidents;

    if (_selectedFilter == 'ACTIVE') {
      list = list.where((i) => i.status != IncidentStatus.completed && i.status != IncidentStatus.rejected).toList();
    } else if (_selectedFilter == 'COMPLETED') {
      list = list.where((i) => i.status == IncidentStatus.completed).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Reported Incidents'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['ALL', 'ACTIVE', 'COMPLETED'].map((f) {
                    final isSelected = _selectedFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(f, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.primaryGreen,
                        labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
                        side: const BorderSide(color: AppColors.divider),
                        onSelected: (_) => setState(() => _selectedFilter = f),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Text('No reports matching selected filter.', style: AppTypography.bodyMedium),
                      )
                    : ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final inc = list[index];
                          final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(inc.createdAt);

                          return InkWell(
                            onTap: () {
                              if (inc.status != IncidentStatus.completed) {
                                Navigator.pushNamed(context, AppRoutes.civilianLiveTracking);
                              }
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
                                      Text(
                                        inc.id,
                                        style: AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                        ),
                                      ),
                                      StatusPill(
                                        label: inc.status.name.toUpperCase(),
                                        color: inc.status == IncidentStatus.completed
                                            ? AppColors.primaryGreen
                                            : AppColors.warningOrange,
                                        textColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.emergencyRed),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          inc.locationName,
                                          style: AppTypography.bodyLarge.copyWith(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(color: AppColors.divider, height: 1),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formattedDate, style: AppTypography.caption),
                                      Row(
                                        children: [
                                          const Icon(Icons.auto_awesome, size: 13, color: AppColors.primaryGreen),
                                          const SizedBox(width: 4),
                                          Text(
                                            'AI Score: ${inc.aiConfidenceScore}%',
                                            style: AppTypography.caption.copyWith(
                                              color: AppColors.primaryGreen,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
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
