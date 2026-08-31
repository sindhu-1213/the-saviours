import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';

class PoliceSettings extends StatefulWidget {
  const PoliceSettings({super.key});

  @override
  State<PoliceSettings> createState() => _PoliceSettingsState();
}

class _PoliceSettingsState extends State<PoliceSettings> {
  bool _geoFenceAlerts = true;
  bool _sirenSound = true;
  bool _autoSignalSync = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Officer Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RADAR & DISPATCH ALERTS', style: AppTypography.caption),
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
                      secondary: const Icon(Icons.radar_rounded, color: AppColors.corridorGreen),
                      title: Text('Geo-Fence Proximity Alerts', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      subtitle: Text('Alerts when ambulance enters 500m radius', style: AppTypography.caption),
                      value: _geoFenceAlerts,
                      activeThumbColor: AppColors.corridorGreen,
                      onChanged: (v) => setState(() => _geoFenceAlerts = v),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.volume_up_rounded, color: AppColors.corridorGreen),
                      title: Text('Emergency Priority Audio Siren', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      value: _sirenSound,
                      activeThumbColor: AppColors.corridorGreen,
                      onChanged: (v) => setState(() => _sirenSound = v),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.traffic_rounded, color: AppColors.corridorGreen),
                      title: Text('Signal SCATS / ITMS Auto-Sync', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      subtitle: Text('Sync clearance with Bangalore Traffic SCATS system', style: AppTypography.caption),
                      value: _autoSignalSync,
                      activeThumbColor: AppColors.corridorGreen,
                      onChanged: (v) => setState(() => _autoSignalSync = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('ACCOUNT & SUPPORT', style: AppTypography.caption),
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
                      leading: const Icon(Icons.lock_reset, color: AppColors.corridorGreen),
                      title: Text('Change Password', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    ListTile(
                      leading: const Icon(Icons.support_agent_rounded, color: AppColors.corridorGreen),
                      title: Text('Police Control Room Support', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.policeHelp),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              CustomButton(
                text: 'LOG OUT OF OFFICER TERMINAL',
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
