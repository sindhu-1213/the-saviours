import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/incident_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';

class IncidentAuditTrail extends StatelessWidget {
  const IncidentAuditTrail({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentState = context.watch<IncidentState>();
    final active = incidentState.activeIncident;
    final logs = active?.auditLogs ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Legal Audit Trail #${active?.id ?? "INC-0819"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Export Audit Log',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.adminReportsExport),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Summary Card
              Container(
                padding: const EdgeInsets.all(18),
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
                        Text('INCIDENT ID: ${active?.id ?? "INC-2026-0819"}', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                        StatusPill.verified(label: 'TAMPER-PROOF AUDIT LOG'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(active?.locationName ?? '100ft Rd, Indiranagar, Bengaluru', style: AppTypography.titleLarge.copyWith(fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(
                      'AI Confidence: ${active?.aiConfidenceScore ?? 94}% • Criticality: ${active?.criticality.name.toUpperCase() ?? "CRITICAL"}',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('CHRONOLOGICAL AUDIT TIMELINE', style: AppTypography.caption),
              const SizedBox(height: 14),

              if (logs.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Center(child: Text('No audit entries recorded.', style: AppTypography.bodyMedium)),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    final timeStr = DateFormat('yyyy-MM-dd • HH:mm:ss').format(log.timestamp);

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(log.stage, style: AppTypography.caption.copyWith(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                              Text(timeStr, style: AppTypography.caption),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(log.action, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('Actor: ${log.actorName} (${log.actorRole})', style: AppTypography.bodyMedium),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(log.details, style: AppTypography.caption.copyWith(color: Colors.white70)),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'EXPORT SIGNED LEGAL AUDIT CERTIFICATE',
                icon: Icons.verified_rounded,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.adminReportsExport),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
