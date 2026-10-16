import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../resources/resources.dart';
import '../../services/app_state.dart';
import '../../models/crop_model.dart';
import 'crop_detail_screen.dart';

class MarketRatesScreen extends StatelessWidget {
  final bool isTab;
  final ValueChanged<int>? onNavigateTab;
  const MarketRatesScreen({super.key, this.isTab = true, this.onNavigateTab});

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
            if (isTab && onNavigateTab != null) {
              onNavigateTab!(0);
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Column(
          children: [
            Text(
              AppStrings.marketRatesTitle,
              style: TextStyle(
                fontSize: AppDimensions.textXXL,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 2),
            Text(
              AppStrings.marketRatesUnit,
              style: TextStyle(
                fontSize: AppDimensions.textSM,
                fontWeight: FontWeight.normal,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: AppState(),
          builder: (context, _) {
            final crops = AppState().crops;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
                vertical: AppDimensions.paddingM,
              ),
              itemCount: crops.length + 1,
              separatorBuilder: (_, __) => const Divider(
                height: 20,
                color: AppColors.borderLight,
              ),
              itemBuilder: (context, index) {
                if (index < crops.length) {
                  return _buildCropRateRow(context, crops[index]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        AppStrings.marketRatesDisclaimer,
                        style: TextStyle(
                          fontSize: AppDimensions.textSM,
                          color: AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCropRateRow(BuildContext context, CropRate crop) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CropDetailScreen(crop: crop)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXS),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Crop Image
            Container(
              width: AppDimensions.cardIconSize,
              height: AppDimensions.cardIconSize,
              decoration: const BoxDecoration(
                color: Color(0xFFF6F8F6),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                crop.imageAsset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.eco,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Crop info & rates
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crop.displayName,
                    style: const TextStyle(
                      fontSize: AppDimensions.textL,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _rateStat(AppStrings.marketArrival,
                          '${crop.arrivalBags} ${AppConstants.arrivalUnit}'),
                      _rateStat(AppStrings.marketMin,
                          '${AppConstants.currencySymbol}${crop.minPrice}'),
                      _rateStat(AppStrings.marketAvg,
                          '${AppConstants.currencySymbol}${crop.avgPrice}'),
                      _rateStat(AppStrings.marketMax,
                          '${AppConstants.currencySymbol}${crop.maxPrice}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // View Details button
            SizedBox(
              height: AppDimensions.buttonHeightSm,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM - 2),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CropDetailScreen(crop: crop)),
                  );
                },
                child: const Text(
                  AppStrings.marketViewDetails,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.textS,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rateStat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: AppDimensions.textXS,
              color: AppColors.textLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppDimensions.textS,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
