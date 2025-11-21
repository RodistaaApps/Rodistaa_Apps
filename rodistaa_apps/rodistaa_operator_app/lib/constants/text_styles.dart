import 'package:flutter/material.dart';

import 'colors.dart';

class AppTextStyles {
  static TextStyle headline = const TextStyle(
    fontFamily: 'Times New Roman',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle title = const TextStyle(
    fontFamily: 'Times New Roman',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle body = const TextStyle(
    fontFamily: 'Times New Roman',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = TextStyle(
    fontFamily: 'Times New Roman',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary.withValues(alpha: 0.7),
  );

  // Legacy aliases
  static TextStyle get bodyText => body;
  static TextStyle get header => headline;
  static TextStyle get buttonText => title.copyWith(fontSize: 16, fontWeight: FontWeight.w700);
}
