import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class VerificationPendingScreen extends StatelessWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Verification Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warningOrange.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.warningOrange, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.hourglass_top_rounded,
                    size: 54,
                    color: AppColors.warningOrange,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              StatusPill(
                label: 'DOCUMENTS UNDER REVIEW',
                color: AppColors.warningOrange,
                textColor: Colors.black,
              ),
              const SizedBox(height: 20),
              Text(
                'Verification In Progress',
                style: AppTypography.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your credentials and documents are being validated by the Control Room and OCR validation engine. Operational features will unlock immediately once approved.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Progress Checklist
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildCheckRow('Mobile OTP Verified', true),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildCheckRow('Document Cryptographic Upload', true),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildCheckRow('AI Fraud & Tamper Check', true),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildCheckRow('Admin Control Room Approval', false),
                  ],
                ),
              ),

              const Spacer(),

              // Quick Action to simulate Admin Approval for testing
              CustomButton(
                text: 'SIMULATE ADMIN APPROVAL',
                onPressed: () {
                  auth.setVerificationStatus(VerificationStatus.verified);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account verified successfully! Routing to Dashboard...'),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                  String destination = AppRoutes.civilianHome;
                  switch (auth.currentRole) {
                    case UserRole.civilian:
                      destination = AppRoutes.civilianHome;
                      break;
                    case UserRole.driver:
                      destination = AppRoutes.driverHome;
                      break;
                    case UserRole.police:
                      destination = AppRoutes.policeHome;
                      break;
                    case UserRole.admin:
                      destination = AppRoutes.adminHome;
                      break;
                  }
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    destination,
                    (r) => false,
                  );
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'CHECK LATEST STATUS',
                variant: ButtonVariant.outline,
                onPressed: () {
                  if (auth.isVerified) {
                    String destination = AppRoutes.civilianHome;
                    switch (auth.currentRole) {
                      case UserRole.civilian:
                        destination = AppRoutes.civilianHome;
                        break;
                      case UserRole.driver:
                        destination = AppRoutes.driverHome;
                        break;
                      case UserRole.police:
                        destination = AppRoutes.policeHome;
                        break;
                      case UserRole.admin:
                        destination = AppRoutes.adminHome;
                        break;
                    }
                    Navigator.pushNamedAndRemoveUntil(context, destination, (r) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Status refreshed: Documents currently under review.')),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckRow(String title, bool isDone) {
    return Row(
      children: [
        Icon(
          isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          color: isDone ? AppColors.primaryGreen : AppColors.textSecondary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
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
