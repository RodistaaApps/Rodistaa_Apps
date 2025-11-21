import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.labels,
    required this.icons,
    required this.currentIndex,
    required this.onTap,
  }) : assert(labels.length == icons.length);

  final List<String> labels;
  final List<IconData> icons;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: AppColors.primaryRed,
      child: Row(
        children: List.generate(icons.length, (index) {
          final isSelected = currentIndex == index;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Material(
                color: isSelected ? AppColors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () => onTap(index),
                  borderRadius: BorderRadius.circular(16),
                  splashColor: AppColors.white.withValues(alpha: 0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icons[index],
                          color: isSelected
                              ? AppColors.primaryRed
                              : AppColors.white,
                          size: 28,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[index],
                          style: AppTextStyles.bodyText.copyWith(
                            color: isSelected
                                ? AppColors.primaryRed
                                : AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

