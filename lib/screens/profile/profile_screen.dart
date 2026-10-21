import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../resources/resources.dart';
import '../../services/app_state.dart';
import '../../widgets/app_curved_header.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';
import '../admin/admin_navigation_screen.dart';
import 'change_password_screen.dart';
import 'contact_help_screen.dart';

class ProfileScreen extends StatelessWidget {
  final bool isTab;
  final ValueChanged<int>? onNavigateTab;
  const ProfileScreen({super.key, this.isTab = true, this.onNavigateTab});

  void _showPersonalInfoDialog(BuildContext context) {
    final user = AppState().currentUser;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        title: const Text(
          AppStrings.profilePersonalInfo,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(AppStrings.profileName, user.name),
            const SizedBox(height: 12),
            _infoRow(AppStrings.profileMobile, user.phoneNumber),
            const SizedBox(height: 12),
            _infoRow(AppStrings.profileEmail, user.email),
            const SizedBox(height: 12),
            _infoRow(AppStrings.profileRole, AppStrings.profileRoleFarmer),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              AppStrings.okBtn,
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppDimensions.textSM,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppDimensions.textBase,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        title: const Text(
          AppStrings.profileLogoutTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(AppStrings.profileLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              AppStrings.profileCancelBtn,
              style: TextStyle(color: AppColors.textMedium),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.priceFallRed,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusM),
              ),
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              AppState().logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              AppStrings.profileLogout,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppState().currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppCurvedHeader(
              height: AppDimensions.profileHeaderHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingXL,
                  vertical: AppDimensions.paddingS,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isTab)
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: AppDimensions.iconM,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          )
                        else
                          const SizedBox(width: 48),
                        IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                            size: AppDimensions.iconXXL - 2,
                          ),
                          tooltip: 'Admin Settings',
                          onPressed: () {
                            AppState().setAdminMode(true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminNavigationScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    Container(
                      width: AppDimensions.avatarLarge,
                      height: AppDimensions.avatarLarge,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        AppAssets.userAvatar,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          size: 48,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: AppDimensions.textHeading,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.phoneNumber,
                      style: const TextStyle(
                        fontSize: AppDimensions.textM,
                        color: Color(0xFFD4EED8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: AppDimensions.textM,
                        color: Color(0xFFD4EED8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingHLarge),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: AppStrings.profilePersonalInfo,
                    onTap: () => _showPersonalInfoDialog(context),
                  ),
                  const Divider(color: AppColors.borderLight, height: 1),
                  _buildMenuItem(
                    icon: Icons.lock_outline_rounded,
                    title: AppStrings.profileChangePassword,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(color: AppColors.borderLight, height: 1),
                  _buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: AppStrings.profileHelpSupport,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactHelpScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 56),

                  CustomOutlinedButton(
                    text: AppStrings.profileLogout,
                    icon: Icons.logout_rounded,
                    onPressed: () => _handleLogout(context),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textMedium, size: AppDimensions.iconXL),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: AppDimensions.textL,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textLight, size: AppDimensions.iconXXL - 6),
          ],
        ),
      ),
    );
  }
}
