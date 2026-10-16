import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../resources/resources.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(Icons.home_rounded, Icons.home_outlined, AppStrings.navHome),
      _NavItem(Icons.article_rounded, Icons.article_outlined, AppStrings.navRates),
      _NavItem(Icons.trending_up_rounded, Icons.trending_up_rounded, AppStrings.navRise),
      _NavItem(Icons.trending_down_rounded, Icons.trending_down_rounded, AppStrings.navFall),
      _NavItem(Icons.storefront_rounded, Icons.storefront_outlined, AppStrings.navShops),
      _NavItem(Icons.person_rounded, Icons.person_outline_rounded, AppStrings.navProfile),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderLight, width: AppDimensions.borderThin),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final isSelected = currentIndex == index;
            final item = items[index];
            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: AppDimensions.paddingXS,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Selected indicator dot
                      if (isSelected)
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const SizedBox(height: 8),
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        size: AppDimensions.iconL,
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.textMuted,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppDimensions.textXS + 1,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  _NavItem(this.activeIcon, this.icon, this.label);
}
