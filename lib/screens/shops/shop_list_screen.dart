import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../resources/resources.dart';
import '../../services/app_state.dart';
import '../../models/shop_model.dart';

class ShopListScreen extends StatefulWidget {
  final bool isTab;
  final String? filterYardId;
  final ValueChanged<int>? onNavigateTab;

  const ShopListScreen({super.key, this.isTab = true, this.filterYardId, this.onNavigateTab});

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: AppDimensions.iconM,
            color: AppColors.textDark,
          ),
          onPressed: () {
            if (widget.isTab && widget.onNavigateTab != null) {
              widget.onNavigateTab!(0);
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          AppStrings.shopListTitle,
          style: TextStyle(
            fontSize: AppDimensions.textXXL,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
            vertical: AppDimensions.paddingS,
          ),
          child: Column(
            children: [
              // Search Bar
              Container(
                height: AppDimensions.searchBarHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _query = val.trim().toLowerCase();
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: AppStrings.shopSearchHint,
                    hintStyle: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: AppDimensions.textBase,
                    ),
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textMuted,
                        size: AppDimensions.iconM),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close,
                                size: AppDimensions.iconXS,
                                color: AppColors.textMedium),
                            onPressed: () {
                              _searchController.clear();
                              setState(() { _query = ''; });
                            },
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Shop List
              Expanded(
                child: ListenableBuilder(
                  listenable: AppState(),
                  builder: (context, _) {
                    var shops = AppState().shops;
                    if (widget.filterYardId != null) {
                      final filtered = shops
                          .where((s) => s.yardId == widget.filterYardId)
                          .toList();
                      if (filtered.isNotEmpty) shops = filtered;
                    }
                    if (_query.isNotEmpty) {
                      shops = shops
                          .where((s) =>
                              s.name.toLowerCase().contains(_query))
                          .toList();
                    }

                    if (shops.isEmpty) {
                      return const Center(
                        child: Text(
                          AppStrings.errorNoShops,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: AppDimensions.textBase,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: shops.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _buildShopCard(shops[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopCard(ShopModel shop) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Shop number
          SizedBox(
            width: 28,
            child: Text(
              '${shop.number}',
              style: const TextStyle(
                fontSize: AppDimensions.textL,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Shop icon box
          Container(
            width: AppDimensions.shopIconBoxSize,
            height: AppDimensions.shopIconBoxSize,
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.primaryGreen,
                  width: AppDimensions.borderThick),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: const Icon(
              Icons.store_mall_directory_outlined,
              size: AppDimensions.iconXS,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),

          // Name & phone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name,
                  style: const TextStyle(
                    fontSize: AppDimensions.textL,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  shop.phoneNumber,
                  style: const TextStyle(
                    fontSize: AppDimensions.textM,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),

          // Call button
          InkWell(
            onTap: () => AppState().makePhoneCall(shop.phoneNumber),
            borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
            child: Container(
              width: AppDimensions.shopCallBtnSize,
              height: AppDimensions.shopCallBtnSize,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.call,
                  color: Colors.white, size: AppDimensions.iconS),
            ),
          ),
        ],
      ),
    );
  }
}
