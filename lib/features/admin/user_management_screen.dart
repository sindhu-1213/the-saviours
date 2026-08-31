import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/admin_state.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _selectedRoleFilter = 'ALL';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final adminState = context.watch<AdminState>();
    var users = adminState.allUsers;

    if (_selectedRoleFilter == 'CIVILIAN') {
      users = users.where((u) => u.role == UserRole.civilian).toList();
    } else if (_selectedRoleFilter == 'PILOT') {
      users = users.where((u) => u.role == UserRole.driver).toList();
    } else if (_selectedRoleFilter == 'POLICE') {
      users = users.where((u) => u.role == UserRole.police).toList();
    }

    if (_searchQuery.isNotEmpty) {
      users = users
          .where((u) =>
              u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              u.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              u.id.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('User Management Registry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.verified_user_outlined),
            tooltip: 'Review Pending KYCs',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.adminVerificationReview),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Search by name, email, or user ID...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),

              const SizedBox(height: 14),

              // Role Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['ALL', 'CIVILIAN', 'PILOT', 'POLICE'].map((r) {
                    final isSel = _selectedRoleFilter == r;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSel,
                        label: Text(r, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.primaryGreen,
                        labelStyle: TextStyle(color: isSel ? Colors.black : Colors.white),
                        side: const BorderSide(color: AppColors.divider),
                        onSelected: (_) => setState(() => _selectedRoleFilter = r),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: users.isEmpty
                    ? Center(child: Text('No users match search criteria.', style: AppTypography.bodyMedium))
                    : ListView.separated(
                        itemCount: users.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final u = users[index];

                          return InkWell(
                            onTap: () {
                              if (u.verificationStatus == VerificationStatus.pending) {
                                Navigator.pushNamed(context, AppRoutes.adminVerificationReview);
                              }
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(u.role).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(_getRoleIcon(u.role), color: _getRoleColor(u.role), size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(u.name, style: AppTypography.titleMedium.copyWith(fontSize: 15)),
                                        const SizedBox(height: 2),
                                        Text('${u.role.name.toUpperCase()} • ${u.id}', style: AppTypography.caption),
                                      ],
                                    ),
                                  ),
                                  StatusPill(
                                    label: u.verificationStatus.name.toUpperCase(),
                                    color: _getStatusColor(u.verificationStatus),
                                    textColor: u.verificationStatus == VerificationStatus.verified ? Colors.black : Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.civilian:
        return AppColors.emergencyRed;
      case UserRole.driver:
        return AppColors.infoBlue;
      case UserRole.police:
        return AppColors.corridorGreen;
      case UserRole.admin:
        return AppColors.warningOrange;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.civilian:
        return Icons.person;
      case UserRole.driver:
        return Icons.local_hospital;
      case UserRole.police:
        return Icons.traffic;
      case UserRole.admin:
        return Icons.admin_panel_settings;
    }
  }

  Color _getStatusColor(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return AppColors.primaryGreen;
      case VerificationStatus.pending:
        return AppColors.warningOrange;
      case VerificationStatus.rejected:
        return AppColors.emergencyRed;
    }
  }
}
