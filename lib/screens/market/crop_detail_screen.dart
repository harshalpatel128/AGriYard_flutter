import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/crop_model.dart';
import '../../services/app_state.dart';
import '../../widgets/price_table.dart';
import 'crop_history_chart_screen.dart';

class CropDetailScreen extends StatefulWidget {
  final CropRate crop;

  const CropDetailScreen({super.key, required this.crop});

  @override
  State<CropDetailScreen> createState() => _CropDetailScreenState();
}

class _CropDetailScreenState extends State<CropDetailScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.crop.isFavorite;
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
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
              color: _isFavorite ? AppColors.priceFallRed : AppColors.textDark,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              AppState().toggleFavoriteCrop(crop.id);
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
              // Hero Crop Illustration Card
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF4E6),
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

              // Today's Summary Capsule Badge
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

              // Metrics Row 1: Total Arrival & Total Quantity
              Row(
                children: [
                  Expanded(
                    child: Column(
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
                  ),
                  Expanded(
                    child: Column(
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
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: AppColors.borderLight),
              const SizedBox(height: 14),

              // Metrics Row 2: Minimum, Average, Highest Price
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
                            fontSize: 20,
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
                            fontSize: 20,
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
                            fontSize: 20,
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

              // Last Updated Timestamp
              Text(
                'Last Updated: ${crop.lastUpdated}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 16),

              // 7-Day History Chart Nav Button
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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF7EE),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFCDE8D4)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.show_chart_rounded, color: AppColors.primaryGreen, size: 20),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'View 7-Day Price Chart & Analytics →',
                          textAlign: TextAlign.center,
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

              // Previous 7 Days Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Previous 7 Days Prices (${crop.priceUnit})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Price History Table
              PriceTable(records: crop.history),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
