import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../resources/resources.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/app_state.dart';
import '../main_navigation_screen.dart';
import 'login_screen.dart';

// User registration screen
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.validPasswordMatch),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      AppState().signup(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        (route) => false,
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
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
        ),
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
                Image.asset(
                  AppAssets.appLogo,
                  height: AppDimensions.avatarMedium,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.eco,
                    size: AppDimensions.avatarMedium,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  AppStrings.signupTitle,
                  style: TextStyle(
                    fontSize: AppDimensions.textDisplay,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  AppStrings.signupSubtitle,
                  style: TextStyle(
                    fontSize: AppDimensions.textBase,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 24),

                CustomInputField(
                  label: AppStrings.labelFullName,
                  hintText: AppStrings.hintFullName,
                  controller: _nameController,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? AppStrings.validFullName
                      : null,
                ),
                const SizedBox(height: 14),

                CustomInputField(
                  label: AppStrings.labelMobile,
                  hintText: AppStrings.hintMobile,
                  controller: _phoneController,
                  prefixIcon: Icons.phone_iphone_rounded,
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v == null || v.trim().length < AppConstants.mobileMinLength)
                      ? AppStrings.validMobile
                      : null,
                ),
                const SizedBox(height: 14),

                CustomInputField(
                  label: AppStrings.labelEmail,
                  hintText: AppStrings.hintEmail,
                  controller: _emailController,
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@'))
                      ? AppStrings.validInvalidEmail
                      : null,
                ),
                const SizedBox(height: 14),

                CustomInputField(
                  label: AppStrings.labelPassword,
                  hintText: AppStrings.hintPassword,
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  validator: (v) => (v == null || v.length < AppConstants.passwordMinLength)
                      ? AppStrings.validPasswordLength
                      : null,
                ),
                const SizedBox(height: 14),

                CustomInputField(
                  label: AppStrings.labelConfirmPassword,
                  hintText: AppStrings.hintConfirmPassword,
                  controller: _confirmPasswordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  validator: (v) => (v == null || v.isEmpty)
                      ? AppStrings.validConfirmPassword
                      : null,
                ),
                const SizedBox(height: 24),

                CustomPrimaryButton(
                  text: AppStrings.signupBtn,
                  onPressed: _handleSignup,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.alreadyAccountText,
                      style: TextStyle(
                        fontSize: AppDimensions.textBase,
                        color: AppColors.textMedium,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        AppStrings.loginLink,
                        style: TextStyle(
                          fontSize: AppDimensions.textBase,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
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
