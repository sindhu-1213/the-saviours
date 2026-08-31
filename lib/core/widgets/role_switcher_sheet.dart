import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_typography.dart';
import '../state/auth_state.dart';
import '../../mock_data/mock_emergency_database.dart';

class RoleSwitcherSheet extends StatelessWidget {
  const RoleSwitcherSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (ctx) => const RoleSwitcherSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Switch Active Role / Persona', style: AppTypography.titleLarge),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'DEV PREVIEW',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Instant switch between the 4 coordinated emergency roles and KYC states.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 20),
          _buildRoleOption(
            context: context,
            role: UserRole.civilian,
            title: 'Civilian (Aarav Sharma)',
            subtitle: 'Report accidents with Camera & track live ambulance',
            icon: Icons.person_pin_circle_rounded,
            route: AppRoutes.civilianHome,
            isSelected: auth.currentRole == UserRole.civilian,
          ),
          const SizedBox(height: 10),
          _buildRoleOption(
            context: context,
            role: UserRole.driver,
            title: 'Ambulance Driver (Rajesh Kumar)',
            subtitle: 'Accept dispatch, Cycle 1 & 2 Nav, Hospital selection',
            icon: Icons.local_hospital_rounded,
            route: AppRoutes.driverHome,
            isSelected: auth.currentRole == UserRole.driver,
          ),
          const SizedBox(height: 10),
          _buildRoleOption(
            context: context,
            role: UserRole.police,
            title: 'Traffic Police (Inspector Vikram Rao)',
            subtitle: 'Radar monitoring & "Traffic Cleared" Green Corridor trigger',
            icon: Icons.traffic_rounded,
            route: AppRoutes.policeHome,
            isSelected: auth.currentRole == UserRole.police,
          ),
          const SizedBox(height: 10),
          _buildRoleOption(
            context: context,
            role: UserRole.admin,
            title: 'Admin (Control Room Lead)',
            subtitle: 'KYC review, Full audit trail & Phase 4 System Analytics',
            icon: Icons.admin_panel_settings_rounded,
            route: AppRoutes.adminHome,
            isSelected: auth.currentRole == UserRole.admin,
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),
          Text('Simulate KYC Verification Status:', style: AppTypography.caption),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    auth.setVerificationStatus(VerificationStatus.verified);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    side: const BorderSide(color: AppColors.primaryGreen),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Verified', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    auth.setVerificationStatus(VerificationStatus.pending);
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, AppRoutes.verificationPending);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warningOrange,
                    side: const BorderSide(color: AppColors.warningOrange),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Pending', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    auth.setVerificationStatus(
                      VerificationStatus.rejected,
                      reason: 'Document blurred / Invalid credentials',
                    );
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, AppRoutes.verificationRejected);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.emergencyRed,
                    side: const BorderSide(color: AppColors.emergencyRed),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Rejected', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleOption({
    required BuildContext context,
    required UserRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
    required bool isSelected,
  }) {
    final auth = context.read<AuthState>();

    return InkWell(
      onTap: () {
        auth.switchToRole(role);
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withValues(alpha: 0.15)
              : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.surfaceHighlight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.black : Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 14,
                      color: isSelected ? AppColors.primaryGreen : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 20),
          ],
        ),
      ),
    );
  }
}
