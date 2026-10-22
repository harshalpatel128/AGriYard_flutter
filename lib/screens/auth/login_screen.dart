import 'package:flutter/material.dart';
import '../../resources/resources.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/app_state.dart';
import '../main_navigation_screen.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import 'onboarding_screen.dart';

// User login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController =
      TextEditingController(text: AppConstants.defaultUserEmail);
  final _passwordController = TextEditingController(text: 'password123');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      AppState().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: AppDimensions.iconM,
            color: AppColors.textDark,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
              );
            }
          },
        ),
        actions: const [],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingHLarge,
            vertical: AppDimensions.paddingS,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),

                Image.asset(
                  AppAssets.appLogo,
                  height: AppDimensions.logoHeight,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.eco,
                    size: AppDimensions.logoHeight,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  AppStrings.loginTitle,
                  style: TextStyle(
                    fontSize: AppDimensions.textDisplay,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  AppStrings.loginSubtitle,
                  style: TextStyle(
                    fontSize: AppDimensions.textBase,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 32),

                CustomInputField(
                  label: AppStrings.labelEmail,
                  hintText: AppStrings.hintEmail,
                  controller: _emailController,
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return AppStrings.validEmail;
                    }
                    if (!val.contains('@')) return AppStrings.validInvalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  label: AppStrings.labelPassword,
                  hintText: AppStrings.hintPassword,
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return AppStrings.validPassword;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      AppStrings.forgotPassword,
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.textM,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                CustomPrimaryButton(
                  text: AppStrings.loginBtn,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.noAccountText,
                      style: TextStyle(
                        fontSize: AppDimensions.textBase,
                        color: AppColors.textMedium,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        AppStrings.signUpLink,
                        style: TextStyle(
                          fontSize: AppDimensions.textBase,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
