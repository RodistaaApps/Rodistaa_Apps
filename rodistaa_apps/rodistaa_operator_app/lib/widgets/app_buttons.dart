import 'package:flutter/material.dart';

import '../constants/colors.dart';

class AppButtons {
  const AppButtons._();

  static ButtonStyle primary({EdgeInsetsGeometry? padding}) {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.primaryRed,
      foregroundColor: AppColors.white,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
    );
  }

  static ButtonStyle secondary({EdgeInsetsGeometry? padding}) {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryRed,
      side: const BorderSide(color: AppColors.primaryRed, width: 1.6),
      padding: padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
    );
  }

  static ButtonStyle text({EdgeInsetsGeometry? padding}) {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primaryRed,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  static ButtonStyle disabled({EdgeInsetsGeometry? padding}) {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.borderGray,
      foregroundColor: AppColors.white,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
    );
  }
}
