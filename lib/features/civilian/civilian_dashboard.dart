import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/app_bottom_bar.dart';
import '../../core/widgets/spotify_hero_card.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class CivilianDashboard extends StatefulWidget {
  const CivilianDashboard({super.key});

  @override
  State<CivilianDashboard> createState() => _CivilianDashboardState();
}

class _CivilianDashboardState extends State<CivilianDashboard> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good day, ${auth.currentUser?.name.split(' ').first ?? 'Citizen'}',
              style: AppTypography.titleMedium.copyWith(fontSize: 18),
            ),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text('Saviours Coordinated Network Active', style: AppTypography.caption),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.civilianNotifications);
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prominent Red Emergency SOS / Report Accident Banner
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.emergencyGradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emergencyRed.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.civilianReportCamera);
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    'CAMERA-ONLY CAPTURE',
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                                  duration: 800.ms,
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1.3, 1.3),
                                ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'WITNESSED AN ACCIDENT?',
                          style: AppTypography.displayMedium.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tap to capture live photo. Instant AI verification alerts 108 ambulance & traffic police immediately.',
                          style: AppTypography.bodyLarge.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.emergency_rounded, color: AppColors.emergencyRed, size: 22),
                              const SizedBox(width: 8),
                              Text(
                                'REPORT ACCIDENT NOW',
                                style: AppTypography.button.copyWith(
                                  color: AppColors.emergencyRed,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Active Tracked Incident Hero Card
            if (active != null && active.status != IncidentStatus.completed) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ACTIVE EMERGENCY TRACKING', style: AppTypography.caption),
                  StatusPill.critical(label: active.status.name.toUpperCase()),
                ],
              ),
              const SizedBox(height: 10),
              SpotifyHeroCard(
                title: 'Incident #${active.id}',
                subtitle: active.locationName,
                icon: Icons.local_hospital_rounded,
                iconBgColor: AppColors.primaryGreen,
                badgeText: '${incidentState.estimatedArrivalMinutes} MIN ETA',
                badgeColor: AppColors.primaryGreen,
                footerText: 'Ambulance ${active.assignedVehicle ?? "KA-01-EA-108"} en route • Tap for live tracking',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.civilianLiveTracking);
                },
              ),
              const SizedBox(height: 28),
            ],

            // Quick Helplines
            Text('DIRECT HELPLINES', style: AppTypography.caption),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildHelplineTile('108', 'Ambulance SOS', Icons.medical_services_rounded, Colors.red),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildHelplineTile('112', 'Unified Police', Icons.local_police_rounded, Colors.blue),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildHelplineTile('103', 'Traffic Control', Icons.traffic_rounded, Colors.orange),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Recent Incident Activity / Community Reports
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('YOUR RECENT REPORTS', style: AppTypography.caption),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.civilianMyReports);
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

            if (incidentState.incidents.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Center(
                  child: Text('No accident reports submitted yet.', style: AppTypography.bodyMedium),
                ),
              )
            else
              ...incidentState.incidents.take(3).map((inc) {
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            inc.status == IncidentStatus.completed
                                ? Icons.check_circle_rounded
                                : Icons.warning_amber_rounded,
                            color: inc.status == IncidentStatus.completed
                                ? AppColors.primaryGreen
                                : AppColors.warningOrange,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(inc.id, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                              const SizedBox(height: 2),
                              Text(
                                inc.locationName,
                                style: AppTypography.caption,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
              Navigator.pushNamed(context, AppRoutes.civilianMyReports);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.civilianAnalytics);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.civilianProfile);
              break;
          }
        },
        items: const [
          BottomBarItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
          BottomBarItem(icon: Icons.history_outlined, activeIcon: Icons.history_rounded, label: 'Reports'),
          BottomBarItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart_rounded, label: 'Analytics'),
          BottomBarItem(icon: Icons.person_outline, activeIcon: Icons.person_rounded, label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHelplineTile(String number, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(number, style: AppTypography.statNumber.copyWith(fontSize: 20)),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.caption.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
