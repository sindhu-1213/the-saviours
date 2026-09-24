import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/admin_state.dart';
import '../../core/state/auth_state.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/app_bottom_bar.dart';
import '../../core/widgets/spotify_hero_card.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final adminState = context.watch<AdminState>();
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Control Room Command Center',
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
                Text(
                  'Operator: ${auth.currentUser?.name ?? "Dr. Ananya Sen"}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.adminNotifications),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live System Status Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGreen,
                    ),
                    child: const Center(
                      child: Icon(Icons.security, color: Colors.black, size: 28),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ALL SYSTEMS OPERATIONAL', style: AppTypography.titleMedium.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('Supabase Realtime • Gemini Vision • Google Maps • FCM Active', style: AppTypography.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pending KYC Banner (Clickable)
            if (adminState.pendingKycCount > 0) ...[
              Container(
                decoration: BoxDecoration(
                  color: AppColors.warningOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.warningOrange),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.adminVerificationReview);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.warningOrange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.assignment_ind, color: Colors.black, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${adminState.pendingKycCount} PENDING KYC VERIFICATIONS',
                                  style: AppTypography.titleMedium.copyWith(
                                    fontSize: 13,
                                    color: AppColors.warningOrange,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Review uploaded identity documents & AI fraud flags',
                                  style: AppTypography.caption,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.warningOrange),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Active Emergency Overview
            if (active != null && active.status != IncidentStatus.completed) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ACTIVE EMERGENCY CORRIDOR', style: AppTypography.caption),
                  StatusPill.critical(label: 'LIVE MISSION'),
                ],
              ),
              const SizedBox(height: 10),
              SpotifyHeroCard(
                title: 'Incident #${active.id}',
                subtitle: '${active.locationName} • Unit: ${active.assignedVehicle ?? "KA-01-EA-108"}',
                icon: Icons.emergency,
                iconBgColor: AppColors.emergencyRed,
                badgeText: 'ETA ${incidentState.estimatedArrivalMinutes}M',
                badgeColor: AppColors.emergencyRed,
                footerText: 'Corridor Cleared • Tap to view full legal audit trail',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.adminIncidentAuditTrail);
                },
              ),
              const SizedBox(height: 24),
            ],

            // System-Wide Command Metrics
            Text('COMMAND OVERVIEW', style: AppTypography.caption),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildMetric('ACTIVE EMERGENCIES', '${incidentState.incidents.where((i) => i.status != IncidentStatus.completed).length}', 'Realtime radar', Icons.crisis_alert, AppColors.emergencyRed),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetric('VERIFIED USERS', '${adminState.verifiedUsersCount}', 'Civilians/Pilots/Police', Icons.verified_user, AppColors.primaryGreen),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetric('AVG RESPONSE', '6.2 MINS', 'Phase 4 Analytics', Icons.timer, AppColors.infoBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetric('AI ACCURACY', '96.8%', 'Gemini Vision rate', Icons.auto_awesome, AppColors.corridorGreen),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Quick Navigation Hub
            Text('CONTROL ROOM MODULES', style: AppTypography.caption),
            const SizedBox(height: 12),

            _buildModuleTile(
              title: 'Phase 4 System-Wide Analytics',
              subtitle: 'Heatmaps, response time trends & hospital loads',
              icon: Icons.bar_chart_rounded,
              route: AppRoutes.adminOverallAnalytics,
            ),
            const SizedBox(height: 10),
            _buildModuleTile(
              title: 'User Management & Approvals',
              subtitle: 'Search/filter Civilians, Pilots, and Police personnel',
              icon: Icons.people_alt_rounded,
              route: AppRoutes.adminUserManagement,
            ),
            const SizedBox(height: 10),
            _buildModuleTile(
              title: 'Master Incidents & Audit Trails',
              subtitle: 'Immutable logs, GPS traces, timestamps & evidence',
              icon: Icons.receipt_long_rounded,
              route: AppRoutes.adminAllIncidents,
            ),
            const SizedBox(height: 10),
            _buildModuleTile(
              title: 'Periodic Compliance & Export Reports',
              subtitle: 'Export daily/monthly reports for transport authorities',
              icon: Icons.download_rounded,
              route: AppRoutes.adminReportsExport,
            ),

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
              Navigator.pushNamed(context, AppRoutes.adminOverallAnalytics);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.adminUserManagement);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.adminAllIncidents);
              break;
          }
        },
        items: const [
          BottomBarItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded, label: 'Command'),
          BottomBarItem(icon: Icons.analytics_outlined, activeIcon: Icons.analytics_rounded, label: 'Analytics'),
          BottomBarItem(icon: Icons.people_outline, activeIcon: Icons.people_rounded, label: 'Users'),
          BottomBarItem(icon: Icons.list_alt_outlined, activeIcon: Icons.list_alt_rounded, label: 'Incidents'),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String val, String sub, IconData icon, Color color) {
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
          const SizedBox(height: 8),
          Text(val, style: AppTypography.statNumber.copyWith(fontSize: 22)),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(sub, style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildModuleTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryGreen, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.caption),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
