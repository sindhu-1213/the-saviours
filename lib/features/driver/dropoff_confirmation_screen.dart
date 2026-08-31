import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';

class DropoffConfirmationScreen extends StatelessWidget {
  const DropoffConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGreen.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.primaryGreen, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.task_alt_rounded,
                    size: 56,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              StatusPill.verified(label: 'MISSION COMPLETED • PATIENT DELIVERED'),

              const SizedBox(height: 16),

              Text(
                'Handover Complete!',
                style: AppTypography.displayMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Patient successfully transferred to emergency trauma medical staff at ${active?.assignedHospitalName ?? "Apollo Speciality Hospital"}.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildRow('Receiving Hospital', active?.assignedHospitalName ?? 'Apollo Speciality'),
                    const Divider(color: AppColors.divider, height: 18),
                    _buildRow('Handover Status', 'Received in Trauma Bay 2'),
                    const Divider(color: AppColors.divider, height: 18),
                    _buildRow('Corridor Clearance', 'All 4 signals coordinated'),
                  ],
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'VIEW TRIP SUMMARY & AUDIT RECAP',
                icon: Icons.receipt_long_rounded,
                height: 56,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.driverTripSummary,
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.caption),
        Text(value, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
