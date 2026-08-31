import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/state/incident_state.dart';

class ReportAccidentCamera extends StatefulWidget {
  const ReportAccidentCamera({super.key});

  @override
  State<ReportAccidentCamera> createState() => _ReportAccidentCameraState();
}

class _ReportAccidentCameraState extends State<ReportAccidentCamera> {
  final double _lat = 12.9784;
  final double _lng = 77.6408;
  final String _locationName = '100ft Rd, Indiranagar, Bengaluru';
  bool _isCapturing = false;
  String _currentTime = '';
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateClock());
  }

  void _updateClock() {
    setState(() {
      _currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  Future<void> _captureAndSubmit() async {
    setState(() => _isCapturing = true);

    final auth = context.read<AuthState>();
    final incidentState = context.read<IncidentState>();

    // Route to AI verifying screen where progress animation runs
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.civilianAiVerifying,
    );

    // Trigger AI verification in background
    incidentState.reportAccident(
      reporterId: auth.currentUser?.id ?? 'USR-CIV-001',
      reporterName: auth.currentUser?.name ?? 'Aarav Sharma',
      locationName: _locationName,
      lat: _lat,
      lng: _lng,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simulated Fullscreen Camera Viewfinder
          Positioned.fill(
            child: Container(
              color: const Color(0xFF101418),
              child: Stack(
                children: [
                  // Viewfinder Target Grid
                  Center(
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.emergencyRed.withValues(alpha: 0.8),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          // Corner brackets
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppColors.emergencyRed, width: 3),
                                  left: BorderSide(color: AppColors.emergencyRed, width: 3),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppColors.emergencyRed, width: 3),
                                  right: BorderSide(color: AppColors.emergencyRed, width: 3),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.emergencyRed, width: 3),
                                  left: BorderSide(color: AppColors.emergencyRed, width: 3),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.emergencyRed, width: 3),
                                  right: BorderSide(color: AppColors.emergencyRed, width: 3),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: AppColors.emergencyRed,
                                  size: 42,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'ALIGN ACCIDENT SCENE',
                                  style: AppTypography.caption.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Header & Metadata HUD
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.emergencyRed),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.emergencyRed,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'LIVE SECURE CAPTURE ONLY',
                                style: AppTypography.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.flash_auto, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Auto-Attached Live Metadata Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.gps_fixed, size: 14, color: AppColors.primaryGreen),
                              const SizedBox(width: 6),
                              Text(
                                'GPS: $_lat, $_lng • $_locationName',
                                style: AppTypography.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: AppColors.primaryGreen),
                              const SizedBox(width: 6),
                              Text(
                                'TIMESTAMP: $_currentTime UTC+5:30',
                                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Shutter Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    Text(
                      'Gallery uploads disabled by security policy to prevent fraud.',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Shutter Button
                        GestureDetector(
                          onTap: _isCapturing ? null : _captureAndSubmit,
                          child: Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.emergencyRed,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.emergencyRed.withValues(alpha: 0.6),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.camera,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
