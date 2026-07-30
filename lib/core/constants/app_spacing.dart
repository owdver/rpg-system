/// Design tokens for spacing following the holographic system aesthetic.
/// All spacing values are defined with semantic naming for consistency.
abstract final class AppSpacing {
  // Base spacing units
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;
  static const double massive = 64.0;

  // Component-specific spacing
  static const double cardPadding = lg;
  static const double screenPadding = lg;
  static const double sectionGap = xxl;
  static const double itemGap = md;
  static const double iconGap = sm;

  // Border radius values
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusXxl = 32.0;
  static const double radiusPill = 999.0;
  static const double radiusCircle = 9999.0;

  // Layout constants
  static const double maxContentWidth = 600.0;
  static const double minTouchTarget = 48.0;
  static const double navBarHeight = 80.0;
  static const double tabBarHeight = 64.0;
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;

  // Safe area padding helpers
  static const double notchPadding = 44.0;
  static const double bottomSafeArea = 34.0;
}
