import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

import '../../mock_data/mock_emergency_database.dart';

class SignupBasicScreen extends StatefulWidget {
  const SignupBasicScreen({super.key});

  @override
  State<SignupBasicScreen> createState() => _SignupBasicScreenState();
}

class _SignupBasicScreenState extends State<SignupBasicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _badgeNumberController = TextEditingController();
  final _jurisdictionController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _vehicleNumberController.dispose();
    _badgeNumberController.dispose();
    _jurisdictionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final auth = context.read<AuthState>();
      final role = auth.pendingSignupRole;

      context.read<AuthState>().setPendingSignupDetails(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
            vehicleNumber: role == UserRole.driver ? _vehicleNumberController.text.trim() : null,
            badgeNumber: (role == UserRole.police || role == UserRole.driver || role == UserRole.admin)
                ? _badgeNumberController.text.trim()
                : null,
            jurisdictionZone: (role == UserRole.police || role == UserRole.admin)
                ? _jurisdictionController.text.trim()
                : null,
          );
      Navigator.pushNamed(context, AppRoutes.otpVerification);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final roleName = auth.pendingSignupRole.name.toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Sign Up — $roleName'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Basic Details', style: AppTypography.displayMedium),
                const SizedBox(height: 6),
                Text(
                  'We will send an OTP to verify your mobile number next.',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 28),

                CustomTextField(
                  label: 'FULL LEGAL NAME',
                  hintText: 'e.g. Aarav Sharma (as on Aadhaar/ID)',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 18),

                CustomTextField(
                  label: 'MOBILE NUMBER',
                  hintText: '+91 98765 43210',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (v) => (v == null || v.length < 10) ? 'Enter valid 10-digit mobile number' : null,
                ),
                const SizedBox(height: 18),

                CustomTextField(
                  label: 'EMAIL ADDRESS',
                  hintText: 'name@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email address' : null,
                ),
                const SizedBox(height: 18),

                if (auth.pendingSignupRole == UserRole.driver) ...[
                  CustomTextField(
                    label: 'AMBULANCE VEHICLE NUMBER',
                    hintText: 'e.g. KA-01-EA-108',
                    controller: _vehicleNumberController,
                    prefixIcon: Icons.local_hospital_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter ambulance registration number' : null,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    label: 'AMBULANCE SERVICE / BADGE ID',
                    hintText: 'e.g. AMB-108-BLR',
                    controller: _badgeNumberController,
                    prefixIcon: Icons.badge_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter service badge ID' : null,
                  ),
                  const SizedBox(height: 18),
                ] else if (auth.pendingSignupRole == UserRole.police) ...[
                  CustomTextField(
                    label: 'POLICE BADGE NUMBER',
                    hintText: 'e.g. TP-BLR-502',
                    controller: _badgeNumberController,
                    prefixIcon: Icons.badge_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter police badge number' : null,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    label: 'TRAFFIC DIVISION / JURISDICTION',
                    hintText: 'e.g. Central Traffic Division - MG Road',
                    controller: _jurisdictionController,
                    prefixIcon: Icons.traffic_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter traffic division' : null,
                  ),
                  const SizedBox(height: 18),
                ] else if (auth.pendingSignupRole == UserRole.admin) ...[
                  CustomTextField(
                    label: 'OFFICIAL AUTHORIZATION / UNIT ID',
                    hintText: 'e.g. CTRL-ROOM-HQ-01',
                    controller: _badgeNumberController,
                    prefixIcon: Icons.admin_panel_settings_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter authorization ID' : null,
                  ),
                  const SizedBox(height: 18),
                ],

                CustomTextField(
                  label: 'CREATE PASSWORD',
                  hintText: 'At least 8 characters',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 18),

                CustomTextField(
                  label: 'CONFIRM PASSWORD',
                  hintText: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                CustomButton(
                  text: 'SEND OTP VERIFICATION',
                  onPressed: _handleSubmit,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
