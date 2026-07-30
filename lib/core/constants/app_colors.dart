import 'package:flutter/material.dart';

/// Design tokens for colors following the holographic system aesthetic.
/// All colors are defined with semantic naming for consistency.
abstract final class AppColors {
  // Background Colors
  static const Color backgroundPrimary = Color(0xFF050816);
  static const Color backgroundSecondary = Color(0xFF0B1428);
  static const Color backgroundTertiary = Color(0xFF101C36);

  // Surface Colors (Glass)
  static Color get surfaceGlass => const Color(0xFF0A1626).withOpacity(0.72);
  static Color get surfaceGlassStrong => const Color(0xFF101F36).withOpacity(0.88);
  static Color get surfaceGlassLight => const Color(0xFF142040).withOpacity(0.60);

  // Border Colors
  static Color get borderAccent => const Color(0xFF55DCFF).withOpacity(0.45);
  static Color get borderSubtle => const Color(0xFF55DCFF).withOpacity(0.15);
  static Color get borderActive => const Color(0xFF55DCFF).withOpacity(0.80);

  // Text Colors
  static const Color textPrimary = Color(0xFFF5FAFF);
  static const Color textSecondary = Color(0xFF9FB2C8);
  static const Color textTertiary = Color(0xFF6A7D94);
  static const Color textMuted = Color(0xFF4A5A70);

  // Accent Colors
  static const Color accentCyan = Color(0xFF54E6FF);
  static const Color accentBlue = Color(0xFF3C7DFF);
  static const Color accentViolet = Color(0xFF8C7DFF);
  static const Color accentAmber = Color(0xFFFFB84D);
  static const Color accentSuccess = Color(0xFF44E28A);
  static const Color accentWarning = Color(0xFFFF6B57);
  static const Color accentError = Color(0xFFFF4757);
  static const Color accentPurple = Color(0xFFB84DFF);

  // Gradient Definitions
  static const LinearGradient ambientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF050816),
      Color(0xFF0B1428),
      Color(0xFF101C36),
    ],
    stops: [0.0, 0.35, 1.0],
  );

  static const LinearGradient energyActive = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF54E6FF),
      Color(0xFF3C7DFF),
    ],
  );

  static const LinearGradient progressionRare = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF8C7DFF),
      Color(0xFF54E6FF),
    ],
  );

  static const LinearGradient warningCritical = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFF6B57),
      Color(0xFFFFB84D),
    ],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF44E28A),
      Color(0xFF54E6FF),
    ],
  );

  static const LinearGradient glassOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x33FFFFFF),
      Color(0x00FFFFFF),
    ],
  );

  // Radial Gradients for Glow Effects
  static RadialGradient get cyanGlow => const RadialGradient(
    colors: [
      Color(0xFF54E6FF),
      Color(0x0054E6FF),
    ],
    stops: [0.0, 1.0],
  );

  static RadialGradient get violetGlow => const RadialGradient(
    colors: [
      Color(0xFF8C7DFF),
      Color(0x008C7DFF),
    ],
    stops: [0.0, 1.0],
  );

  // Status Colors
  static const Color statusOnline = accentSuccess;
  static const Color statusOffline = Color(0xFF4A5A70);
  static const Color statusBusy = accentWarning;
  static const Color statusError = accentError;

  // Difficulty Colors
  static const Color difficultyEasy = accentSuccess;
  static const Color difficultyMedium = accentAmber;
  static const Color difficultyHard = accentWarning;
  static const Color difficultyExtreme = accentError;
  static const Color difficultyLegendary = accentViolet;

  // Rarity Colors
  static const Color rarityCommon = Color(0xFF9FB2C8);
  static const Color rarityUncommon = accentSuccess;
  static const Color rarityRare = accentBlue;
  static const Color rarityEpic = accentViolet;
  static const Color rarityLegendary = accentAmber;
}
