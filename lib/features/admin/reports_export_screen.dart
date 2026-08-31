import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';

class ReportsExportScreen extends StatefulWidget {
  const ReportsExportScreen({super.key});

  @override
  State<ReportsExportScreen> createState() => _ReportsExportScreenState();
}

class _ReportsExportScreenState extends State<ReportsExportScreen> {
  String _selectedReportType = 'DAILY';
  String _selectedFormat = 'PDF';
  bool _isGenerating = false;

  Future<void> _generateReport() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isGenerating = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saviours_${_selectedReportType}_Report.$_selectedFormat downloaded successfully!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports & Compliance Export'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Generate Official Reports', style: AppTypography.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Export certified analytics, green corridor performance, and legal incident timelines for government and police audit compliance.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),

              Text('REPORT TIMEFRAME', style: AppTypography.caption),
              const SizedBox(height: 10),

              Row(
                children: ['DAILY', 'WEEKLY', 'MONTHLY', 'CUSTOM'].map((t) {
                  final isSel = _selectedReportType == t;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSel,
                      label: Text(t, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                      selectedColor: AppColors.primaryGreen,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(color: isSel ? Colors.black : Colors.white),
                      side: const BorderSide(color: AppColors.divider),
                      onSelected: (_) => setState(() => _selectedReportType = t),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              Text('EXPORT FORMAT', style: AppTypography.caption),
              const SizedBox(height: 10),

              Row(
                children: ['PDF', 'CSV', 'JSON'].map((f) {
                  final isSel = _selectedFormat == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSel,
                      label: Text(f, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                      selectedColor: AppColors.infoBlue,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(color: isSel ? Colors.black : Colors.white),
                      side: const BorderSide(color: AppColors.divider),
                      onSelected: (_) => setState(() => _selectedFormat = f),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              Text('REPORT INCLUSIONS', style: AppTypography.caption),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildCheck('Total Accident Reports & AI Confidence Distribution', true),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildCheck('Ambulance 108 Response Time vs SLA Benchmarks', true),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildCheck('Traffic Police Junction Clearance Timestamp Logs', true),
                    const Divider(color: AppColors.divider, height: 16),
                    _buildCheck('Hospital ICU Bed Handoff Logs & Patient Outcomes', true),
                  ],
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'GENERATE & DOWNLOAD REPORT',
                icon: Icons.download_rounded,
                isLoading: _isGenerating,
                onPressed: _generateReport,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheck(String text, bool isDone) {
    return Row(
      children: [
        Icon(Icons.check_box_rounded, color: AppColors.primaryGreen, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTypography.bodyMedium)),
      ],
    );
  }
}
