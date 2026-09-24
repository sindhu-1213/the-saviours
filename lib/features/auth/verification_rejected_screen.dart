import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class VerificationRejectedScreen extends StatelessWidget {
  const VerificationRejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final reason = auth.currentUser?.rejectionReason ??
        'The uploaded document was blurry or the name did not match registered details.';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Verification Notice'),
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
                  color: AppColors.emergencyRed.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.emergencyRed, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.cancel_rounded,
                    size: 54,
                    color: AppColors.emergencyRed,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              StatusPill(
                label: 'VERIFICATION REJECTED',
                color: AppColors.emergencyRed,
                textColor: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                'Document Review Failed',
                style: AppTypography.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Rejection Reason Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.emergencyRed.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.emergencyRed, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'REASON FOR REJECTION:',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.emergencyRed,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      reason,
                      style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Text(
                'Please re-upload a clear copy of your government ID with all corners visible to reactivate verification.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              CustomButton(
                text: 'RE-SUBMIT DOCUMENTS',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.kycUpload);
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'HELP & SUPPORT',
                variant: ButtonVariant.outline,
                onPressed: () {
                  String helpRoute = AppRoutes.civilianHelp;
                  switch (auth.currentRole) {
                    case UserRole.civilian:
                      helpRoute = AppRoutes.civilianHelp;
                      break;
                    case UserRole.driver:
                      helpRoute = AppRoutes.driverHelp;
                      break;
                    case UserRole.police:
                      helpRoute = AppRoutes.policeHelp;
                      break;
                    case UserRole.admin:
                      helpRoute = AppRoutes.adminHelp;
                      break;
                  }
                  Navigator.pushNamed(context, helpRoute);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
