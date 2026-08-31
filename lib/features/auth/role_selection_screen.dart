import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../mock_data/mock_emergency_database.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.civilian;

  final List<Map<String, dynamic>> _roles = [
    {
      'role': UserRole.civilian,
      'title': 'Civilian / Citizen',
      'subtitle': 'Report road accidents, provide AI-verified evidence & track rescue assistance in real-time.',
      'icon': Icons.person_pin_circle_rounded,
      'badge': 'Aadhaar Verification',
      'color': AppColors.emergencyRed,
    },
    {
      'role': UserRole.driver,
      'title': 'Ambulance Driver',
      'subtitle': 'Receive emergency dispatches, navigate green corridors & transport patients to trauma centers.',
      'icon': Icons.local_hospital_rounded,
      'badge': 'DL & Service ID Required',
      'color': AppColors.infoBlue,
    },
    {
      'role': UserRole.police,
      'title': 'Traffic Police Officer',
      'subtitle': 'Monitor approaching ambulances on radar & activate Green Corridors at crucial intersections.',
      'icon': Icons.traffic_rounded,
      'badge': 'Police Badge ID Required',
      'color': AppColors.corridorGreen,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text('How would you like to\njoin Saviours?', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'Select your role to ensure correct document verification & permissions.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _roles.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = _roles[index];
                    final role = item['role'] as UserRole;
                    final isSelected = _selectedRole == role;
                    final color = item['color'] as Color;

                    return InkWell(
                      onTap: () {
                        setState(() => _selectedRole = role);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(alpha: 0.12)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? color : AppColors.divider,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: color,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'] as String,
                                        style: AppTypography.titleLarge.copyWith(
                                          fontSize: 17,
                                          color: isSelected ? color : Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceElevated,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item['badge'] as String,
                                          style: AppTypography.caption.copyWith(fontSize: 9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? color : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? color : AppColors.textSecondary,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Center(
                                          child: Icon(Icons.check, size: 14, color: Colors.black),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item['subtitle'] as String,
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthState>().setPendingSignupRole(_selectedRole);
                  Navigator.pushNamed(context, AppRoutes.signupBasic);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('PROCEED WITH SELECTED ROLE', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
