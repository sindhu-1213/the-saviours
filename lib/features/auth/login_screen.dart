import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../mock_data/mock_emergency_database.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController(text: 'aarav@civilian.saviours.org');
  final _passwordController = TextEditingController(text: 'Password@123');
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    final auth = context.read<AuthState>();
    final success = await auth.login(
      _identifierController.text.trim(),
      _passwordController.text,
    );

    if (!mounted || !success) return;

    if (auth.isPending) {
      Navigator.pushReplacementNamed(context, AppRoutes.verificationPending);
      return;
    }

    if (auth.isRejected) {
      Navigator.pushReplacementNamed(context, AppRoutes.verificationRejected);
      return;
    }

    switch (auth.currentRole) {
      case UserRole.civilian:
        Navigator.pushReplacementNamed(context, AppRoutes.civilianHome);
        break;
      case UserRole.driver:
        Navigator.pushReplacementNamed(context, AppRoutes.driverHome);
        break;
      case UserRole.police:
        Navigator.pushReplacementNamed(context, AppRoutes.policeHome);
        break;
      case UserRole.admin:
        Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
        break;
    }
  }

  void _fillDemoCredentials(UserRole role) {
    switch (role) {
      case UserRole.civilian:
        _identifierController.text = 'aarav@civilian.saviours.org';
        break;
      case UserRole.driver:
        _identifierController.text = 'rajesh@ambulance.saviours.org';
        break;
      case UserRole.police:
        _identifierController.text = 'vikram.rao@traffic.saviours.org';
        break;
      case UserRole.admin:
        _identifierController.text = 'admin@control.saviours.org';
        break;
    }
    _passwordController.text = 'Saviours@2026';
    setState(() {});
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Logo Icon
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.emergency_share_rounded,
                      size: 32,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Welcome back to\nSaviours', style: AppTypography.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'Log in with your registered Email or Mobile number.',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Inputs
                CustomTextField(
                  label: 'EMAIL OR MOBILE NUMBER',
                  hintText: 'e.g. name@example.com or +91 9876543210',
                  controller: _identifierController,
                  prefixIcon: Icons.account_circle_outlined,
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  label: 'PASSWORD',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.forgotPassword);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                CustomButton(
                  text: 'LOG IN',
                  isLoading: auth.isLoading,
                  onPressed: _handleLogin,
                ),

                const SizedBox(height: 24),

                // Quick Demo Login Persona Chips
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flash_on, size: 16, color: AppColors.primaryGreen),
                          const SizedBox(width: 6),
                          Text(
                            'ONE-TAP DEMO PREVIEW LOGIN:',
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildRoleChip('Civilian', UserRole.civilian, Icons.person),
                          _buildRoleChip('Ambulance 108', UserRole.driver, Icons.local_hospital),
                          _buildRoleChip('Traffic Police', UserRole.police, Icons.traffic),
                          _buildRoleChip('Admin Control', UserRole.admin, Icons.admin_panel_settings),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Sign Up link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.roleSelection);
                        },
                        child: Text(
                          'Register Now',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleChip(String label, UserRole role, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      backgroundColor: AppColors.surfaceElevated,
      side: const BorderSide(color: AppColors.divider),
      onPressed: () => _fillDemoCredentials(role),
    );
  }
}
