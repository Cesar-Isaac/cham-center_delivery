import 'package:flutter/material.dart';
import '../repo/app_colors.dart';

/// Application-wide ThemeData with consistent text styles and component themes.
abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDeep,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.bgCard,
      error: AppColors.offline,
    ),
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgSheet,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 15,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
  );

  // ── Text styles ──────────────────────────────────────────────────────────

  /// Screen/section title — large and bold.
  static const TextStyle titleXL = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  /// Standard title used in headers and app bars.
  static const TextStyle titleL = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  /// Card / bottom-sheet sub-heading.
  static const TextStyle titleM = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Body text — primary.
  static const TextStyle bodyL = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// Body text — secondary / description.
  static const TextStyle bodyM = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  /// Small labels, meta data.
  static const TextStyle labelM = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Tiny badge / status labels.
  static const TextStyle labelS = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textHint,
    letterSpacing: 0.2,
  );

  /// Price / numeric emphasis.
  static const TextStyle priceL = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w900,
    color: AppColors.primaryLight,
  );

  static const TextStyle priceM = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryLight,
  );

  // ── Internal ThemeData text theme ─────────────────────────────────────────

  static const TextTheme _textTheme = TextTheme(
    displayLarge:  TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
    displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
    headlineMedium:TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
    titleLarge:    TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3),
    titleMedium:   TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
    titleSmall:    TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
    bodyLarge:     TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
    bodyMedium:    TextStyle(fontSize: 13,                              color: AppColors.textSecondary),
    bodySmall:     TextStyle(fontSize: 12,                              color: AppColors.textHint),
    labelLarge:    TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
    labelMedium:   TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
    labelSmall:    TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 0.2),
  );
}
