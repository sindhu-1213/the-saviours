import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/state/auth_state.dart';
import '../../core/widgets/custom_button.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLang = 'English';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'native': 'English', 'sub': 'Default System'},
    {'name': 'Hindi', 'native': 'हिन्दी', 'sub': 'Hindi'},
    {'name': 'Kannada', 'native': 'ಕನ್ನಡ', 'sub': 'Kannada'},
    {'name': 'Tamil', 'native': 'தமிழ்', 'sub': 'Tamil'},
    {'name': 'Telugu', 'native': 'తెలుగు', 'sub': 'Telugu'},
    {'name': 'Marathi', 'native': 'मराठी', 'sub': 'Marathi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Choose Language'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Select your preferred\nlanguage',
                style: AppTypography.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'You can change this anytime from Settings.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _languages[index];
                    final isSelected = _selectedLang == item['name'];

                    return InkWell(
                      onTap: () {
                        setState(() => _selectedLang = item['name']!);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryGreen.withValues(alpha: 0.12)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryGreen : AppColors.divider,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryGreen
                                    : AppColors.surfaceElevated,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  item['native']!.substring(0, 1),
                                  style: TextStyle(
                                    color: isSelected ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name']!,
                                    style: AppTypography.titleMedium.copyWith(
                                      color: isSelected ? AppColors.primaryGreen : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['native']!,
                                    style: AppTypography.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primaryGreen,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              CustomButton(
                text: 'CONTINUE',
                onPressed: () {
                  context.read<AuthState>().setLanguage(_selectedLang);
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
