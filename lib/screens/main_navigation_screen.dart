import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/app_state.dart';
import '../widgets/custom_bottom_nav.dart';
import 'admin/admin_navigation_screen.dart';
import 'home/home_screen.dart';
import 'market/market_rates_screen.dart';
import 'market/price_rise_screen.dart';
import 'market/price_fall_screen.dart';
import 'shops/shop_list_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateTab: selectTab),
      MarketRatesScreen(isTab: true, onNavigateTab: selectTab),
      PriceRiseScreen(isTab: true, onNavigateTab: selectTab),
      PriceFallScreen(isTab: true, onNavigateTab: selectTab),
      ShopListScreen(isTab: true, onNavigateTab: selectTab),
      ProfileScreen(isTab: true, onNavigateTab: selectTab),
    ];

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _currentIndex != 0) {
          selectTab(0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        floatingActionButton: ListenableBuilder(
          listenable: AppState(),
          builder: (context, _) {
            if (!AppState().canSwitchToAdmin) return const SizedBox.shrink();
            return FloatingActionButton.extended(
              heroTag: 'back_to_admin_btn',
              backgroundColor: AppColors.primaryGreen,
              elevation: 4,
              icon: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 20),
              label: const Text('Back to Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              onPressed: () {
                AppState().setAdminMode(true);
                AppState().setAdminPreviewMode(false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminNavigationScreen()),
                );
              },
            );
          },
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: selectTab,
        ),
      ),
    );
  }
}
