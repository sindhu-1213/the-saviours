import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../mock_data/mock_emergency_database.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2200), _handleNavigation);
  }

  void _handleNavigation() {
    if (!mounted) return;
    final auth = context.read<AuthState>();

    if (!auth.isAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    if (auth.isPending) {
      Navigator.pushReplacementNamed(context, AppRoutes.verificationPending);
      return;
    }

    if (auth.isRejected) {
      Navigator.pushReplacementNamed(context, AppRoutes.verificationRejected);
      return;
    }

    // Role-based routing
    switch (auth.currentRole) {
      case UserRole.civilian:
        Navigator.pushReplacementNamed(context, AppRoutes.civilianHome);
        break;
      case UserRole.driver:
        Navigator.pushReplacementNamed(context, AppRoutes.driverHome);
        break;
      case UserRole.police:
        Navigator.pushReplacementNamed(context, AppRoutes.policeHome);
        break;
      case UserRole.admin:
        Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
        break;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background ambient gradient glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGreen.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emergencyRed.withValues(alpha: 0.08),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Icon with animated glow
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.primaryGreen, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.3),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.emergency_share_rounded,
                      size: 52,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                )
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.easeOutBack)
                    .then()
                    .shimmer(duration: 1200.ms),

                const SizedBox(height: 28),

                Text(
                  'SAVIOURS',
                  style: AppTypography.displayLarge.copyWith(
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.w900,
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 8),

                Text(
                  'EMERGENCY RESPONSE & GREEN CORRIDOR',
                  style: AppTypography.caption.copyWith(
                    letterSpacing: 1.5,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 48),

                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                  ),
                ).animate().fadeIn(delay: 800.ms),
              ],
            ),
          ),

          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Connecting Civilians • Ambulances • Traffic Police • Admin',
                style: AppTypography.caption.copyWith(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
