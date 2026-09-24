import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsRemaining = 45;
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        t.cancel();
      }
    });
  }

  void _fillDemoOtp() {
    const demoPin = '108502';
    for (int i = 0; i < 6; i++) {
      _controllers[i].text = demoPin[i];
    }
    setState(() {});
  }

  Future<void> _verifyOtp() async {
    final enteredOtp = _controllers.map((c) => c.text).join();
    if (enteredOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 6-digit OTP')),
      );
      return;
    }

    final auth = context.read<AuthState>();
    if (auth.pendingSignupEmail == null || auth.pendingSignupEmail!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing registration details. Please go back and fill the form.'),
          backgroundColor: AppColors.emergencyRed,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);
    final success = await auth.registerAccount(
      name: auth.pendingSignupName ?? 'New User',
      email: auth.pendingSignupEmail!,
      phone: auth.pendingSignupPhone ?? '+91 98765 43210',
      password: auth.pendingSignupPassword ?? 'Password@123',
      role: auth.pendingSignupRole,
      vehicleNumber: auth.pendingVehicleNumber,
      badgeNumber: auth.pendingBadgeNumber,
      jurisdictionZone: auth.pendingJurisdictionZone,
    );
    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (!success) {
      final errorMsg = auth.errorMessage ?? 'Registration failed. Please try again.';
      final isAlreadyRegistered = errorMsg.toLowerCase().contains('already') || 
                                  errorMsg.toLowerCase().contains('registered') || 
                                  errorMsg.toLowerCase().contains('exists');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: AppColors.emergencyRed,
          duration: const Duration(seconds: 5),
          action: isAlreadyRegistered
              ? SnackBarAction(
                  label: 'SIGN IN',
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
                  },
                )
              : null,
        ),
      );
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.kycUpload);
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final phone = auth.pendingSignupPhone ?? '+91 98765 43210';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('OTP Verification')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verify Phone Number', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'We have sent a 6-digit verification code to $phone.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 36),

              // 6-digit PIN input row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: AppColors.surfaceElevated,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (val.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Countdown / Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _secondsRemaining > 0
                        ? 'Resend code in ${_secondsRemaining}s'
                        : 'Did not receive code?',
                    style: AppTypography.caption,
                  ),
                  TextButton(
                    onPressed: _secondsRemaining == 0 ? _startTimer : null,
                    child: Text(
                      'RESEND OTP',
                      style: AppTypography.caption.copyWith(
                        color: _secondsRemaining == 0
                            ? AppColors.primaryGreen
                            : AppColors.textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _fillDemoOtp,
                icon: const Icon(Icons.auto_fix_high, size: 16),
                label: const Text('Auto-fill Demo OTP (108502)', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: const BorderSide(color: AppColors.primaryGreen),
                  minimumSize: const Size(double.infinity, 42),
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'VERIFY & CONTINUE',
                isLoading: _isVerifying,
                onPressed: _verifyOtp,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
