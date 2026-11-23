import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../models/crop_model.dart';
import '../../widgets/yard_selector_bar.dart';
import 'crop_detail_screen.dart';

class PriceFallScreen extends StatelessWidget {
  final bool isTab;
  final ValueChanged<int>? onNavigateTab;
  const PriceFallScreen({super.key, this.isTab = false, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: isTab
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textDark),
                onPressed: () => Navigator.pop(context),
              ),
        title: const Column(
          children: [
            Text(
              'Price Fall',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Top Losers Today',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.south_east_rounded, color: AppColors.priceFallRed, size: 24),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const YardSelectorBar(),
            const SizedBox(height: 6),
            ListenableBuilder(
              listenable: AppState(),
              builder: (context, _) {
                final yard = AppState().currentYard;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.primaryGreen),
                      const SizedBox(width: 4),
                      Text(
                        'Market: ${yard?.name ?? "Rajkot APMC"}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(height: 12, color: AppColors.borderLight),
            Expanded(
              child: ListenableBuilder(
                listenable: AppState(),
                builder: (context, _) {
                  final losers = AppState().getFallCropsForYard(AppState().selectedYardId);

                  if (losers.isEmpty) {
                    return const Center(
                      child: Text(
                        'No price fall recorded for this yard today',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    itemCount: losers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final crop = losers[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CropDetailScreen(crop: crop)),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
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
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFDF5F5),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Image.asset(
                                  crop.imageAsset,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.eco, color: AppColors.priceFallRed),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      crop.displayName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Arrival: ${crop.arrivalBags} Bags',
                                      style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '₹${crop.avgPrice}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '-₹${crop.changeAmount.abs()}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.priceFallRed,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '-${crop.changePercentage}%',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.priceFallRed,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text(
                '* Prices are for 20 Kg',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
