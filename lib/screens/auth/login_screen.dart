import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../resources/resources.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/app_state.dart';
import '../main_navigation_screen.dart';
import '../admin/admin_navigation_screen.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

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
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              AppState().setAdminMode(true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminNavigationScreen()),
              );
            },
            child: const Text(
              AppStrings.adminLabel,
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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

                // App Logo
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

                // Email field
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

                // Password field
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

                // Forgot Password
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

                // Login Button
                CustomPrimaryButton(
                  text: AppStrings.loginBtn,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 24),

                // Divider with "or continue with"
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingM),
                      child: Text(
                        AppStrings.orContinueWith,
                        style: const TextStyle(
                          fontSize: AppDimensions.textM,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 20),

                // Social buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(
                      child: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEA4335),
                        ),
                      ),
                      onTap: _handleLogin,
                    ),
                    const SizedBox(width: 20),
                    _socialButton(
                      child: const Icon(Icons.apple,
                          size: AppDimensions.iconXL, color: Colors.black),
                      onTap: _handleLogin,
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                // Sign Up link
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

  Widget _socialButton({required Widget child, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
      child: Container(
        width: AppDimensions.socialBtnSize,
        height: AppDimensions.socialBtnSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
