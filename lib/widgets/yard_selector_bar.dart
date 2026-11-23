import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_colors.dart';

class YardSelectorBar extends StatelessWidget {
  final bool showAllOption;
  final String? selectedYardId;
  final ValueChanged<String>? onYardSelected;

  const YardSelectorBar({
    super.key,
    this.showAllOption = false,
    this.selectedYardId,
    this.onYardSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final yards = AppState().yards;
        final currentSelected = selectedYardId ?? AppState().selectedYardId;

        return SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: yards.length + (showAllOption ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (showAllOption && index == 0) {
                final isSelected = currentSelected == 'all' || currentSelected.isEmpty;
                return _buildChip(
                  label: 'All Yards',
                  isSelected: isSelected,
                  icon: Icons.grid_view_rounded,
                  onTap: () {
                    if (onYardSelected != null) {
                      onYardSelected!('all');
                    }
                  },
                );
              }

              final yard = yards[showAllOption ? index - 1 : index];
              final isSelected = currentSelected == yard.id;

              return _buildChip(
                label: yard.city.isNotEmpty ? '${yard.city} APMC' : yard.name,
                isSelected: isSelected,
                icon: Icons.location_on_rounded,
                onTap: () {
                  AppState().selectYard(yard.id);
                  if (onYardSelected != null) {
                    onYardSelected!(yard.id);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : const Color(0xFFDFE6DF),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : AppColors.primaryGreen,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
