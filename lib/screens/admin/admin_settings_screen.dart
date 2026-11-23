import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';

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
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddAdminDialog(BuildContext context) {
    final emailController = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.admin_panel_settings_rounded, color: AppColors.primaryGreen),
              SizedBox(width: 8),
              Text('Add New Admin', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter email address to grant Admin Panel access (stored in Firebase "admins" collection):', style: TextStyle(fontSize: 14, color: AppColors.textMedium)),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !isSaving,
                decoration: InputDecoration(
                  labelText: 'Admin Email',
                  hintText: 'admin@rku.ac.in',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              if (isSaving) ...[
                const SizedBox(height: 14),
                const Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGreen),
                    ),
                    SizedBox(width: 10),
                    Text('Saving to Firebase...', style: TextStyle(fontSize: 13, color: AppColors.primaryGreen)),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textMedium)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isSaving
                  ? null
                  : () async {
                      final email = emailController.text.trim();
                      if (email.isNotEmpty && email.contains('@')) {
                        setDialogState(() => isSaving = true);
                        final success = await AppState().addAdmin(email);
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Admin access granted and saved to Firebase for $email!'
                                    : 'Admin added locally. To sync with Firebase, ensure Firestore Rules are set to: allow read, write: if true;',
                              ),
                              backgroundColor: success ? AppColors.primaryGreen : Colors.orange,
                              duration: const Duration(seconds: 4),
                            ),
                          );
                        }
                      }
                    },
              child: const Text('Add Admin', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAdminDialog(BuildContext context, String email) {
    bool isDeleting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Remove Admin Access', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to revoke admin privileges for $email and remove from Firebase?'),
          actions: [
            TextButton(
              onPressed: isDeleting ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textMedium)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.priceFallRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isDeleting
                  ? null
                  : () async {
                      setDialogState(() => isDeleting = true);
                      await AppState().removeAdmin(email);
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Admin access revoked for $email.'),
                            backgroundColor: AppColors.priceFallRed,
                          ),
                        );
                      }
                    },
              child: const Text('Remove', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Authorized Admins',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.add, size: 18, color: AppColors.primaryGreen),
                          label: const Text('Add Admin', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                          onPressed: () => _showAddAdminDialog(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    ListenableBuilder(
                      listenable: AppState(),
                      builder: (context, _) {
                        final admins = AppState().adminEmails;
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAF9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: admins.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderLight),
                            itemBuilder: (context, index) {
                              final email = admins[index];
                              final isSuper = email.toLowerCase() == AppState.superAdminEmail.toLowerCase();
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                                leading: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: isSuper ? AppColors.primaryGreen : AppColors.primaryLight,
                                  child: Icon(
                                    isSuper ? Icons.star_rounded : Icons.person_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSuper ? FontWeight.bold : FontWeight.w500,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                subtitle: Text(
                                  isSuper ? 'Primary Super Admin' : 'Admin Access',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSuper ? AppColors.primaryGreen : AppColors.textMedium,
                                  ),
                                ),
                                trailing: isSuper
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF7EE),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text('Owner', style: TextStyle(color: AppColors.primaryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.delete_outline, color: AppColors.priceFallRed, size: 20),
                                        onPressed: () => _showDeleteAdminDialog(context, email),
                                      ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: AppColors.borderLight, height: 1),
                    const SizedBox(height: 16),
                    const Text(
                      'App Settings & System',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

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
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: CustomOutlinedButton(
                text: 'Logout from Admin',
                icon: Icons.logout_rounded,
                onPressed: () => _handleAdminLogout(context),
              ),
            ),
          ],
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
