import 'dart:async';
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

class IncidentAssignmentAlert extends StatefulWidget {
  const IncidentAssignmentAlert({super.key});

  @override
  State<IncidentAssignmentAlert> createState() => _IncidentAssignmentAlertState();
}

class _IncidentAssignmentAlertState extends State<IncidentAssignmentAlert> {
  int _secondsLeft = 20;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        t.cancel();
        if (mounted) Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _acceptDispatch() {
    final auth = context.read<AuthState>();
    final incidentState = context.read<IncidentState>();
    final active = incidentState.activeIncident;

    if (active != null) {
      incidentState.acceptIncidentAssignment(
        active.id,
        auth.currentUser?.id ?? 'USR-DRV-108',
        auth.currentUser?.name ?? 'Rajesh Kumar',
        auth.currentUser?.vehicleNumber ?? 'KA-01-EA-108',
      );
    }

    Navigator.pushReplacementNamed(context, AppRoutes.driverIncidentDetails);
  }

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Siren Header Banner
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emergencyRed,
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                        duration: 500.ms,
                        begin: const Offset(0.7, 0.7),
                        end: const Offset(1.4, 1.4),
                      ),
                  const SizedBox(width: 10),
                  Text(
                    'HIGH PRIORITY EMERGENCY DISPATCH',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.emergencyRed,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Countdown Ring
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceElevated,
                  border: Border.all(color: AppColors.emergencyRed, width: 3),
                ),
                child: Center(
                  child: Text(
                    '${_secondsLeft}s',
                    style: AppTypography.statNumber.copyWith(
                      color: AppColors.emergencyRed,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Incoming Emergency Alert!',
                style: AppTypography.displayMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Incident #${active?.id ?? "INC-2026-0819"} verified by Gemini AI Vision.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Incident Details Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.emergencyRed.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('LOCATION', style: AppTypography.caption),
                        StatusPill.critical(label: 'CRITICAL SEVERITY'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.emergencyRed, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            active?.locationName ?? 'Indiranagar 100ft Rd, Bangalore',
                            style: AppTypography.titleMedium.copyWith(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.divider, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricColumn('EST DISTANCE', '2.4 km'),
                        Container(width: 1, height: 30, color: AppColors.divider),
                        _buildMetricColumn('EST TIME', '~ 6 mins'),
                        Container(width: 1, height: 30, color: AppColors.divider),
                        _buildMetricColumn('AI CONFIDENCE', '94%'),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'ACCEPT DISPATCH MISSION',
                icon: Icons.check_circle_rounded,
                variant: ButtonVariant.primary,
                height: 56,
                onPressed: _acceptDispatch,
              ),

              const SizedBox(height: 12),

              CustomButton(
                text: 'DECLINE (TRANSFER TO NEXT PILOT)',
                variant: ButtonVariant.outline,
                height: 48,
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.caption.copyWith(fontSize: 10)),
      ],
    );
  }
}
