import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/yard_model.dart';
import '../../services/app_state.dart';
import '../market/market_rates_screen.dart';
import '../shops/shop_list_screen.dart';

class YardDetailScreen extends StatefulWidget {
  final YardModel yard;

  const YardDetailScreen({super.key, required this.yard});

  @override
  State<YardDetailScreen> createState() => _YardDetailScreenState();
}

class _YardDetailScreenState extends State<YardDetailScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.yard.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
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
          widget.yard.name,
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
              AppState().toggleFavoriteYard(widget.yard.id);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Yard Image
              Container(
                height: 220,
                width: double.infinity,
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
                child: Image.asset(
                  widget.yard.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.mintLight,
                    child: const Icon(Icons.business, size: 60, color: AppColors.primaryGreen),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Detail Rows
              _buildDetailItem(
                icon: Icons.location_on_outlined,
                title: 'Address',
                value: widget.yard.address,
              ),
              const SizedBox(height: 18),
              _buildDetailItem(
                icon: Icons.phone_outlined,
                title: 'Contact Number',
                value: widget.yard.contactNumber,
                isClickablePhone: true,
              ),
              const SizedBox(height: 18),
              _buildDetailItem(
                icon: Icons.storefront_outlined,
                title: 'Total Shops',
                value: widget.yard.totalShops,
              ),
              const SizedBox(height: 18),
              _buildDetailItem(
                icon: Icons.calendar_today_outlined,
                title: 'Established',
                value: widget.yard.establishedYear,
              ),

              const Spacer(),

              // Bottom Two Buttons: Today's Rates & Shop List
              Row(
                children: [
                  // Today's Rates
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MarketRatesScreen(isTab: false),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 18, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Today's Rates",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Shop List
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: AppColors.border, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShopListScreen(isTab: false, filterYardId: widget.yard.id),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.storefront_outlined, size: 20, color: AppColors.textDark),
                            SizedBox(width: 8),
                            Text(
                              'Shop List',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    bool isClickablePhone = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFFEFF7EE),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: isClickablePhone ? () => AppState().makePhoneCall(value) : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isClickablePhone ? AppColors.primaryGreen : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
