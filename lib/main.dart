import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'resources/resources.dart';
import 'theme/app_theme.dart';
import 'services/app_state.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/admin/admin_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  // Initialize app state
  AppState();
  runApp(const AgriYardApp());
}

class AgriYardApp extends StatelessWidget {
  const AgriYardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppConstants.routeSplash,
      routes: {
        AppConstants.routeSplash: (context) => const SplashScreen(),
        AppConstants.routeOnboarding: (context) => const OnboardingScreen(),
        AppConstants.routeLogin: (context) => const LoginScreen(),
        AppConstants.routeSignup: (context) => const SignupScreen(),
        AppConstants.routeForgotPassword: (context) =>
            const ForgotPasswordScreen(),
        AppConstants.routeMain: (context) => const MainNavigationScreen(),
        AppConstants.routeAdmin: (context) => const AdminNavigationScreen(),
      },
    );
  }
}
