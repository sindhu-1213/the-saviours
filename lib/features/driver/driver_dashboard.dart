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

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;
    final isOnDuty = incidentState.isDriverOnDuty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilot ${auth.currentUser?.name.split(' ').first ?? 'Rajesh'}',
              style: AppTypography.titleMedium.copyWith(fontSize: 18),
            ),
            Text(
              'Ambulance Unit ${auth.currentUser?.vehicleNumber ?? "KA-01-EA-108"}',
              style: AppTypography.caption,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.driverNotifications);
            },
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
            // On-Duty / Off-Duty Toggle Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isOnDuty ? AppColors.surfaceElevated : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isOnDuty ? AppColors.primaryGreen.withValues(alpha: 0.5) : AppColors.divider,
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
                          ? AppColors.primaryGreen.withValues(alpha: 0.2)
                          : AppColors.surfaceHighlight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isOnDuty ? Icons.local_hospital_rounded : Icons.pause_circle_outline,
                      color: isOnDuty ? AppColors.primaryGreen : AppColors.textSecondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOnDuty ? 'ON-DUTY (READY FOR DISPATCH)' : 'OFF-DUTY (STANDBY)',
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 14,
                            color: isOnDuty ? AppColors.primaryGreen : AppColors.textSecondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isOnDuty
                              ? 'Broadcasting live GPS to Saviours Dispatch Engine'
                              : 'Ambulance status is currently offline',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isOnDuty,
                    activeThumbColor: AppColors.primaryGreen,
                    onChanged: (val) {
                      incidentState.toggleDriverDuty();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Active Dispatch / Trip Card
            if (active != null && active.status != IncidentStatus.completed) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CURRENT DISPATCH MISSION', style: AppTypography.caption),
                  StatusPill.critical(label: active.status.name.toUpperCase()),
                ],
              ),
              const SizedBox(height: 10),
              SpotifyHeroCard(
                title: 'Incident #${active.id}',
                subtitle: active.locationName,
                icon: Icons.emergency_rounded,
                iconBgColor: AppColors.emergencyRed,
                badgeText: 'CRITICAL PRIORITY',
                badgeColor: AppColors.emergencyRed,
                footerText: 'Cycle 1 Navigation Active • Tap for Live Turn-by-Turn',
                onTap: () {
                  if (active.status == IncidentStatus.driverDispatched) {
                    Navigator.pushNamed(context, AppRoutes.driverNavCycle1);
                  } else if (active.status == IncidentStatus.patientOnboard) {
                    Navigator.pushNamed(context, AppRoutes.driverHospitalSuggestion);
                  } else if (active.status == IncidentStatus.hospitalTransport) {
                    Navigator.pushNamed(context, AppRoutes.driverNavCycle2);
                  }
                },
              ),
              const SizedBox(height: 24),
            ] else ...[
              // Simulation Trigger for incoming alert
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.flash_on, color: AppColors.warningOrange, size: 20),
                        const SizedBox(width: 8),
                        Text('DISPATCH SIMULATOR', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Trigger a simulated emergency dispatch assignment alert to test the ambulance navigation workflow.',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    CustomButton(
                      text: 'SIMULATE INCOMING DISPATCH ALERT',
                      icon: Icons.add_alert_rounded,
                      variant: ButtonVariant.emergency,
                      height: 48,
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.driverAssignmentAlert);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Pilot Performance Overview
            Text("TODAY'S SHIFT METRICS", style: AppTypography.caption),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatTile('TRIPS TODAY', '4', 'All saved', Icons.check_circle_outline, AppColors.primaryGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatTile('AVG RESPONSE', '6.8m', 'Below 8m SLA', Icons.timer_outlined, AppColors.infoBlue),
                ),
              ],
            ),
            const SizedBox(width: 12),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatTile('JUNCTIONS CLEARED', '14', 'Green Corridor', Icons.traffic, AppColors.corridorGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatTile('DISTANCE LOG', '24.2km', 'Indiranagar Zone', Icons.route_outlined, AppColors.warningOrange),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Past Trips Quick Link
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RECENT COMPLETED TRIPS', style: AppTypography.caption),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.driverTripHistory);
                  },
                  child: Text(
                    'VIEW ALL',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...MockEmergencyDatabase.samplePastTrips.take(2).map((trip) {
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
                        child: const Icon(Icons.local_hospital_rounded, color: AppColors.primaryGreen, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(trip.hospitalName, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                            const SizedBox(height: 2),
                            Text('${trip.location} • ${trip.totalMinutes} mins', style: AppTypography.caption),
                          ],
                        ),
                      ),
                      StatusPill.verified(label: trip.status.split(' ').first),
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
              Navigator.pushNamed(context, AppRoutes.driverTripHistory);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.driverAnalytics);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.driverProfile);
              break;
          }
        },
        items: const [
          BottomBarItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded, label: 'Dashboard'),
          BottomBarItem(icon: Icons.history_outlined, activeIcon: Icons.history_rounded, label: 'Trips'),
          BottomBarItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart_rounded, label: 'Performance'),
          BottomBarItem(icon: Icons.person_outline, activeIcon: Icons.person_rounded, label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildStatTile(String title, String val, String sub, IconData icon, Color color) {
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
          Text(title, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(sub, style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
