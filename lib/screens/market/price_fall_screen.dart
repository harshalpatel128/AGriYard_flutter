import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import 'crop_detail_screen.dart';

class PriceFallScreen extends StatelessWidget {
  final bool isTab;
  const PriceFallScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final losers = [
      {'id': 'chana', 'name': 'Chana', 'today': 540, 'decrease': 90, 'pct': 14.29, 'img': 'assets/images/crop_chana.png'},
      {'id': 'tuver', 'name': 'Tuver', 'today': 670, 'decrease': 80, 'pct': 10.67, 'img': 'assets/images/crop_tuver.png'},
      {'id': 'soyabean', 'name': 'Soyabean', 'today': 600, 'decrease': 60, 'pct': 9.09, 'img': 'assets/images/crop_soyabean.png'},
      {'id': 'wheat', 'name': 'Wheat (Ghau)', 'today': 600, 'decrease': 40, 'pct': 6.25, 'img': 'assets/images/crop_wheat.png'},
      {'id': 'garlic', 'name': 'Garlic (Lasan)', 'today': 1010, 'decrease': 40, 'pct': 3.81, 'img': 'assets/images/crop_garlic.png'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                itemCount: losers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = losers[index];
                  return InkWell(
                    onTap: () {
                      final crop = AppState().crops.firstWhere(
                            (c) => c.id == item['id'],
                            orElse: () => AppState().crops.first,
                          );
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
                              color: Color(0xFFF6F8F6),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(
                              item['img'] as String,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(Icons.eco, color: AppColors.primaryGreen),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Today',
                                  style: TextStyle(fontSize: 12, color: AppColors.textLight),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₹${item['today']}',
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
                                '-₹${item['decrease']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.priceFallRed,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '-${item['pct']}%',
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
