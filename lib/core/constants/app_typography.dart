import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Design tokens for typography following the holographic system aesthetic.
/// All typography styles are defined with semantic naming for consistency.
abstract final class AppTypography {
  static const String _fontFamily = 'JetBrainsMono';
  static const String _fallbackFontFamily = 'Roboto';

  // Display styles
  static TextStyle get displayLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get displaySmall => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  // Heading styles
  static TextStyle get headingLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  static TextStyle get headingMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get headingSmall => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  // Body styles
  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  // Label styles
  static TextStyle get labelLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
        height: 1.4,
        color: AppColors.textTertiary,
      );

  // Caption style
  static TextStyle get caption => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        height: 1.4,
        color: AppColors.textSecondary,
      );

  // Numeric styles (monospace)
  static TextStyle get numericLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get numericMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get numericSmall => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  // Button text
  static TextStyle get buttonLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get buttonMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  // Code style
  static TextStyle get code => const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: [_fallbackFontFamily],
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.6,
        color: AppColors.accentCyan,
      );
}
