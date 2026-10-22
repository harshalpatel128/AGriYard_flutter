import 'package:flutter/material.dart';
import '../../resources/resources.dart';
import '../../models/crop_model.dart';
import '../../widgets/price_table.dart';
import 'crop_history_chart_screen.dart';

class CropDetailScreen extends StatefulWidget {
  final CropRate crop;

  const CropDetailScreen({super.key, required this.crop});

  @override
  State<CropDetailScreen> createState() => _CropDetailScreenState();
}

class _CropDetailScreenState extends State<CropDetailScreen> {

  Color _getHeroBackgroundColor(String cropId) {
    switch (cropId.toLowerCase()) {
      case 'wheat':
      case 'chana':
        return AppColors.cropWheatBg;
      case 'soyabean':
      case 'tuver':
        return AppColors.cropSoyabeanBg;
      case 'cotton':
        return AppColors.cropCottonBg;
      case 'garlic':
        return AppColors.cropGarlicBg;
      default:
        return AppColors.cropWheatBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final crop = widget.crop;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          crop.displayName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart_rounded, color: AppColors.primaryGreen),
            tooltip: '7-Day Chart',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CropHistoryChartScreen(crop: crop),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: _getHeroBackgroundColor(crop.id),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  crop.imageAsset,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.eco, size: 80, color: AppColors.primaryGreen),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Today's Summary (${crop.priceUnit})",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Total Arrival',
                        style: TextStyle(fontSize: 13, color: AppColors.textLight),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${crop.arrivalBags} Bags',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Total Quantity',
                        style: TextStyle(fontSize: 13, color: AppColors.textLight),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${crop.totalQuantityKg.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} Kg',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: AppColors.borderLight),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Minimum Price',
                          style: TextStyle(fontSize: 12, color: AppColors.textLight),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${crop.minPrice}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Average Price',
                          style: TextStyle(fontSize: 12, color: AppColors.textLight),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${crop.avgPrice}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Highest Price',
                          style: TextStyle(fontSize: 12, color: AppColors.textLight),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${crop.maxPrice}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                'Last Updated: ${crop.lastUpdated}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CropHistoryChartScreen(crop: crop),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.mintBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.mintLight),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.show_chart_rounded, color: AppColors.primaryGreen, size: 20),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'View 7-Day Price Chart & Analytics →',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CropHistoryChartScreen(crop: crop),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Previous 7 Days Prices (${crop.priceUnit})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.primaryGreen),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CropHistoryChartScreen(crop: crop),
                    ),
                  );
                },
                child: PriceTable(records: crop.history),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
