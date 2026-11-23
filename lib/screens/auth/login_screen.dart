import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../resources/resources.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/app_state.dart';
import '../main_navigation_screen.dart';
import '../admin/admin_navigation_screen.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import 'onboarding_screen.dart';

// User login screen with specific Admin role detection
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final isAdmin = AppState().isAdminEmail(email);

      setState(() => _isLoading = true);
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        AppState().login(
          email: credential.user?.email ?? email,
          password: password,
        );
        if (mounted) {
          if (isAdmin) {
            AppState().setAdminMode(true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AdminNavigationScreen()),
            );
          } else {
            AppState().setAdminMode(false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (isAdmin && (e.code == 'user-not-found' || e.code == 'invalid-credential')) {
          try {
            final newCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
            AppState().login(email: newCred.user?.email ?? email, password: password);
            if (mounted) {
              AppState().setAdminMode(true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AdminNavigationScreen()),
              );
              return;
            }
          } catch (_) {
            AppState().login(email: email, password: password);
            if (mounted) {
              AppState().setAdminMode(true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AdminNavigationScreen()),
              );
              return;
            }
          }
        }

        String msg = 'Login failed. Please try again.';
        if (e.code == 'user-not-found') msg = 'No account found with this email.';
        if (e.code == 'wrong-password') msg = 'Wrong password. Please try again.';
        if (e.code == 'invalid-credential') msg = 'Invalid email or password.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: AppColors.error),
          );
        }
      } catch (_) {
        if (isAdmin) {
          AppState().login(email: email, password: password);
          if (mounted) {
            AppState().setAdminMode(true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AdminNavigationScreen()),
            );
            return;
          }
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
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
                    if (val == null || val.trim().isEmpty) return AppStrings.validEmail;
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
                    if (val == null || val.isEmpty) return AppStrings.validPassword;
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
                        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
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

                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.primaryGreen)
                    : CustomPrimaryButton(
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
                          MaterialPageRoute(builder: (_) => const SignupScreen()),
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
