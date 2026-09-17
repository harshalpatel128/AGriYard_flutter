import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../widgets/app_curved_header.dart';
import '../yards/yard_detail_screen.dart';
import '../market/price_rise_screen.dart';
import '../market/price_fall_screen.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  void _showDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.home, color: AppColors.primaryGreen),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(ctx);
                  onNavigateTab?.call(0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.article_outlined, color: AppColors.primaryGreen),
                title: const Text("Today's Market Rates"),
                onTap: () {
                  Navigator.pop(ctx);
                  onNavigateTab?.call(1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.storefront, color: AppColors.primaryGreen),
                title: const Text('Shop Directory'),
                onTap: () {
                  Navigator.pop(ctx);
                  onNavigateTab?.call(4);
                },
              ),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: AppColors.primaryGreen),
                title: const Text('Admin Panel'),
                onTap: () {
                  Navigator.pop(ctx);
                  AppState().setAdminMode(true);
                  Navigator.pushNamed(context, '/admin');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertsDialog(BuildContext context) {
    final alerts = AppState().alerts;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.notifications_active, color: AppColors.primaryGreen),
            SizedBox(width: 8),
            Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: alerts.isEmpty
              ? const Text('No new notifications today.')
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: alerts.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.info_outline, color: AppColors.primaryGreen),
                    title: Text(alerts[i], style: const TextStyle(fontSize: 14)),
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: AppColors.primaryGreen)),
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primaryGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final formatted = '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      AppState().setSelectedDate(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green Curved Top Header
            AppCurvedHeader(
              height: 195,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                          onPressed: () => _showDrawer(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                          onPressed: () => _showAlertsDialog(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text(
                          'Good Morning! ☀️',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Check today's market rates",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFD4EED8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Search & Date Row
                  Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SearchResultsScreen(initialQuery: ''),
                              ),
                            );
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.search, color: AppColors.textMuted, size: 22),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Search yard or crop...',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Date Selector Button
                      ListenableBuilder(
                        listenable: AppState(),
                        builder: (context, _) {
                          return GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textDark),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppState().selectedDate,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Section Title: Marketing Yards
                  const Text(
                    'Marketing Yards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2x2 Grid of Marketing Yards
                  ListenableBuilder(
                    listenable: AppState(),
                    builder: (context, _) {
                      final displayYards = AppState().yards.take(4).toList();
                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: displayYards.length,
                        itemBuilder: (context, index) {
                          final yard = displayYards[index];
                          return _buildYardGridCard(context, yard);
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Price Rise & Price Fall Horizontal Action Cards
                  Row(
                    children: [
                      // Price Rise Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (onNavigateTab != null) {
                              onNavigateTab!(2); // Switch to Rise tab
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const PriceRiseScreen()),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1FAF3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFC7EBD1)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.trending_up_rounded, color: AppColors.primaryGreen, size: 28),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Price Rise',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Top Gainers Today',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Price Fall Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (onNavigateTab != null) {
                              onNavigateTab!(3); // Switch to Fall tab
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const PriceFallScreen()),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4F4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFFD4D4)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.trending_down_rounded, color: AppColors.priceFallRed, size: 28),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Price Fall',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.priceFallRed,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Top Losers Today',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildYardGridCard(BuildContext context, dynamic yard) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => YardDetailScreen(yard: yard),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    yard.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.mintLight,
                      child: const Icon(Icons.business, size: 40, color: AppColors.primaryGreen),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Text(
                        '${yard.city}, Gujarat',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            yard.city,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
