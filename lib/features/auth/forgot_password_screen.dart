import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _identifierController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetCode() async {
    if (_identifierController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email or registered phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushNamed(context, AppRoutes.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reset Account Password', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'Enter your registered Email or Mobile number. We will send you an OTP to verify your identity before resetting.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: 'REGISTERED EMAIL OR MOBILE',
                hintText: 'e.g. name@example.com or +91 9876543210',
                controller: _identifierController,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'SEND RESET CODE',
                isLoading: _isLoading,
                onPressed: _handleSendResetCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
