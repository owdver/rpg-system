import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Design tokens for shadows and visual effects following the holographic system aesthetic.
abstract final class AppShadows {
  // Soft shadow
  static List<BoxShadow> get soft => [
    BoxShadow(
      color: Colors.black.withOpacity(0.24),
      offset: const Offset(0, 10),
      blurRadius: 30,
      spreadRadius: 0,
    ),
  ];

  // Medium shadow
  static List<BoxShadow> get medium => [
    BoxShadow(
      color: Colors.black.withOpacity(0.30),
      offset: const Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  // Strong shadow
  static List<BoxShadow> get strong => [
    BoxShadow(
      color: Colors.black.withOpacity(0.40),
      offset: const Offset(0, 16),
      blurRadius: 40,
      spreadRadius: 0,
    ),
  ];

  // Glow shadows
  static List<BoxShadow> glowCyan([double intensity = 0.3]) => [
    BoxShadow(
      color: AppColors.accentCyan.withOpacity(intensity),
      offset: Offset.zero,
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> glowViolet([double intensity = 0.25]) => [
    BoxShadow(
      color: AppColors.accentViolet.withOpacity(intensity),
      offset: Offset.zero,
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> glowBlue([double intensity = 0.3]) => [
    BoxShadow(
      color: AppColors.accentBlue.withOpacity(intensity),
      offset: Offset.zero,
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> glowAmber([double intensity = 0.3]) => [
    BoxShadow(
      color: AppColors.accentAmber.withOpacity(intensity),
      offset: Offset.zero,
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // Glass effect shadow
  static List<BoxShadow> get glass => [
    BoxShadow(
      color: Colors.black.withOpacity(0.20),
      offset: const Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.05),
      offset: const Offset(0, -2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // Elevated panel shadow
  static List<BoxShadow> get elevatedPanel => [
    BoxShadow(
      color: Colors.black.withOpacity(0.30),
      offset: const Offset(0, 12),
      blurRadius: 32,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.accentCyan.withOpacity(0.08),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // Inset shadow for depth
  static List<BoxShadow> get insetSoft => [
    BoxShadow(
      color: Colors.black.withOpacity(0.20),
      offset: const Offset(2, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
}

/// Design tokens for blur effects.
abstract final class AppBlur {
  static const double none = 0.0;
  static const double minimal = 4.0;
  static const double subtle = 8.0;
  static const double light = 12.0;
  static const double medium = 16.0;
  static const double strong = 24.0;
  static const double heavy = 32.0;
  static const double extreme = 48.0;
  static const double overlay = 40.0;
}

/// Design tokens for border styles.
abstract final class AppBorders {
  static Border? get subtle => Border.all(
    color: AppColors.borderSubtle,
    width: 1,
  );

  static Border? get accent => Border.all(
    color: AppColors.borderAccent,
    width: 1,
  );

  static Border? get active => Border.all(
    color: AppColors.borderActive,
    width: 1.5,
  );

  static BorderRadius get radiusSm => BorderRadius.circular(8);
  static BorderRadius get radiusMd => BorderRadius.circular(12);
  static BorderRadius get radiusLg => BorderRadius.circular(16);
  static BorderRadius get radiusXl => BorderRadius.circular(24);
  static BorderRadius get radiusXxl => BorderRadius.circular(32);
  static BorderRadius get radiusPill => BorderRadius.circular(999);
}

/// Design tokens for z-index values.
abstract final class AppZIndex {
  static const int background = 0;
  static const int surface = 5;
  static const int content = 10;
  static const int elevated = 20;
  static const int overlay = 30;
  static const int modal = 40;
  static const int toast = 50;
  static const int tooltip = 60;
  static const int debug = 100;
}

/// Design tokens for icon sizes.
abstract final class AppIconSizes {
  static const double xs = 12.0;
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double massive = 64.0;
}
