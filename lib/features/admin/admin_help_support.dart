import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';

class AdminHelpSupport extends StatelessWidget {
  const AdminHelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Admin System Documentation')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Control Room Operational Protocols', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Technical references for KYC review, edge dispatch functions, and legal audit compliance.',
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
                        color: AppColors.warningOrange,
                      ),
                      child: const Center(
                        child: Icon(Icons.hub_rounded, color: Colors.black, size: 26),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Infrastructure DevOps Hotline', style: AppTypography.titleMedium),
                          const SizedBox(height: 2),
                          Text('Cloud Architecture & Supabase Edge Status: Active', style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text('ADMINISTRATIVE GUIDELINES', style: AppTypography.caption),
              const SizedBox(height: 12),

              _buildFaq(
                'How are KYC document approvals validated?',
                'Admin reviews the OCR-extracted data, AI tampering scan, and visual photo of the Aadhaar / Driving Licence before approving access to operational dispatch features.',
              ),
              const SizedBox(height: 10),
              _buildFaq(
                'How does legal evidence export work?',
                'Every accident incident generates a SHA-256 bound audit trail with civilian geotags, AI confidence scores, dispatch timestamps, traffic clearance logs, and hospital handover records for legal submission.',
              ),
              const SizedBox(height: 10),
              _buildFaq(
                'How are Phase 4 system metrics computed?',
                'Overall analytics aggregate latency from Phase 1 (civilian capture) -> Phase 2 (ambulance dispatch & police clearance) -> Phase 3 (trauma arrival) across all urban corridors.',
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'DOWNLOAD SYSTEM ARCHITECTURE MANUAL',
                icon: Icons.menu_book_rounded,
                variant: ButtonVariant.primary,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saviours_System_Architecture_Manual.pdf downloaded!'),
                      backgroundColor: AppColors.primaryGreen,
                    ),
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
        iconColor: AppColors.warningOrange,
        collapsedIconColor: AppColors.textSecondary,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(a, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
