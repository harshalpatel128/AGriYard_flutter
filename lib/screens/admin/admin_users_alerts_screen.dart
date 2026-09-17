import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../widgets/custom_button.dart';

class AdminUsersAlertsScreen extends StatefulWidget {
  const AdminUsersAlertsScreen({super.key});

  @override
  State<AdminUsersAlertsScreen> createState() => _AdminUsersAlertsScreenState();
}

class _AdminUsersAlertsScreenState extends State<AdminUsersAlertsScreen> {
  final _alertController = TextEditingController();
  final _searchController = TextEditingController();
  String _userQuery = '';

  @override
  void dispose() {
    _alertController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _sendAlert() {
    final text = _alertController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an alert message'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    AppState().sendPushAlert(text);
    _alertController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Push notification broadcast sent to all farmers!'),
        backgroundColor: AppColors.primaryGreen,
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
          'Users & Alerts',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Send Push Notification
              const Text(
                'Send Push Notification',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notification Message',
                      style: TextStyle(fontSize: 13, color: AppColors.textMedium),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _alertController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Type alert message here (e.g. Market is closed...)',
                        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              CustomPrimaryButton(
                text: 'Send Alert',
                onPressed: _sendAlert,
              ),

              const SizedBox(height: 32),

              // Section 2: Registered Users (14,520)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Registered Users (14,520)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Search User Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _userQuery = val.trim().toLowerCase()),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Search user by name or phone...',
                    hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: AppColors.textMuted, size: 20),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Users List
              ListenableBuilder(
                listenable: AppState(),
                builder: (context, _) {
                  var users = AppState().users;
                  if (_userQuery.isNotEmpty) {
                    users = users.where((u) => u.name.toLowerCase().contains(_userQuery) || u.phoneNumber.contains(_userQuery)).toList();
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final u = users[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: u.isBlocked ? const Color(0xFFFFEBEE) : const Color(0xFFEFF7EE),
                              child: Icon(
                                u.isBlocked ? Icons.block_rounded : Icons.person_outline_rounded,
                                color: u.isBlocked ? AppColors.priceFallRed : AppColors.primaryGreen,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    u.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    u.phoneNumber,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Status Badge (Clickable to toggle)
                            GestureDetector(
                              onTap: () => AppState().toggleUserBlock(u.id),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: u.isBlocked ? const Color(0xFFFFEBEE) : const Color(0xFFEFF7EE),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  u.isBlocked ? 'Blocked' : 'Active',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: u.isBlocked ? AppColors.priceFallRed : AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
