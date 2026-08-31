import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/live_map_view.dart';
import '../../core/widgets/status_pill.dart';

class LiveAmbulanceMap extends StatelessWidget {
  const LiveAmbulanceMap({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live Ambulance Radar'),
        actions: [
          StatusPill.cleared(
            label: incidentState.isGreenCorridorActive ? 'GREEN CORRIDOR' : 'MONITORING',
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LiveMapView(
                ambulanceLat: incidentState.ambulanceLat,
                ambulanceLng: incidentState.ambulanceLng,
                destinationName: active?.locationName ?? '100ft Rd, Indiranagar',
                etaMinutes: incidentState.estimatedArrivalMinutes,
                isGreenCorridor: incidentState.isGreenCorridorActive,
                height: double.infinity,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: CustomButton(
                text: 'OPEN "TRAFFIC CLEARED" ACTION SCREEN',
                icon: Icons.traffic_rounded,
                variant: ButtonVariant.primary,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.policeTrafficClearance);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
