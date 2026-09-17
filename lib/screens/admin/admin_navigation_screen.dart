import 'package:flutter/material.dart';
import '../../widgets/admin_bottom_nav.dart';
import 'admin_dashboard_screen.dart';
import 'admin_manage_data_screen.dart';
import 'admin_users_alerts_screen.dart';
import 'admin_settings_screen.dart';

class AdminNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const AdminNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<AdminNavigationScreen> createState() => _AdminNavigationScreenState();
}

class _AdminNavigationScreenState extends State<AdminNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const AdminDashboardScreen(),
      const AdminManageDataScreen(),
      const AdminUsersAlertsScreen(),
      const AdminSettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AdminBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
