import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/status_pill.dart';

class PoliceProfile extends StatefulWidget {
  const PoliceProfile({super.key});

  @override
  State<PoliceProfile> createState() => _PoliceProfileState();
}

class _PoliceProfileState extends State<PoliceProfile> {
  final _phoneController = TextEditingController(text: '+91 97312 99502');
  final _stationController = TextEditingController(text: 'Ashok Nagar Traffic Police Station');

  @override
  void dispose() {
    _phoneController.dispose();
    _stationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Officer Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.policeSettings),
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
                        color: AppColors.corridorGreen,
                      ),
                      child: const Center(
                        child: Icon(Icons.local_police_rounded, size: 36, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.name ?? 'Inspector Vikram Rao', style: AppTypography.titleLarge.copyWith(fontSize: 18)),
                          const SizedBox(height: 4),
                          Text('Badge #${user?.badgeNumber ?? "TP-BLR-502"}', style: AppTypography.bodyMedium),
                          const SizedBox(height: 8),
                          StatusPill.cleared(label: 'GOVT VERIFIED POLICE OFFICER'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('VERIFIED POLICE CREDENTIALS (LOCKED)', style: AppTypography.caption),
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
                    _buildInfo('Official Badge ID', user?.badgeNumber ?? 'TP-BLR-502', Icons.badge_outlined),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildInfo('Designation', 'Traffic Police Sub-Inspector (TPSI)', Icons.military_tech_outlined),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildInfo('Assigned Corridor Zone', user?.jurisdictionZone ?? 'MG Road - Trinity - Domlur', Icons.traffic_outlined),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('DUTY CONTACT & STATION', style: AppTypography.caption),
              const SizedBox(height: 12),

              CustomTextField(
                label: 'OFFICIAL STATION DEPOT',
                hintText: 'Traffic Police Station',
                controller: _stationController,
                prefixIcon: Icons.business_outlined,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'DIRECT DUTY MOBILE',
                hintText: 'Mobile number',
                controller: _phoneController,
                prefixIcon: Icons.phone_outlined,
              ),

              const SizedBox(height: 28),

              CustomButton(
                text: 'UPDATE OFFICER PROFILE',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Officer details updated successfully!'),
                      backgroundColor: AppColors.corridorGreen,
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
        Icon(icon, size: 18, color: AppColors.corridorGreen),
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
