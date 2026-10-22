import 'package:flutter/material.dart';
import '../../resources/resources.dart';
import '../../services/app_state.dart';
import '../../widgets/app_curved_header.dart';
import '../yards/yard_detail_screen.dart';
import '../market/price_rise_screen.dart';
import '../market/price_fall_screen.dart';
import 'search_results_screen.dart';

// Main dashboard displaying featured market yards and price trends
class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  void _showDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLarge),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingXL,
            horizontal: AppDimensions.paddingXXL,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.drawerDivider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _drawerTile(
                ctx: ctx,
                icon: Icons.home_rounded,
                title: AppStrings.drawerHome,
                onTap: () { Navigator.pop(ctx); onNavigateTab?.call(0); },
              ),
              _drawerTile(
                ctx: ctx,
                icon: Icons.article_outlined,
                title: AppStrings.drawerMarketRates,
                onTap: () { Navigator.pop(ctx); onNavigateTab?.call(1); },
              ),
              _drawerTile(
                ctx: ctx,
                icon: Icons.storefront,
                title: AppStrings.drawerShopDirectory,
                onTap: () { Navigator.pop(ctx); onNavigateTab?.call(4); },
              ),
              _drawerTile(
                ctx: ctx,
                icon: Icons.admin_panel_settings,
                title: AppStrings.drawerAdminPanel,
                onTap: () {
                  Navigator.pop(ctx);
                  AppState().setAdminMode(true);
                  Navigator.pushNamed(context, AppConstants.routeAdmin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _drawerTile({
    required BuildContext ctx,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title,
          style: const TextStyle(
              fontSize: AppDimensions.textL, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  void _showAlertsDialog(BuildContext context) {
    final alerts = AppState().alerts;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        title: const Row(
          children: [
            Icon(Icons.notifications_active, color: AppColors.primaryGreen),
            SizedBox(width: 8),
            Text(
              AppStrings.notificationsTitle,
              style: TextStyle(
                fontSize: AppDimensions.textXXL,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: alerts.isEmpty
              ? const Text(AppStrings.noNotifications)
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: alerts.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.info_outline,
                        color: AppColors.primaryGreen),
                    title: Text(alerts[i],
                        style: const TextStyle(
                            fontSize: AppDimensions.textBase)),
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              AppStrings.closeBtn,
              style: TextStyle(color: AppColors.primaryGreen),
            ),
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
            colorScheme:
                const ColorScheme.light(primary: AppColors.primaryGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formatted =
          '${picked.day} ${AppConstants.monthNames[picked.month - 1]} ${picked.year}';
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
            AppCurvedHeader(
              height: AppDimensions.homeHeaderHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingXL,
                  vertical: AppDimensions.paddingS,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu,
                              color: Colors.white,
                              size: AppDimensions.iconXXL),
                          onPressed: () => _showDrawer(context),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: AppDimensions.iconXXL,
                          ),
                          onPressed: () => _showAlertsDialog(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      AppStrings.homeGreeting,
                      style: TextStyle(
                        fontSize: AppDimensions.textHero,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      AppStrings.homeSubGreeting,
                      style: TextStyle(
                        fontSize: AppDimensions.textBase,
                        color: AppColors.mintLight,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SearchResultsScreen(
                                    initialQuery: ''),
                              ),
                            );
                          },
                          child: Container(
                            height: AppDimensions.searchBarHeight,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingL),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusL),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.search,
                                    color: AppColors.textMuted,
                                    size: AppDimensions.iconXXL - 6),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    AppStrings.homeSearchHint,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: AppDimensions.textBase,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      ListenableBuilder(
                        listenable: AppState(),
                        builder: (context, _) {
                          return GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              height: AppDimensions.searchBarHeight,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingM),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusL),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: AppDimensions.iconS,
                                    color: AppColors.textDark,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppState().selectedDate,
                                    style: const TextStyle(
                                      fontSize: AppDimensions.textM,
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

                  const Text(
                    AppStrings.homeMarketingYards,
                    style: TextStyle(
                      fontSize: AppDimensions.textXXL,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 14),

                  ListenableBuilder(
                    listenable: AppState(),
                    builder: (context, _) {
                      final displayYards = AppState()
                          .yards
                          .take(AppConstants.homeYardsGridCount)
                          .toList();
                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: displayYards.length,
                        itemBuilder: (context, index) {
                          return _buildYardGridCard(
                              context, displayYards[index]);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onNavigateTab != null
                              ? onNavigateTab!(2)
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const PriceRiseScreen()),
                                ),
                          child: _buildActionCard(
                            icon: Icons.trending_up_rounded,
                            title: AppStrings.homePriceRise,
                            subtitle: AppStrings.homePriceRiseSubtitle,
                            bgColor: AppColors.priceRiseLight,
                            borderColor: AppColors.mintLight,
                            textColor: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: GestureDetector(
                          onTap: () => onNavigateTab != null
                              ? onNavigateTab!(3)
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const PriceFallScreen()),
                                ),
                          child: _buildActionCard(
                            icon: Icons.trending_down_rounded,
                            title: AppStrings.homePriceFall,
                            subtitle: AppStrings.homePriceFallSubtitle,
                            bgColor: AppColors.priceFallLight,
                            borderColor: AppColors.priceFallLight,
                            textColor: AppColors.priceFallRed,
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

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingL,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: AppDimensions.iconXXL),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppDimensions.textL,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppDimensions.textXS + 1,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
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
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXXL),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
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
                      child: const Icon(Icons.business,
                          size: AppDimensions.iconHuge,
                          color: AppColors.primaryGreen),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.65),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Text(
                        '${yard.city}${AppStrings.homeGujaratSuffix}',
                        style: const TextStyle(
                          fontSize: AppDimensions.textSM,
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
          const SizedBox(height: 6),
          Text(
            yard.city,
            style: const TextStyle(
              fontSize: AppDimensions.textL,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
