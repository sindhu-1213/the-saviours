import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class HospitalSuggestionScreen extends StatefulWidget {
  const HospitalSuggestionScreen({super.key});

  @override
  State<HospitalSuggestionScreen> createState() => _HospitalSuggestionScreenState();
}

class _HospitalSuggestionScreenState extends State<HospitalSuggestionScreen> {
  HospitalModel _selectedHospital = MockEmergencyDatabase.sampleHospitals.first;

  void _proceedToCycle2() {
    final incidentState = context.read<IncidentState>();
    incidentState.selectHospital(_selectedHospital);

    Navigator.pushReplacementNamed(context, AppRoutes.driverNavCycle2);
  }

  @override
  Widget build(BuildContext context) {
    final hospitals = MockEmergencyDatabase.sampleHospitals;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Phase 3: Select Hospital'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI-Ranked Emergency Hospitals', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Ranked by real-time drive matrix, available trauma beds, and specialty capabilities.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.separated(
                  itemCount: hospitals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final h = hospitals[index];
                    final isSelected = _selectedHospital.id == h.id;
                    final isTopRecommendation = index == 0;

                    return InkWell(
                      onTap: () => setState(() => _selectedHospital = h),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryGreen.withValues(alpha: 0.12)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryGreen : AppColors.divider,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryGreen
                                        : AppColors.surfaceElevated,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.local_hospital_rounded,
                                    color: isSelected ? Colors.black : AppColors.primaryGreen,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              h.name,
                                              style: AppTypography.titleLarge.copyWith(
                                                fontSize: 16,
                                                color: isSelected ? AppColors.primaryGreen : Colors.white,
                                              ),
                                            ),
                                          ),
                                          if (isTopRecommendation)
                                            StatusPill.verified(label: 'BEST MATCH')
                                          else
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                                                border: Border.all(
                                                  color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
                                                  width: 2,
                                                ),
                                              ),
                                              child: isSelected
                                                  ? const Center(
                                                      child: Icon(Icons.check, size: 12, color: Colors.black),
                                                    )
                                                  : null,
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        h.address,
                                        style: AppTypography.caption,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                h.specialization,
                                style: AppTypography.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Divider(color: AppColors.divider, height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildBadge('${h.distanceKm} km • ${h.driveTimeMinutes} mins ETA', Icons.navigation, AppColors.infoBlue),
                                _buildBadge('${h.availableBeds} ICU Beds', Icons.bed, AppColors.primaryGreen),
                                _buildBadge('${h.traumaCapacity} Trauma Bays', Icons.healing, AppColors.emergencyRed),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              CustomButton(
                text: 'START CYCLE 2 TO ${_selectedHospital.name.toUpperCase()}',
                icon: Icons.local_shipping_rounded,
                variant: ButtonVariant.primary,
                onPressed: _proceedToCycle2,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
