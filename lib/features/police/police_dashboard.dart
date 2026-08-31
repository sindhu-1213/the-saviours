import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/app_bottom_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/role_switcher_sheet.dart';
import '../../core/widgets/spotify_hero_card.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class PoliceDashboard extends StatefulWidget {
  const PoliceDashboard({super.key});

  @override
  State<PoliceDashboard> createState() => _PoliceDashboardState();
}

class _PoliceDashboardState extends State<PoliceDashboard> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;
    final isOnDuty = incidentState.isPoliceOnDuty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Officer ${auth.currentUser?.name.split(' ').first ?? 'Vikram'}',
              style: AppTypography.titleMedium.copyWith(fontSize: 18),
            ),
            Text(
              'Badge #${auth.currentUser?.badgeNumber ?? "TP-BLR-502"} • Central Traffic Division',
              style: AppTypography.caption,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.policeNotifications),
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.primaryGreen),
            tooltip: 'Switch Role',
            onPressed: () => RoleSwitcherSheet.show(context),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Duty Status Toggle Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isOnDuty ? AppColors.surfaceElevated : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isOnDuty ? AppColors.corridorGreen.withValues(alpha: 0.5) : AppColors.divider,
                  width: isOnDuty ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isOnDuty
                          ? AppColors.corridorGreen.withValues(alpha: 0.2)
                          : AppColors.surfaceHighlight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.traffic_rounded,
                      color: isOnDuty ? AppColors.corridorGreen : AppColors.textSecondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOnDuty ? 'ON-DUTY (GEO-FENCE RADAR ACTIVE)' : 'OFF-DUTY',
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 14,
                            color: isOnDuty ? AppColors.corridorGreen : AppColors.textSecondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Assigned: MG Road - Trinity Circle - Domlur Flyover',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isOnDuty,
                    activeThumbColor: AppColors.corridorGreen,
                    onChanged: (val) => incidentState.togglePoliceDuty(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Approaching Ambulance / Green Corridor Action Card
            if (active != null && active.status != IncidentStatus.completed) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('APPROACHING EMERGENCY VEHICLE', style: AppTypography.caption),
                  StatusPill.cleared(
                    label: incidentState.isGreenCorridorActive
                        ? 'CORRIDOR CLEARED'
                        : 'CLEARANCE REQUIRED',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SpotifyHeroCard(
                title: 'Ambulance ${active.assignedVehicle ?? "KA-01-EA-108"}',
                subtitle: 'Approaching Trinity Circle Signal • ETA ~ ${incidentState.estimatedArrivalMinutes} mins',
                icon: Icons.traffic_rounded,
                iconBgColor: incidentState.isGreenCorridorActive ? AppColors.corridorGreen : AppColors.warningOrange,
                badgeText: '${incidentState.estimatedArrivalMinutes} MINS',
                badgeColor: AppColors.corridorGreen,
                footerText: incidentState.isGreenCorridorActive
                    ? 'Junction Cleared Green • Tap to review clearance log'
                    : 'Action Required: Tap to open "Traffic Cleared" console',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.policeTrafficClearance);
                },
              ),
              const SizedBox(height: 24),
            ],

            // Traffic Radar Live Preview
            Text('LIVE RADAR OVERVIEW', style: AppTypography.caption),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('1 ACTIVE EMERGENCY IN JURISDICTION', style: AppTypography.titleMedium.copyWith(fontSize: 13)),
                        ],
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.policeLiveMap),
                        child: const Text('OPEN FULL MAP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  CustomButton(
                    text: 'OPEN "TRAFFIC CLEARED" ACTION CONSOLE',
                    icon: Icons.traffic_rounded,
                    variant: ButtonVariant.primary,
                    height: 52,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.policeTrafficClearance);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Performance Stats
            Text('OFFICER CLEARANCE STATS', style: AppTypography.caption),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStat('JUNCTIONS CLEARED', '19', 'This week', Icons.check_circle_outline, AppColors.corridorGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStat('AVG CLEARANCE TIME', '38s', 'Well under 60s', Icons.timer, AppColors.infoBlue),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Clearance History Link
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RECENT JUNCTIONS CLEARED', style: AppTypography.caption),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.policeClearanceHistory),
                  child: Text(
                    'VIEW LOG',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...MockEmergencyDatabase.sampleClearances.take(2).map((clr) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.traffic_rounded, color: AppColors.corridorGreen, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(clr.junctionName, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                            const SizedBox(height: 2),
                            Text('Cleared in ${clr.secondsToClear}s • ${clr.congestionLevel}', style: AppTypography.caption),
                          ],
                        ),
                      ),
                      StatusPill.cleared(label: 'CLEARED'),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() => _currentTab = index);
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.policeLiveMap);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.policeClearanceHistory);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.policeProfile);
              break;
          }
        },
        items: const [
          BottomBarItem(icon: Icons.traffic_outlined, activeIcon: Icons.traffic_rounded, label: 'Junction'),
          BottomBarItem(icon: Icons.map_outlined, activeIcon: Icons.map_rounded, label: 'Radar'),
          BottomBarItem(icon: Icons.history_outlined, activeIcon: Icons.history_rounded, label: 'History'),
          BottomBarItem(icon: Icons.person_outline, activeIcon: Icons.person_rounded, label: 'Officer'),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String val, String sub, IconData icon, Color color) {
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
}
