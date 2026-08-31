import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';

class PoliceHelpSupport extends StatelessWidget {
  const PoliceHelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Traffic Operations Support')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Traffic Command Desk', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Direct hotline and operational protocols for traffic police junction officers.',
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
                        color: AppColors.corridorGreen,
                      ),
                      child: const Center(
                        child: Icon(Icons.security_rounded, color: Colors.black, size: 26),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Traffic Management Center (TMC)', style: AppTypography.titleMedium),
                          const SizedBox(height: 2),
                          Text('Direct Radio Desk: 080-22942222', style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text('TRAFFIC CLEARANCE FAQs', style: AppTypography.caption),
              const SizedBox(height: 12),

              _buildFaq(
                'How are geo-fence alerts triggered?',
                'When an active ambulance enters your designated 500m jurisdiction polygon, the server pushes an automatic high-priority sound alert to your terminal.',
              ),
              const SizedBox(height: 10),
              _buildFaq(
                'What does pressing "Traffic Cleared" do?',
                'It instantly marks the junction checkpoint as safe, switches the ambulance live navigation path from blue to glowing green corridor, and records your timestamp in the legal audit trail.',
              ),
              const SizedBox(height: 10),
              _buildFaq(
                'What if heavy traffic cannot be cleared in time?',
                'If congestion prevents clearance, press "Report Bottleneck" to prompt the AI dispatch server to immediately reroute the ambulance along an alternate arterial road.',
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'CALL TRAFFIC CONTROL ROOM',
                variant: ButtonVariant.emergency,
                icon: Icons.phone_in_talk,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling Bangalore Traffic Management Center...')),
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
        iconColor: AppColors.corridorGreen,
        collapsedIconColor: AppColors.textSecondary,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(a, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
