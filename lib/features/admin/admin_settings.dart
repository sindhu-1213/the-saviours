import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  bool _aiConfidenceThresholdStrict = true;
  bool _geoFenceRadius500m = true;
  bool _autoDispatchNearest = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('System Configuration & Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SYSTEM & AI THRESHOLDS', style: AppTypography.caption),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.auto_awesome, color: AppColors.primaryGreen),
                      title: Text('Strict AI Verification Threshold (≥ 80%)', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      subtitle: Text('Rejects accident reports scoring below 80% confidence', style: AppTypography.caption),
                      value: _aiConfidenceThresholdStrict,
                      activeThumbColor: AppColors.primaryGreen,
                      onChanged: (v) => setState(() => _aiConfidenceThresholdStrict = v),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.radar_rounded, color: AppColors.primaryGreen),
                      title: Text('Dynamic Geo-fence (500m Buffer)', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      subtitle: Text('Alerts police junctions 500m before ambulance approach', style: AppTypography.caption),
                      value: _geoFenceRadius500m,
                      activeThumbColor: AppColors.primaryGreen,
                      onChanged: (v) => setState(() => _geoFenceRadius500m = v),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.bolt_rounded, color: AppColors.primaryGreen),
                      title: Text('Auto-Dispatch Nearest Ambulance Pilot', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      subtitle: Text('Automatically selects lowest ETA pilot without manual routing', style: AppTypography.caption),
                      value: _autoDispatchNearest,
                      activeThumbColor: AppColors.primaryGreen,
                      onChanged: (v) => setState(() => _autoDispatchNearest = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('ADMIN SECURITY & AUDIT', style: AppTypography.caption),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock_reset, color: AppColors.primaryGreen),
                      title: Text('Change Admin Password', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    ListTile(
                      leading: const Icon(Icons.help_center_outlined, color: AppColors.primaryGreen),
                      title: Text('Admin Protocol Documentation', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.adminHelp),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              CustomButton(
                text: 'LOG OUT OF CONTROL ROOM',
                variant: ButtonVariant.outline,
                onPressed: () {
                  auth.logout();
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
