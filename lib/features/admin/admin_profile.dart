import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/status_pill.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final _emailController = TextEditingController(text: 'admin@control.saviours.org');
  final _phoneController = TextEditingController(text: '+91 80 2297 1000');

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Console Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.adminSettings),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Card
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
                        color: AppColors.warningOrange,
                      ),
                      child: const Center(
                        child: Icon(Icons.admin_panel_settings, size: 36, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.name ?? 'Dr. Ananya Sen', style: AppTypography.titleLarge.copyWith(fontSize: 18)),
                          const SizedBox(height: 4),
                          Text('Head of Emergency Operations', style: AppTypography.bodyMedium),
                          const SizedBox(height: 8),
                          StatusPill.verified(label: 'PROVISIONED ROOT ADMIN'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('ADMINISTRATIVE PERMISSIONS (LOCKED)', style: AppTypography.caption),
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
                    _buildInfo('Operator ID', 'ADM-EXEC-BLR-01', Icons.badge_outlined),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildInfo('Access Tier', 'Super Admin • Full RLS Override Permissions', Icons.security),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildInfo('Control Division', 'Emergency Response & Traffic Synchronization Grid', Icons.account_tree_outlined),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('CONTACT & ESCALATION DETAILS', style: AppTypography.caption),
              const SizedBox(height: 12),

              CustomTextField(
                label: 'CONTROL ROOM DESK EMAIL',
                hintText: 'Email address',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'CONTROL ROOM DIRECT HOTLINE',
                hintText: 'Phone number',
                controller: _phoneController,
                prefixIcon: Icons.phone_outlined,
              ),

              const SizedBox(height: 28),

              CustomButton(
                text: 'UPDATE ADMIN CONTACT INFO',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Admin profile details updated successfully!'),
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

  Widget _buildInfo(String label, String val, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.warningOrange),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.caption),
            const SizedBox(height: 2),
            Text(val, style: AppTypography.titleMedium.copyWith(fontSize: 13)),
          ],
        ),
      ],
    );
  }
}
