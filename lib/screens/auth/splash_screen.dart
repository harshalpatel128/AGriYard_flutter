import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../resources/resources.dart';
import 'onboarding_screen.dart';

// Splash screen with initial loading animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward();

    _timer = Timer(AppConstants.splashDuration, () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.appLogo,
                      height: AppDimensions.logoHeightLarge,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.eco,
                        size: 70,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: AppDimensions.textBrand,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 1.5,
                          color: AppColors.primaryLight.withOpacity(0.4),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 48,
                          height: 1.5,
                          color: AppColors.primaryLight.withOpacity(0.4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Daily Market Rates\nat Your Fingertips',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.textXL,
                        height: 1.4,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 1),

            Image.asset(
              AppAssets.splashHills,
              width: size.width,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: AppColors.mintLight,
              ),
            ),

            const Spacer(flex: 1),

            const SizedBox(
              width: AppDimensions.progressIndicatorSize,
              height: AppDimensions.progressIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: AppDimensions.progressIndicatorStroke,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                backgroundColor: AppColors.mintLight,
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              AppStrings.splashLoading,
              style: TextStyle(
                fontSize: AppDimensions.textXXL,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              AppStrings.splashSubtitle,
              style: TextStyle(
                fontSize: AppDimensions.textM,
                color: AppColors.textLight,
              ),
            ),

            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
