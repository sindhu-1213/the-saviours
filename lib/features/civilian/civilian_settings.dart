import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';

class CivilianSettings extends StatefulWidget {
  const CivilianSettings({super.key});

  @override
  State<CivilianSettings> createState() => _CivilianSettingsState();
}

class _CivilianSettingsState extends State<CivilianSettings> {
  bool _pushAlerts = true;
  bool _soundVibration = true;
  bool _locationBackground = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('APP PREFERENCES', style: AppTypography.caption),
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
                      leading: const Icon(Icons.language_rounded, color: AppColors.primaryGreen),
                      title: Text('App Language', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      subtitle: Text(auth.selectedLanguage, style: AppTypography.caption),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.language);
                      },
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primaryGreen),
                      title: Text('Emergency Push Notifications', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      value: _pushAlerts,
                      activeThumbColor: AppColors.primaryGreen,
                      onChanged: (val) => setState(() => _pushAlerts = val),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.vibration_rounded, color: AppColors.primaryGreen),
                      title: Text('Critical Alert Siren & Vibration', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      value: _soundVibration,
                      activeThumbColor: AppColors.primaryGreen,
                      onChanged: (val) => setState(() => _soundVibration = val),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.location_on_outlined, color: AppColors.primaryGreen),
                      title: Text('High Accuracy GPS Stream', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      value: _locationBackground,
                      activeThumbColor: AppColors.primaryGreen,
                      onChanged: (val) => setState(() => _locationBackground = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('SECURITY & SUPPORT', style: AppTypography.caption),
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
                      leading: const Icon(Icons.lock_reset_rounded, color: AppColors.primaryGreen),
                      title: Text('Change Password', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPassword);
                      },
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    ListTile(
                      leading: const Icon(Icons.help_outline_rounded, color: AppColors.primaryGreen),
                      title: Text('Help & Support Center', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.civilianHelp);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              CustomButton(
                text: 'LOG OUT OF SAVIOURS',
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
