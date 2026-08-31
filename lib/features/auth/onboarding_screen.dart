import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'icon': Icons.camera_alt_rounded,
      'color': AppColors.emergencyRed,
      'title': 'Instant AI-Verified\nAccident Reporting',
      'desc': 'Capture live photographic evidence directly from the camera. Google Gemini Vision AI verifies the accident scene in seconds.',
    },
    {
      'icon': Icons.medical_services_rounded,
      'color': AppColors.infoBlue,
      'title': 'Rapid Ambulance\nDispatch & Routing',
      'desc': 'Instantly connects the nearest 108 emergency ambulance with live turn-by-turn navigation and casualty triage prioritization.',
    },
    {
      'icon': Icons.traffic_rounded,
      'color': AppColors.corridorGreen,
      'title': 'Dynamic Green Corridor\nTraffic Coordination',
      'desc': 'Traffic police officers receive geo-fenced alerts to pre-clear junctions ahead, turning routes into guaranteed green corridors.',
    },
    {
      'icon': Icons.local_hospital_rounded,
      'color': AppColors.primaryGreen,
      'title': 'Smart Hospital Selection\n& Full Audit Trail',
      'desc': 'AI ranks emergency hospitals by real-time distance, ICU beds, and trauma capability, logging every timestamp for full accountability.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.language);
            },
            child: Text(
              'SKIP',
              style: AppTypography.button.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final item = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (item['color'] as Color).withValues(alpha: 0.15),
                            border: Border.all(
                              color: (item['color'] as Color).withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              item['icon'] as IconData,
                              size: 64,
                              color: item['color'] as Color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          item['title'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.displayMedium.copyWith(height: 1.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item['desc'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Dot Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColors.primaryGreen
                          : AppColors.surfaceHighlight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              CustomButton(
                text: _currentIndex == _slides.length - 1 ? 'GET STARTED' : 'CONTINUE',
                onPressed: () {
                  if (_currentIndex < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, AppRoutes.language);
                  }
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
