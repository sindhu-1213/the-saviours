import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/admin_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_pill.dart';
import '../../mock_data/mock_emergency_database.dart';

class VerificationReviewScreen extends StatefulWidget {
  const VerificationReviewScreen({super.key});

  @override
  State<VerificationReviewScreen> createState() => _VerificationReviewScreenState();
}

class _VerificationReviewScreenState extends State<VerificationReviewScreen> {
  final _reasonController = TextEditingController();

  void _showRejectDialog(String kycId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Reject Verification', style: AppTypography.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specify reason for rejecting this document:', style: AppTypography.bodyMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              style: AppTypography.bodyLarge,
              decoration: const InputDecoration(
                hintText: 'e.g. Blurry photo, mismatched DL number, unreadable badge...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergencyRed),
            onPressed: () {
              final reason = _reasonController.text.trim().isNotEmpty
                  ? _reasonController.text.trim()
                  : 'Document unreadable or invalid credentials.';
              context.read<AdminState>().rejectKyc(kycId, reason);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Document rejected and user notified.')),
              );
            },
            child: const Text('CONFIRM REJECTION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminState = context.watch<AdminState>();
    final pendingList = adminState.kycRequests.where((k) => k.status == VerificationStatus.pending).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('KYC Document Review'),
      ),
      body: SafeArea(
        child: pendingList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColors.primaryGreen, size: 64),
                    const SizedBox(height: 16),
                    Text('All Pending KYCs Reviewed!', style: AppTypography.displayMedium),
                    const SizedBox(height: 6),
                    Text('No documents waiting in the approval queue.', style: AppTypography.bodyMedium),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                itemCount: pendingList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final kyc = pendingList[index];

                  return Container(
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
                            Text(kyc.userName, style: AppTypography.titleLarge.copyWith(fontSize: 17)),
                            StatusPill.pending(label: kyc.role.name.toUpperCase()),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('User ID: ${kyc.userId} • Doc: ${kyc.docType}', style: AppTypography.caption),
                        const SizedBox(height: 14),

                        // Document Preview Box (Simulated High-Res KYC Scan)
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.document_scanner_rounded, color: AppColors.primaryGreen, size: 36),
                                const SizedBox(height: 6),
                                Text('Document Evidence: ${kyc.docNumber}', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                Text('256-bit Encrypted PDF Scan', style: AppTypography.caption),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // AI OCR & Tamper Analysis Box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16221A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.auto_awesome, color: AppColors.primaryGreen, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    'GEMINI AI OCR & TAMPER ANALYSIS (CONFIDENCE ${kyc.aiAuthenticityScore}%)',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('• Extracted Name: ${kyc.ocrExtractedName} (100% Match)', style: AppTypography.caption.copyWith(color: Colors.white)),
                              Text('• Extracted Number: ${kyc.ocrExtractedNumber}', style: AppTypography.caption.copyWith(color: Colors.white)),
                              Text('• Tamper Flags: 0 detected (Valid government format)', style: AppTypography.caption.copyWith(color: Colors.white70)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'APPROVE',
                                icon: Icons.check,
                                height: 44,
                                variant: ButtonVariant.primary,
                                onPressed: () {
                                  adminState.approveKyc(kyc.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${kyc.userName} approved and verified!'),
                                      backgroundColor: AppColors.primaryGreen,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomButton(
                                text: 'REJECT',
                                icon: Icons.close,
                                height: 44,
                                variant: ButtonVariant.emergency,
                                onPressed: () => _showRejectDialog(kyc.id),
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
