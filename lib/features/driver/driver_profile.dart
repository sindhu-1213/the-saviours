import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/status_pill.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  final _depotController = TextEditingController(text: 'Indiranagar Fire & Emergency Station');
  final _phoneController = TextEditingController(text: '+91 98450 11208');

  @override
  void dispose() {
    _depotController.dispose();
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
        title: const Text('Pilot Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.driverSettings),
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
                        color: AppColors.primaryGreen,
                      ),
                      child: const Center(
                        child: Icon(Icons.local_hospital_rounded, size: 36, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.name ?? 'Rajesh Kumar', style: AppTypography.titleLarge.copyWith(fontSize: 18)),
                          const SizedBox(height: 4),
                          Text('Unit ${user?.vehicleNumber ?? "KA-01-EA-108"}', style: AppTypography.bodyMedium),
                          const SizedBox(height: 8),
                          StatusPill.verified(label: 'CERTIFIED PILOT • 108 GVK-EMRI'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('OFFICIAL CREDENTIALS (LOCKED)', style: AppTypography.caption),
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
                    _buildInfo('Badge Number', user?.badgeNumber ?? 'AMB-BLR-042', Icons.badge_outlined),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildInfo('Commercial DL', 'KA-04-2016-0089128 (Heavy/Ambulance)', Icons.drive_eta_outlined),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildInfo('Vehicle RC', 'KA-01-EA-108 (Force Traveller ALS ICU)', Icons.car_repair),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('DUTY & OPERATIONAL SETTINGS', style: AppTypography.caption),
              const SizedBox(height: 12),

              CustomTextField(
                label: 'ASSIGNED DEPOT STATION',
                hintText: 'Station Name',
                controller: _depotController,
                prefixIcon: Icons.business_outlined,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'DUTY CONTACT PHONE',
                hintText: 'Mobile number',
                controller: _phoneController,
                prefixIcon: Icons.phone_outlined,
              ),

              const SizedBox(height: 28),

              CustomButton(
                text: 'UPDATE PILOT DETAILS',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pilot settings updated successfully!'),
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
        Icon(icon, size: 18, color: AppColors.primaryGreen),
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
