import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../resources/resources.dart';
import '../../widgets/custom_button.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXXL,
            vertical: AppDimensions.paddingL,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Welcome text
              const Text(
                AppStrings.onboardingWelcome,
                style: TextStyle(
                  fontSize: AppDimensions.textXL,
                  color: AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: AppDimensions.textBrand,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.appSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimensions.textBase,
                  height: 1.4,
                  color: AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 28),

              // Farmer & Tractor Graphic
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: AppDimensions.onboardingGreenBump,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD4EED8),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(260, 90),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        AppAssets.onboardingFarmer,
                        height: AppDimensions.onboardingFarmerHeight,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          size: 80,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Image.asset(
                          AppAssets.onboardingTractor,
                          height: AppDimensions.onboardingTractorHeight,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.agriculture,
                            size: 40,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Feature rows
              _buildFeatureRow(
                icon: Icons.check_circle_outline_rounded,
                title: AppStrings.feature1Title,
                subtitle: AppStrings.feature1Subtitle,
              ),
              const SizedBox(height: 20),
              _buildFeatureRow(
                icon: Icons.show_chart_rounded,
                title: AppStrings.feature2Title,
                subtitle: AppStrings.feature2Subtitle,
              ),
              const SizedBox(height: 20),
              _buildFeatureRow(
                icon: Icons.storefront_outlined,
                title: AppStrings.feature3Title,
                subtitle: AppStrings.feature3Subtitle,
              ),
              const SizedBox(height: 32),

              // Page dot indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) => _buildDot(i == 0)),
              ),
              const SizedBox(height: 24),

              // Get Started button
              CustomPrimaryButton(
                text: AppStrings.onboardingGetStarted,
                hasArrow: true,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool active) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: AnimatedContainer(
        duration: AppConstants.animationNormal,
        width: active
            ? AppDimensions.indicatorDotSize *
                AppDimensions.indicatorDotActiveFactor
            : AppDimensions.indicatorDotSize,
        height: AppDimensions.indicatorDotSize,
        decoration: BoxDecoration(
          color: active ? AppColors.primaryGreen : const Color(0xFFD1D5DB),
          borderRadius:
              BorderRadius.circular(AppDimensions.indicatorDotSize / 2),
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: AppDimensions.cardIconSize,
          height: AppDimensions.cardIconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF90D2A6),
              width: AppDimensions.borderThick,
            ),
            color: const Color(0xFFF1FAF3),
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: AppDimensions.iconXL),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppDimensions.textL,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: AppDimensions.textM,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
