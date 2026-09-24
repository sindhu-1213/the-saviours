import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../mock_data/mock_emergency_database.dart';

class KycUploadScreen extends StatefulWidget {
  const KycUploadScreen({super.key});

  @override
  State<KycUploadScreen> createState() => _KycUploadScreenState();
}

class _KycUploadScreenState extends State<KycUploadScreen> {
  final _docNumberController = TextEditingController();
  final Map<String, bool> _uploadedDocs = {};
  bool _isSubmitting = false;

  @override
  void dispose() {
    _docNumberController.dispose();
    super.dispose();
  }

  void _simulateUpload(String docTitle) {
    setState(() {
      _uploadedDocs[docTitle] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$docTitle uploaded & encrypted successfully!'),
        backgroundColor: AppColors.primaryGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submitKyc() async {
    final docNum = _docNumberController.text.trim();
    if (docNum.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your document / ID number'),
          backgroundColor: AppColors.emergencyRed,
        ),
      );
      return;
    }

    final auth = context.read<AuthState>();
    final role = auth.currentUser?.role ?? auth.pendingSignupRole;
    final docType = _getDocTypeTitle(role);

    setState(() => _isSubmitting = true);
    await auth.submitKycDocuments(docType: docType, docNumber: docNum);
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (role == UserRole.civilian) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.civilianHome,
        (r) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.verificationPending,
        (r) => false,
      );
    }
  }

  String _getDocTypeTitle(UserRole role) {
    switch (role) {
      case UserRole.civilian:
        return 'Aadhaar Card (Front/Back)';
      case UserRole.driver:
        return 'Commercial Driving Licence & Ambulance Service Badge';
      case UserRole.police:
        return 'Police Department ID & Duty Verification';
      case UserRole.admin:
        return 'Government Official Authorization';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final role = auth.currentUser?.role ?? auth.pendingSignupRole;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Identity & KYC Verification'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upload Documents', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Upload valid government credentials to activate emergency coordination features.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Security Encrypted Badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security_rounded, color: AppColors.primaryGreen, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('256-Bit Encrypted KYC Vault', style: AppTypography.titleMedium.copyWith(fontSize: 13)),
                          Text('Documents are securely stored with restricted access.', style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Document Number Input
              CustomTextField(
                label: role == UserRole.civilian
                    ? '12-DIGIT AADHAAR NUMBER'
                    : (role == UserRole.driver
                        ? 'COMMERCIAL DL NUMBER'
                        : (role == UserRole.police ? 'POLICE BADGE / SERVICE ID' : 'GOVERNMENT AUTHORIZATION ID')),
                hintText: role == UserRole.civilian
                    ? 'e.g. 9812 3456 7890'
                    : (role == UserRole.driver
                        ? 'e.g. KA-04-2019-00912'
                        : (role == UserRole.police ? 'e.g. BTP-SI-2024-88' : 'e.g. GOVT-AUTH-2024-HQ')),
                controller: _docNumberController,
                prefixIcon: Icons.badge_outlined,
              ),

              const SizedBox(height: 24),

              Text('REQUIRED DOCUMENT PROOFS', style: AppTypography.caption),
              const SizedBox(height: 12),

              if (role == UserRole.civilian) ...[
                _buildUploadTile('Aadhaar Card Front (Photo + Details)'),
                const SizedBox(height: 12),
                _buildUploadTile('Aadhaar Card Back (Address)'),
              ] else if (role == UserRole.driver) ...[
                _buildUploadTile('Commercial Driving Licence (DL)'),
                const SizedBox(height: 12),
                _buildUploadTile('Ambulance 108 Service / Hospital ID'),
                const SizedBox(height: 12),
                _buildUploadTile('Vehicle Registration Certificate (RC)'),
              ] else if (role == UserRole.police) ...[
                _buildUploadTile('State Police Identity Card'),
                const SizedBox(height: 12),
                _buildUploadTile('Traffic Junction Station Order / Duty Deputation'),
              ] else if (role == UserRole.admin) ...[
                _buildUploadTile('Central Government ID / Official Order'),
                const SizedBox(height: 12),
                _buildUploadTile('Control Room Authorization Certificate'),
              ],

              const SizedBox(height: 36),

              CustomButton(
                text: 'SUBMIT FOR VERIFICATION',
                isLoading: _isSubmitting,
                onPressed: _submitKyc,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadTile(String title) {
    final isUploaded = _uploadedDocs[title] ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUploaded ? AppColors.primaryGreen : AppColors.divider,
          width: isUploaded ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isUploaded
                  ? AppColors.primaryGreen.withValues(alpha: 0.2)
                  : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isUploaded ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
              color: isUploaded ? AppColors.primaryGreen : AppColors.textSecondary,
              size: 24,
            ),
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
                    color: isUploaded ? AppColors.primaryGreen : Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isUploaded ? 'File attached (image_scan.jpg)' : 'Tap upload to capture or choose file',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _simulateUpload(title),
            style: ElevatedButton.styleFrom(
              backgroundColor: isUploaded ? AppColors.surfaceElevated : AppColors.primaryGreen,
              foregroundColor: isUploaded ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(60, 36),
            ),
            child: Text(
              isUploaded ? 'CHANGE' : 'UPLOAD',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
