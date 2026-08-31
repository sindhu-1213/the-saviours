import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/status_pill.dart';

class CivilianProfile extends StatefulWidget {
  const CivilianProfile({super.key});

  @override
  State<CivilianProfile> createState() => _CivilianProfileState();
}

class _CivilianProfileState extends State<CivilianProfile> {
  final _emergencyContactController = TextEditingController(text: '+91 94480 55667 (Father)');
  final _bloodGroupController = TextEditingController(text: 'O+ Positive');

  @override
  void dispose() {
    _emergencyContactController.dispose();
    _bloodGroupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.civilianSettings);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar & Name Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryGreen,
                      ),
                      child: const Center(
                        child: Icon(Icons.person, size: 36, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Aarav Sharma',
                            style: AppTypography.titleLarge.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.phone ?? '+91 98765 43210',
                            style: AppTypography.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          StatusPill.verified(label: 'GOVT KYC VERIFIED'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Locked Government KYC Information
              Text('VERIFIED IDENTITY (LOCKED)', style: AppTypography.caption),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Full Legal Name', user?.name ?? 'Aarav Sharma', Icons.verified_user_outlined),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildInfoRow('Aadhaar Number', user?.aadhaarMasked ?? 'XXXX-XXXX-8921', Icons.credit_card_outlined),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildInfoRow('Registered Role', 'Verified Civilian Reporter', Icons.person_outline),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Editable Medical / Emergency Info
              Text('EMERGENCY & MEDICAL DETAILS', style: AppTypography.caption),
              const SizedBox(height: 12),

              CustomTextField(
                label: 'EMERGENCY CONTACT PHONE',
                hintText: '+91 94480 55667 (Relation)',
                controller: _emergencyContactController,
                prefixIcon: Icons.contact_phone_outlined,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: 'BLOOD GROUP',
                hintText: 'e.g. O+ Positive',
                controller: _bloodGroupController,
                prefixIcon: Icons.bloodtype_outlined,
              ),

              const SizedBox(height: 28),

              CustomButton(
                text: 'SAVE PROFILE CHANGES',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile information updated successfully!'),
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

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryGreen),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.caption),
            const SizedBox(height: 2),
            Text(value, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
