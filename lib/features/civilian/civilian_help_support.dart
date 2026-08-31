import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';

class CivilianHelpSupport extends StatelessWidget {
  const CivilianHelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support Center'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How can we assist you?', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Find answers to emergency workflows or reach the Saviours 24/7 Operations Desk.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),

              // 24/7 Operations Contact Card
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
                        child: Icon(Icons.headset_mic_rounded, color: Colors.black, size: 26),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('24/7 Control Room Support', style: AppTypography.titleMedium),
                          const SizedBox(height: 2),
                          Text('support@saviours.org • 1800-108-9999', style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text('FREQUENTLY ASKED QUESTIONS', style: AppTypography.caption),
              const SizedBox(height: 12),

              _buildFaqTile(
                'Why are gallery uploads disabled for reporting?',
                'To prevent fraudulent reporting, staged accident photos, or stale pictures, Saviours mandates real-time camera capture with cryptographically bound GPS coordinates and server timestamps.',
              ),
              const SizedBox(height: 10),
              _buildFaqTile(
                'How does Google Gemini AI verify the accident?',
                'The AI vision model inspects vehicle impact deformation, road surroundings, casualty positions, and lighting metadata within 1.8 seconds to compute a confidence score (0-100%).',
              ),
              const SizedBox(height: 10),
              _buildFaqTile(
                'What is a Dynamic Green Corridor?',
                'Once an incident is verified, upcoming traffic police posts along the ambulance route receive geo-fenced alerts to manually and synchronously turn upcoming traffic signals green, eliminating congestion delays.',
              ),
              const SizedBox(height: 10),
              _buildFaqTile(
                'Who can see my personal details?',
                'Your verified identity is encrypted and only accessible to authorized emergency control rooms and investigating authorities in accordance with data privacy regulations.',
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'CALL 108 EMERGENCY HELPLINE',
                variant: ButtonVariant.emergency,
                icon: Icons.emergency,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dialing 108 Emergency Medical Response...')),
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

  Widget _buildFaqTile(String question, String answer) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTypography.titleMedium.copyWith(fontSize: 14),
        ),
        iconColor: AppColors.primaryGreen,
        collapsedIconColor: AppColors.textSecondary,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(answer, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
