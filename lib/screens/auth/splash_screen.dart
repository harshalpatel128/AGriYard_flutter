import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2500), () {
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
            const Spacer(flex: 1),
            // App Logo
            Image.asset(
              'assets/images/app_logo.png',
              height: 70,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.eco,
                size: 70,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 12),
            // Title
            const Text(
              'AgriYard',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            // Green divider dot with lines
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 40, height: 1, color: AppColors.primaryLight.withOpacity(0.4)),
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
                Container(width: 40, height: 1, color: AppColors.primaryLight.withOpacity(0.4)),
              ],
            ),
            const SizedBox(height: 14),
            // Subtitle
            const Text(
              'Daily Market Rates\nat Your Fingertips',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(flex: 1),
            // Hills Landscape Illustration
            Image.asset(
              'assets/images/splash_hills.png',
              width: size.width,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: AppColors.mintLight,
              ),
            ),
            const Spacer(flex: 1),
            // Animated Loading Spinner
            const SizedBox(
              width: 42,
              height: 42,
              child: CircularProgressIndicator(
                strokeWidth: 3.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                backgroundColor: AppColors.mintLight,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Preparing the best market data for you',
              style: TextStyle(
                fontSize: 13,
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
