import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/live_map_view.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class LiveIncidentTracking extends StatelessWidget {
  const LiveIncidentTracking({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Incident #${active?.id ?? "INC-0819"}'),
        actions: [
          StatusPill.critical(label: 'LIVE DISPATCH'),
          const SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live Radar Map View
              LiveMapView(
                ambulanceLat: incidentState.ambulanceLat,
                ambulanceLng: incidentState.ambulanceLng,
                destinationName: active?.locationName ?? 'Indiranagar 100ft Rd',
                etaMinutes: incidentState.estimatedArrivalMinutes,
                isGreenCorridor: incidentState.isGreenCorridorActive,
                height: 280,
              ),

              const SizedBox(height: 20),

              // Green Corridor Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: incidentState.isGreenCorridorActive
                      ? AppColors.corridorGreen.withValues(alpha: 0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: incidentState.isGreenCorridorActive
                        ? AppColors.corridorGreen
                        : AppColors.divider,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.traffic_rounded,
                      color: incidentState.isGreenCorridorActive
                          ? AppColors.corridorGreen
                          : AppColors.warningOrange,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            incidentState.isGreenCorridorActive
                                ? 'GREEN CORRIDOR SYNCHRONIZED'
                                : 'TRAFFIC CLEARANCE IN PROGRESS',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 13,
                              color: incidentState.isGreenCorridorActive
                                  ? AppColors.corridorGreen
                                  : Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            incidentState.isGreenCorridorActive
                                ? 'Traffic Police cleared junctions. Priority corridor enabled.'
                                : 'Police officers dispatched to pre-clear upcoming intersections.',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 4-Stage Progress Stepper
              Text('RESPONSE LIFECYCLE PROGRESS', style: AppTypography.caption),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildStep(
                      title: 'Incident Verified & Dispatched',
                      subtitle: 'AI validated scene. Nearest ambulance assigned.',
                      isCompleted: true,
                      isActive: false,
                    ),
                    _buildStep(
                      title: 'Ambulance En Route to Scene',
                      subtitle: 'Vehicle KA-01-EA-108 • ETA ~ ${incidentState.estimatedArrivalMinutes} mins',
                      isCompleted: active?.status == IncidentStatus.patientOnboard ||
                          active?.status == IncidentStatus.hospitalTransport ||
                          active?.status == IncidentStatus.completed,
                      isActive: active?.status == IncidentStatus.driverDispatched,
                    ),
                    _buildStep(
                      title: 'Patient Secured Onboard',
                      subtitle: 'Triage complete. Hospital suggestion engine active.',
                      isCompleted: active?.status == IncidentStatus.hospitalTransport ||
                          active?.status == IncidentStatus.completed,
                      isActive: active?.status == IncidentStatus.patientOnboard,
                    ),
                    _buildStep(
                      title: 'Transport to Emergency Hospital',
                      subtitle: active?.assignedHospitalName ?? 'Hospital selection in progress',
                      isCompleted: active?.status == IncidentStatus.completed,
                      isActive: active?.status == IncidentStatus.hospitalTransport,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Driver Contact Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryGreen,
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.black, size: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rajesh Kumar (Pilot)', style: AppTypography.titleMedium),
                          const SizedBox(height: 2),
                          Text('Ambulance KA-01-EA-108', style: AppTypography.bodyMedium),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone, color: AppColors.primaryGreen),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calling Driver Rajesh Kumar (+91 98450 11208)...')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              CustomButton(
                text: 'REFRESH LIVE RADAR',
                variant: ButtonVariant.outline,
                onPressed: () {},
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    bool isLast = false,
  }) {
    Color stepColor = isCompleted
        ? AppColors.primaryGreen
        : (isActive ? AppColors.warningOrange : AppColors.textMuted);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.primaryGreen : Colors.transparent,
                border: Border.all(color: stepColor, width: 2),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.black)
                  : (isActive
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: stepColor,
                            ),
                          ),
                        )
                      : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 38,
                color: isCompleted ? AppColors.primaryGreen : AppColors.divider,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 14,
                  color: isCompleted || isActive ? Colors.white : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTypography.caption),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
