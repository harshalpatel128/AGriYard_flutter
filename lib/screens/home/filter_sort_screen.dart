import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../widgets/custom_button.dart';

class FilterSortScreen extends StatefulWidget {
  const FilterSortScreen({super.key});

  @override
  State<FilterSortScreen> createState() => _FilterSortScreenState();
}

class _FilterSortScreenState extends State<FilterSortScreen> {
  late String _selectedSort;
  late Set<String> _selectedYards;

  @override
  void initState() {
    super.initState();
    _selectedSort = AppState().sortBy;
    _selectedYards = Set.from(AppState().selectedYardsFilter);
  }

  void _clearAll() {
    setState(() {
      _selectedSort = 'Price: High to Low';
      _selectedYards.clear();
    });
  }

  void _apply() {
    AppState().setFilterSort(sortBy: _selectedSort, yards: _selectedYards);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      'Price: High to Low',
      'Price: Low to High',
      'Latest Updated First',
    ];

    final yardOptions = [
      {'id': 'rajkot', 'name': 'Rajkot Marketing Yard'},
      {'id': 'junagadh', 'name': 'Junagadh Marketing Yard'},
      {'id': 'gondal', 'name': 'Gondal Marketing Yard'},
      {'id': 'mendarda', 'name': 'Mendarda Marketing Yard'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filter & Sort',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sort By Section
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ...sortOptions.map((opt) {
                final isSelected = _selectedSort == opt;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedSort = opt;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primaryGreen : AppColors.textMuted,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: isSelected
                              ? Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          opt,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),
              const Divider(color: AppColors.borderLight),
              const SizedBox(height: 16),

              // Filter by Market Yard Section
              const Text(
                'Filter by Market Yard',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ...yardOptions.map((yard) {
                final isChecked = _selectedYards.contains(yard['id']);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isChecked) {
                        _selectedYards.remove(yard['id']);
                      } else {
                        _selectedYards.add(yard['id']!);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: isChecked ? AppColors.primaryGreen : Colors.white,
                            border: Border.all(
                              color: isChecked ? AppColors.primaryGreen : AppColors.textMuted,
                              width: 1.8,
                            ),
                          ),
                          child: isChecked
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            yard['name']!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const Spacer(),
              // Apply Filters Button
              CustomPrimaryButton(
                text: 'Apply Filters',
                onPressed: _apply,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
