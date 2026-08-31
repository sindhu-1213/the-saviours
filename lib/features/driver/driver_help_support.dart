import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';

class DriverHelpSupport extends StatelessWidget {
  const DriverHelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Ambulance Operations Support')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilot Operations Desk', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                '24/7 technical and traffic clearance escalation for ambulance pilots.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(16),
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
                        child: Icon(Icons.radio_rounded, color: Colors.black, size: 26),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Direct Radio / Control Room', style: AppTypography.titleMedium),
                          const SizedBox(height: 2),
                          Text('Priority Dispatch Desk: 1800-108-EMRI', style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text('PILOT FAQ & PROTOCOLS', style: AppTypography.caption),
              const SizedBox(height: 12),

              _buildFaq(
                'What if a traffic signal is not cleared green?',
                'You can tap "Report Signal Delay" on the live navigation HUD. This immediately alerts the nearest Traffic Police zone officer and logs the delay.',
              ),
              const SizedBox(height: 10),
              _buildFaq(
                'How are hospital suggestions calculated?',
                'The engine ranks hospitals considering live traffic travel time, real-time ICU bed availability, and specialty capability (Trauma / Cardiac / Neuro).',
              ),
              const SizedBox(height: 10),
              _buildFaq(
                'How is patient drop-off confirmed?',
                'Upon arrival at the emergency bay, tapping "Confirm Handover" closes Phase 3 and releases your ambulance back to available On-Duty status.',
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'CALL 108 DISPATCH CONTROL',
                variant: ButtonVariant.emergency,
                icon: Icons.phone_in_talk,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling 108 Dispatch Command Room...')),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaq(String q, String a) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: ExpansionTile(
        title: Text(q, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
        iconColor: AppColors.primaryGreen,
        collapsedIconColor: AppColors.textSecondary,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(a, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
