import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../widgets/custom_button.dart';
import '../main_navigation_screen.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  void _showActionDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _handleAdminLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout from Admin', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Return to User Application mode?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMedium)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.priceFallRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              AppState().logoutAdmin();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textDark),
          onPressed: () {
            AppState().setAdminMode(false);
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/admin_avatar.png'),
              backgroundColor: AppColors.mintLight,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              _buildSettingItem(
                icon: Icons.lock_outline_rounded,
                title: 'Change Admin Password',
                onTap: () => _showActionDialog(context, 'Change Admin Password', 'Password update link sent to authorized admin email.'),
              ),
              const Divider(color: AppColors.borderLight, height: 1),
              _buildSettingItem(
                icon: Icons.phone_outlined,
                title: 'Update Helpline Number',
                onTap: () => _showActionDialog(context, 'Helpline Number', 'Current Helpline: +919624042246. Tap to modify.'),
              ),
              const Divider(color: AppColors.borderLight, height: 1),
              _buildSettingItem(
                icon: Icons.shield_outlined,
                title: 'Edit Privacy & Terms',
                onTap: () => _showActionDialog(context, 'Privacy & Terms', 'AgriYard APMC data usage policies and legal disclaimers.'),
              ),
              const Divider(color: AppColors.borderLight, height: 1),
              _buildSettingItem(
                icon: Icons.arrow_downward_rounded,
                title: 'Force App Update / Version',
                trailingText: 'v1.0.0',
                onTap: () => _showActionDialog(context, 'Version Info', 'AgriYard v1.0.0 (Production Release). All client versions are up to date.'),
              ),

              const Spacer(),

              // Red Outlined Logout from Admin Button
              CustomOutlinedButton(
                text: 'Logout from Admin',
                icon: Icons.logout_rounded,
                onPressed: () => _handleAdminLogout(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textMedium, size: 24),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(fontSize: 13, color: AppColors.textLight),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 22),
          ],
        ),
      ),
    );
  }
}
