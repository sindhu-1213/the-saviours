import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';

class DriverSettings extends StatefulWidget {
  const DriverSettings({super.key});

  @override
  State<DriverSettings> createState() => _DriverSettingsState();
}

class _DriverSettingsState extends State<DriverSettings> {
  bool _voiceGuidance = true;
  bool _autoReroute = true;
  bool _sirenHaptic = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pilot Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NAVIGATION & AUDIO', style: AppTypography.caption),
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
                      secondary: const Icon(Icons.record_voice_over_rounded, color: AppColors.primaryGreen),
                      title: Text('Green Corridor Voice Prompts', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      subtitle: Text('Speaks cleared junctions automatically', style: AppTypography.caption),
                      value: _voiceGuidance,
                      activeThumbColor: AppColors.primaryGreen,
                      onChanged: (v) => setState(() => _voiceGuidance = v),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.alt_route_rounded, color: AppColors.primaryGreen),
                      title: Text('Dynamic Traffic Congestion Reroute', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      value: _autoReroute,
                      activeThumbColor: AppColors.primaryGreen,
                      onChanged: (v) => setState(() => _autoReroute = v),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.vibration_rounded, color: AppColors.primaryGreen),
                      title: Text('Dispatch Siren & High-Alert Haptic', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      value: _sirenHaptic,
                      activeThumbColor: AppColors.primaryGreen,
                      onChanged: (v) => setState(() => _sirenHaptic = v),
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
                      leading: const Icon(Icons.lock_reset, color: AppColors.primaryGreen),
                      title: Text('Change Password', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    ListTile(
                      leading: const Icon(Icons.support_agent_rounded, color: AppColors.primaryGreen),
                      title: Text('Pilot Support & Help Desk', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.driverHelp),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              CustomButton(
                text: 'LOG OUT OF DRIVER TERMINAL',
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
