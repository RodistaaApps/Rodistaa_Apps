import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared design tokens for the shipments experience.
class RodistaaTheme {
  RodistaaTheme._();

  static const Color rodistaaRed = Color(0xFFC90D0D);
  static const Color progressGreen = Color(0xFF1DB954);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color textPrimary = Color(0xFF222222);
  static const Color muted = Color(0xFF777777);
  static const Color cardBackground = Colors.white;
  static const double cardRadius = 16;
  static const double gapXS = 6;
  static const double gapS = 8;
  static const double gapM = 12;
  static const double gapL = 20;
  static const double maxContentWidth = 920;

  static TextTheme serifTextTheme([TextTheme? base]) {
    final fallback = GoogleFonts.notoSerifTextTheme(base).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );
    return fallback.copyWith(
      bodyLarge: fallback.bodyLarge
          ?.copyWith(fontFamilyFallback: const ['Times New Roman']),
      bodyMedium: fallback.bodyMedium
          ?.copyWith(fontFamilyFallback: const ['Times New Roman']),
      bodySmall: fallback.bodySmall
          ?.copyWith(fontFamilyFallback: const ['Times New Roman']),
      titleLarge: fallback.titleLarge
          ?.copyWith(fontFamilyFallback: const ['Times New Roman']),
      titleMedium: fallback.titleMedium
          ?.copyWith(fontFamilyFallback: const ['Times New Roman']),
      titleSmall: fallback.titleSmall
          ?.copyWith(fontFamilyFallback: const ['Times New Roman']),
      labelLarge: fallback.labelLarge
          ?.copyWith(fontFamilyFallback: const ['Times New Roman']),
    );
  }

  static TextStyle headingLarge(BuildContext context) =>
      serifTextTheme(Theme.of(context).textTheme).titleLarge!.copyWith(
            fontWeight: FontWeight.w700,
          );

  static TextStyle headingMedium(BuildContext context) =>
      serifTextTheme(Theme.of(context).textTheme).titleMedium!.copyWith(
            fontWeight: FontWeight.w700,
          );

  static TextStyle bodyRegular(BuildContext context) =>
      serifTextTheme(Theme.of(context).textTheme).bodyMedium!;

  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(cardRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
