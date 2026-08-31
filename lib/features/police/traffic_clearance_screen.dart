import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';

class TrafficClearanceScreen extends StatefulWidget {
  const TrafficClearanceScreen({super.key});

  @override
  State<TrafficClearanceScreen> createState() => _TrafficClearanceScreenState();
}

class _TrafficClearanceScreenState extends State<TrafficClearanceScreen> {
  final String _junctionName = 'Trinity Circle Signal - MG Rd';
  bool _isCleared = false;

  void _handleClearance() {
    final auth = context.read<AuthState>();
    final incidentState = context.read<IncidentState>();

    incidentState.clearTrafficJunction(
      _junctionName,
      auth.currentUser?.name ?? 'Inspector Vikram Rao',
      auth.currentUser?.id ?? 'USR-POL-502',
    );

    setState(() => _isCleared = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Junction Cleared! Ambulance Green Corridor is now ACTIVE!'),
        backgroundColor: AppColors.corridorGreen,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Traffic Clearance Console'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Junction Card
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
                        Text('CURRENT POST', style: AppTypography.caption),
                        StatusPill.cleared(
                          label: _isCleared ? 'SIGNAL CLEARED GREEN' : 'ACTION PENDING',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.corridorGreen.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.traffic_rounded, color: AppColors.corridorGreen, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_junctionName, style: AppTypography.titleLarge.copyWith(fontSize: 16)),
                              const SizedBox(height: 2),
                              Text('Approaching Unit: ${active?.assignedVehicle ?? "KA-01-EA-108"}', style: AppTypography.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Big "TRAFFIC CLEARED" Trigger
              if (!_isCleared) ...[
                Text(
                  'Tap button once all intersecting lanes are halted & ambulance lane is clear.',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: _handleClearance,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.corridorGreen,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.corridorGreen.withValues(alpha: 0.5),
                          blurRadius: 36,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.traffic_rounded, color: Colors.black, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          'TRAFFIC\nCLEARED',
                          textAlign: TextAlign.center,
                          style: AppTypography.displayMedium.copyWith(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                        duration: 900.ms,
                        begin: const Offset(0.97, 0.97),
                        end: const Offset(1.03, 1.03),
                      ),
                ),
              ] else ...[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.corridorGreen.withValues(alpha: 0.2),
                    border: Border.all(color: AppColors.corridorGreen, width: 3),
                  ),
                  child: const Center(
                    child: Icon(Icons.check_circle_rounded, color: AppColors.corridorGreen, size: 64),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Green Corridor Activated!', style: AppTypography.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'Timestamp logged at Trinity Circle. Ambulance pilot notified with green corridor clearance audio.',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],

              const Spacer(),

              if (_isCleared) ...[
                CustomButton(
                  text: 'RETURN TO TRAFFIC DASHBOARD',
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.policeHome,
                      (r) => false,
                    );
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'VIEW CLEARANCE AUDIT LOG',
                  variant: ButtonVariant.outline,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.policeClearanceHistory);
                  },
                ),
              ] else ...[
                CustomButton(
                  text: 'VIEW LIVE AMBULANCE RADAR',
                  variant: ButtonVariant.outline,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.policeLiveMap),
                ),
              ],

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
