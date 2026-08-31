import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';

class AiVerifyingScreen extends StatefulWidget {
  const AiVerifyingScreen({super.key});

  @override
  State<AiVerifyingScreen> createState() => _AiVerifyingScreenState();
}

class _AiVerifyingScreenState extends State<AiVerifyingScreen> {
  Timer? _routeTimer;

  @override
  void initState() {
    super.initState();
    // Auto transition to Incident Verified Confirmation once AI verification finishes
    _routeTimer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.civilianIncidentVerified);
      }
    });
  }

  @override
  void dispose() {
    _routeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final progress = incidentState.aiVerificationProgress.clamp(20, 100);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated AI Vision Scanning Orb
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceElevated,
                  border: Border.all(color: AppColors.primaryGreen, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.35),
                      blurRadius: 36,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 64,
                    color: AppColors.primaryGreen,
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(duration: 1000.ms, begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05))
                  .shimmer(duration: 1400.ms),

              const SizedBox(height: 40),

              Text(
                'Verifying Accident Report',
                style: AppTypography.displayMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                'Google Gemini AI Vision is analyzing image evidence, context metadata, and tamper prevention tokens.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress / 100.0,
                  minHeight: 10,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'ANALYSIS PROGRESS: $progress%',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: AppColors.primaryGreen,
                ),
              ),

              const SizedBox(height: 36),

              // AI Verification Check steps
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildStepRow('Image Authenticity & Tamper Check', progress >= 30),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildStepRow('Road Collision & Severity Classifier', progress >= 60),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildStepRow('GPS Geofence & Emergency Dispatch Signal', progress >= 90),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow(String label, bool isDone) {
    return Row(
      children: [
        Icon(
          isDone ? Icons.check_circle_rounded : Icons.sync_rounded,
          color: isDone ? AppColors.primaryGreen : AppColors.textMuted,
          size: 18,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isDone ? Colors.white : AppColors.textSecondary,
              fontWeight: isDone ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
