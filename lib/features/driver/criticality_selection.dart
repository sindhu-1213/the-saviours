import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../mock_data/mock_emergency_database.dart';

class CriticalitySelection extends StatefulWidget {
  const CriticalitySelection({super.key});

  @override
  State<CriticalitySelection> createState() => _CriticalitySelectionState();
}

class _CriticalitySelectionState extends State<CriticalitySelection> {
  IncidentCriticality _selected = IncidentCriticality.critical;

  final List<Map<String, dynamic>> _levels = [
    {
      'level': IncidentCriticality.critical,
      'title': 'Critical (Code Red)',
      'desc': 'Life-threatening trauma, cardiac arrest, or severe hemorrhage. Forces highest Green Corridor priority.',
      'color': AppColors.emergencyRed,
    },
    {
      'level': IncidentCriticality.high,
      'title': 'High (Code Yellow)',
      'desc': 'Multiple fractures, head injuries, unconscious victim. Immediate junction pre-clearance.',
      'color': AppColors.warningOrange,
    },
    {
      'level': IncidentCriticality.medium,
      'title': 'Medium (Code Orange)',
      'desc': 'Moderate injuries, stable vitals. Standard emergency priority routing.',
      'color': AppColors.infoBlue,
    },
    {
      'level': IncidentCriticality.low,
      'title': 'Low (Code Green)',
      'desc': 'Minor lacerations, patient conscious. Standard ambulance transit.',
      'color': AppColors.primaryGreen,
    },
  ];

  void _startNavigation() {
    final incidentState = context.read<IncidentState>();
    incidentState.setIncidentCriticality(_selected);

    Navigator.pushReplacementNamed(context, AppRoutes.driverNavCycle1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Triage & Criticality'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Emergency Severity', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'This selection directly governs traffic priority and Green Corridor siren requests.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.separated(
                  itemCount: _levels.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _levels[index];
                    final level = item['level'] as IncidentCriticality;
                    final isSelected = _selected == level;
                    final color = item['color'] as Color;

                    return InkWell(
                      onTap: () => setState(() => _selected = level),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(alpha: 0.12)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? color : AppColors.divider,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] as String,
                                    style: AppTypography.titleMedium.copyWith(
                                      color: isSelected ? color : Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['desc'] as String,
                                    style: AppTypography.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? color : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? color : AppColors.textSecondary,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Center(
                                      child: Icon(Icons.check, size: 14, color: Colors.black),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              CustomButton(
                text: 'LAUNCH CYCLE 1 LIVE NAVIGATION',
                icon: Icons.navigation_rounded,
                variant: ButtonVariant.primary,
                onPressed: _startNavigation,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
