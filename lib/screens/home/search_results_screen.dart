import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../market/crop_detail_screen.dart';
import 'filter_sort_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery;
  const SearchResultsScreen({super.key, this.initialQuery = 'Garlic'});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_SearchResultItem> _getFilteredResults() {
    final query = _searchController.text.trim().toLowerCase();
    final filterYards = AppState().selectedYardsFilter;
    final sortBy = AppState().sortBy;

    final allItems = [
      _SearchResultItem(
        cropName: 'Garlic (Lasan)',
        yardName: 'Rajkot Marketing Yard',
        yardId: 'rajkot',
        priceTag: 'Today Avg Price (20 Kg)',
        price: 1020,
        imageAsset: 'assets/images/crop_garlic.png',
        cropId: 'garlic',
      ),
      _SearchResultItem(
        cropName: 'Garlic (Lasan)',
        yardName: 'Junagadh Marketing Yard',
        yardId: 'junagadh',
        priceTag: 'Today Avg Price (20 Kg)',
        price: 1010,
        imageAsset: 'assets/images/crop_garlic.png',
        cropId: 'garlic',
      ),
      _SearchResultItem(
        cropName: 'Garlic (Lasan)',
        yardName: 'Gondal Marketing Yard',
        yardId: 'gondal',
        priceTag: 'Today Avg Price (20 Kg)',
        price: 1005,
        imageAsset: 'assets/images/crop_garlic.png',
        cropId: 'garlic',
      ),
      _SearchResultItem(
        cropName: 'Garlic (Lasan)',
        yardName: 'Mendarda Marketing Yard',
        yardId: 'mendarda',
        priceTag: 'Yesterday Avg Price (20 Kg)',
        price: 990,
        imageAsset: 'assets/images/crop_garlic.png',
        cropId: 'garlic',
      ),
      _SearchResultItem(
        cropName: 'Wheat (Ghau)',
        yardName: 'Rajkot Marketing Yard',
        yardId: 'rajkot',
        priceTag: 'Today Avg Price (20 Kg)',
        price: 670,
        imageAsset: 'assets/images/crop_wheat.png',
        cropId: 'wheat',
      ),
      _SearchResultItem(
        cropName: 'Soyabean',
        yardName: 'Junagadh Marketing Yard',
        yardId: 'junagadh',
        priceTag: 'Today Avg Price (20 Kg)',
        price: 650,
        imageAsset: 'assets/images/crop_soyabean.png',
        cropId: 'soyabean',
      ),
    ];

    var filtered = allItems.where((item) {
      final matchesQuery = query.isEmpty ||
          item.cropName.toLowerCase().contains(query) ||
          item.yardName.toLowerCase().contains(query);
      final matchesYard = filterYards.isEmpty || filterYards.contains(item.yardId);
      return matchesQuery && matchesYard;
    }).toList();

    if (sortBy == 'Price: High to Low') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } else if (sortBy == 'Price: Low to High') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final queryText = _searchController.text.isEmpty ? "All" : _searchController.text;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Container(
          height: 44,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Search yard or crop...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18, color: AppColors.textMedium),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.tune_rounded, color: AppColors.primaryGreen, size: 24),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FilterSortScreen()),
              );
              setState(() {});
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Results Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Results for "$queryText"',
                    style: const TextStyle(fontSize: 14, color: AppColors.textMedium),
                  ),
                  Text(
                    '${_getFilteredResults().length} Results Found',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Results List
              Expanded(
                child: ListView.separated(
                  itemCount: _getFilteredResults().length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final results = _getFilteredResults();
                    if (index < results.length) {
                      final item = results[index];
                      return _buildResultCard(context, item);
                    } else {
                      // Bottom Suggestion Box
                      return _buildBottomSuggestion();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, _SearchResultItem item) {
    return InkWell(
      onTap: () {
        final crop = AppState().crops.firstWhere(
              (c) => c.id == item.cropId,
              orElse: () => AppState().crops.first,
            );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CropDetailScreen(crop: crop),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
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
            // Crop Icon
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFF6F8F6),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                item.imageAsset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.eco, color: AppColors.primaryGreen),
              ),
            ),
            const SizedBox(width: 14),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.cropName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.yardName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.priceTag,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            // Price & Chevron
            Row(
              children: [
                Text(
                  '₹${item.price}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSuggestion() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCDE8D4)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Can't find what you're looking for?",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Try searching another crop or yard.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMedium),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultItem {
  final String cropName;
  final String yardName;
  final String yardId;
  final String priceTag;
  final int price;
  final String imageAsset;
  final String cropId;

  _SearchResultItem({
    required this.cropName,
    required this.yardName,
    required this.yardId,
    required this.priceTag,
    required this.price,
    required this.imageAsset,
    required this.cropId,
  });
}
