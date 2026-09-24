import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class DriverTripHistory extends StatelessWidget {
  const DriverTripHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final trips = incidentState.trips.isNotEmpty
        ? incidentState.trips
        : MockEmergencyDatabase.samplePastTrips;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ambulance Trip History'),
      ),
      body: SafeArea(
        child: trips.isEmpty
            ? Center(
                child: Text('No previous trips found.', style: AppTypography.bodyMedium),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                itemCount: trips.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  final timeStr = DateFormat('MMM dd, yyyy • hh:mm a').format(trip.startTime);

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              trip.id,
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            StatusPill.verified(label: trip.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          trip.hospitalName,
                          style: AppTypography.titleLarge.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'From: ${trip.location}',
                          style: AppTypography.bodyMedium,
                        ),
                        const Divider(color: AppColors.divider, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(timeStr, style: AppTypography.caption),
                            Text(
                              '${trip.distanceKm} km • ${trip.totalMinutes} mins',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
