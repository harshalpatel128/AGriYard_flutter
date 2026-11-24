import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
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

      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final fullName = '$firstName $lastName'.trim();

      setState(() => _isLoading = true);
      try {
        // Firebase Auth માં account બનાવો
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        await credential.user?.updateDisplayName(fullName);

        // Firestore Database માં user ની info save કરો
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user?.uid)
            .set({
          'uid': credential.user?.uid,
          'name': fullName,
          'firstName': firstName,
          'lastName': lastName,
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'farmer',
        });

        // App State update કરો
        AppState().signup(
          name: fullName,
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        String msg = 'Signup failed. Please try again.';
        if (e.code == 'email-already-in-use') msg = 'This email is already registered.';
        if (e.code == 'weak-password') msg = 'Password is too weak. Use at least 6 characters.';
        if (e.code == 'invalid-email') msg = 'Invalid email format.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: AppColors.error),
          );
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

                Row(
                  children: [
                    Expanded(
                      child: CustomInputField(
                        label: 'First Name',
                        hintText: 'e.g. Ramesh',
                        controller: _firstNameController,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter first name'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomInputField(
                        label: 'Last Name',
                        hintText: 'e.g. Patel',
                        controller: _lastNameController,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter last name'
                            : null,
                      ),
                    ),
                  ],
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

                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.primaryGreen)
                    : CustomPrimaryButton(
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
