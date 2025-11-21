import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

class ThemeConfig {
  const ThemeConfig._();
  
  /// Toggle to show/hide the animated banner above bottom navigation
  static const bool showAnimatedBanner = false;
}

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final base = ThemeData(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryRed,
        primary: AppColors.primaryRed,
        secondary: AppColors.white,
        surface: AppColors.white,
        onPrimary: AppColors.white,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.title,
      ),
      textTheme: TextTheme(
        titleLarge: AppTextStyles.headline,
        titleMedium: AppTextStyles.title,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.borderGray.withValues(alpha: 0.6)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(style: _primaryButtonStyle()),
      outlinedButtonTheme: OutlinedButtonThemeData(style: _secondaryButtonStyle()),
      textButtonTheme: TextButtonThemeData(style: _textButtonStyle()),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.primaryRed.withValues(alpha: 0.12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: AppTextStyles.caption,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        side: BorderSide(color: AppColors.borderGray.withValues(alpha: 0.6)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.4),
        ),
      ),
      dividerColor: AppColors.borderGray,
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        iconColor: AppColors.primaryRed,
        textColor: AppColors.textPrimary,
      ),
    );
  }

  static ButtonStyle _primaryButtonStyle() {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.primaryRed,
      foregroundColor: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      textStyle: AppTextStyles.title.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  static ButtonStyle _secondaryButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryRed,
      side: const BorderSide(color: AppColors.primaryRed, width: 1.4),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      textStyle: AppTextStyles.title.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  static ButtonStyle _textButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primaryRed,
      textStyle: AppTextStyles.title.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }
}
