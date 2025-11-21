import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

class NavigationBox extends StatelessWidget {
  const NavigationBox({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.flex = 1,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final int flex;

  @override
  Widget build(BuildContext context) {
    final box = Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 3,
      shadowColor: AppColors.primaryRed.withValues(alpha: 0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryRed, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppColors.primaryRed,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.primaryRed,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: AppTextStyles.bodyText.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return Expanded(
      flex: flex,
      child: box,
    );
  }
}
