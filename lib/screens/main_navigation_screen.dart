import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
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
      const MarketRatesScreen(isTab: true),
      const PriceRiseScreen(isTab: true),
      const PriceFallScreen(isTab: true),
      const ShopListScreen(isTab: true),
      const ProfileScreen(isTab: true),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: selectTab,
      ),
    );
  }
}
