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
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email/phone and password'),
          backgroundColor: AppColors.emergencyRed,
        ),
      );
      return;
    }

    final auth = context.read<AuthState>();
    final success = await auth.login(identifier, password);

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Login failed. Please check credentials or Register.'),
          backgroundColor: AppColors.emergencyRed,
        ),
      );
      return;
    }

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
                // Top Header Row with Logo and Language Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
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
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.language),
                          icon: const Icon(Icons.language, size: 16, color: AppColors.primaryGreen),
                          label: Text(
                            auth.selectedLanguage,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.surfaceElevated,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Explore App Tour',
                          icon: const Icon(Icons.help_outline_rounded, color: AppColors.textSecondary),
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.onboarding),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text('Sign In to\nSaviours', style: AppTypography.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'Enter your registered email and password to access the system.',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Inputs
                CustomTextField(
                  label: 'EMAIL OR MOBILE NUMBER',
                  hintText: 'e.g. user@example.com',
                  controller: _identifierController,
                  prefixIcon: Icons.account_circle_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  label: 'PASSWORD',
                  hintText: 'Enter your account password',
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
                const SizedBox(height: 24),

                // Submit Button
                CustomButton(
                  text: 'LOG IN',
                  isLoading: auth.isLoading,
                  onPressed: _handleLogin,
                ),

                const SizedBox(height: 36),

                // Sign Up Section
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'New to Saviours Platform?',
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Register as Civilian, Ambulance Driver, Traffic Police, or Admin Control Room.',
                        textAlign: TextAlign.center,
                        style: AppTypography.caption,
                      ),
                      const SizedBox(height: 14),
                      CustomButton(
                        text: 'REGISTER NEW ACCOUNT',
                        variant: ButtonVariant.outline,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.roleSelection);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
