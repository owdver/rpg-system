import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/constants.dart';

/// The main theme configuration for the RPG System application.
/// Implements the holographic operating system aesthetic.
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTypography.displayLarge.fontFamily,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      canvasColor: AppColors.backgroundPrimary,
      cardColor: AppColors.surfaceGlass,
      dividerColor: AppColors.borderSubtle,
      splashColor: AppColors.accentCyan.withOpacity(0.1),
      highlightColor: AppColors.accentCyan.withOpacity(0.1),
      hoverColor: AppColors.accentCyan.withOpacity(0.05),
      focusColor: AppColors.accentCyan.withOpacity(0.15),
      primaryColor: AppColors.accentCyan,
      primaryColorLight: AppColors.accentBlue,
      primaryColorDark: AppColors.accentViolet,
      secondaryHeaderColor: AppColors.accentBlue,
      textTheme: _textTheme,
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppIconSizes.md,
      ),
      appBarTheme: _appBarTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      checkboxTheme: _checkboxTheme,
      switchTheme: _switchTheme,
      sliderTheme: _sliderTheme,
      progressIndicatorTheme: _progressIndicatorTheme,
      snackBarTheme: _snackBarTheme,
      dialogTheme: _dialogTheme,
      bottomSheetTheme: _bottomSheetTheme,
      tabBarTheme: _tabBarTheme,
      chipTheme: _chipTheme,
      tooltipTheme: _tooltipTheme,
      pageTransitionsTheme: _pageTransitionsTheme,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textSelectionTheme: _textSelectionTheme,
    );
  }

  static ColorScheme get _colorScheme => ColorScheme.dark(
    primary: AppColors.accentCyan,
    onPrimary: AppColors.backgroundPrimary,
    primaryContainer: AppColors.accentBlue,
    onPrimaryContainer: AppColors.textPrimary,
    secondary: AppColors.accentViolet,
    onSecondary: AppColors.textPrimary,
    secondaryContainer: AppColors.accentViolet,
    onSecondaryContainer: AppColors.textPrimary,
    tertiary: AppColors.accentAmber,
    onTertiary: AppColors.backgroundPrimary,
    tertiaryContainer: AppColors.accentAmber,
    onTertiaryContainer: AppColors.backgroundPrimary,
    error: AppColors.accentError,
    onError: AppColors.textPrimary,
    errorContainer: AppColors.accentError,
    onErrorContainer: AppColors.textPrimary,
    surface: AppColors.backgroundSecondary,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.backgroundTertiary,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.borderAccent,
    outlineVariant: AppColors.borderSubtle,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.backgroundPrimary,
    inversePrimary: AppColors.accentBlue,
    surfaceTint: AppColors.accentCyan,
  );

  static TextTheme get _textTheme => TextTheme(
    displayLarge: AppTypography.displayLarge,
    displayMedium: AppTypography.displayMedium,
    displaySmall: AppTypography.displaySmall,
    headlineLarge: AppTypography.headingLarge,
    headlineMedium: AppTypography.headingMedium,
    headlineSmall: AppTypography.headingSmall,
    titleLarge: AppTypography.headingLarge,
    titleMedium: AppTypography.headingMedium,
    titleSmall: AppTypography.headingSmall,
    bodyLarge: AppTypography.bodyLarge,
    bodyMedium: AppTypography.bodyMedium,
    bodySmall: AppTypography.bodySmall,
    labelLarge: AppTypography.labelLarge,
    labelMedium: AppTypography.labelMedium,
    labelSmall: AppTypography.labelSmall,
  );

  static AppBarTheme get _appBarTheme => AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    titleTextStyle: AppTypography.headingMedium,
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: AppIconSizes.lg,
    ),
    actionsIconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: AppIconSizes.lg,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  static BottomNavigationBarThemeData get _bottomNavigationBarTheme =>
    BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceGlass,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.accentCyan,
      unselectedItemColor: AppColors.textSecondary,
      selectedLabelStyle: AppTypography.labelSmall,
      unselectedLabelStyle: AppTypography.labelSmall,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );

  static CardTheme get _cardTheme => CardTheme(
    color: AppColors.surfaceGlass,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: AppBorders.radiusMd,
      side: BorderSide(
        color: AppColors.borderAccent.withOpacity(0.3),
        width: 1,
      ),
    ),
  );

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentCyan,
        foregroundColor: AppColors.backgroundPrimary,
        disabledBackgroundColor: AppColors.textTertiary,
        disabledForegroundColor: AppColors.textMuted,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.radiusMd,
        ),
        textStyle: AppTypography.buttonLarge,
      ),
    );

  static OutlinedButtonThemeData get _outlinedButtonTheme =>
    OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accentCyan,
        disabledForegroundColor: AppColors.textTertiary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.radiusMd,
        ),
        side: BorderSide(
          color: AppColors.accentCyan,
          width: 1.5,
        ),
        textStyle: AppTypography.buttonLarge,
      ),
    );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.accentCyan,
      disabledForegroundColor: AppColors.textTertiary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppBorders.radiusSm,
      ),
      textStyle: AppTypography.buttonMedium,
    ),
  );

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceGlass,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    hintStyle: AppTypography.bodyMedium.copyWith(
      color: AppColors.textMuted,
    ),
    labelStyle: AppTypography.labelMedium,
    errorStyle: AppTypography.bodySmall.copyWith(
      color: AppColors.accentError,
    ),
    border: OutlineInputBorder(
      borderRadius: AppBorders.radiusMd,
      borderSide: BorderSide(
        color: AppColors.borderAccent,
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppBorders.radiusMd,
      borderSide: BorderSide(
        color: AppColors.borderAccent.withOpacity(0.5),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppBorders.radiusMd,
      borderSide: BorderSide(
        color: AppColors.accentCyan,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppBorders.radiusMd,
      borderSide: BorderSide(
        color: AppColors.accentError,
        width: 1,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppBorders.radiusMd,
      borderSide: BorderSide(
        color: AppColors.accentError,
        width: 2,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: AppBorders.radiusMd,
      borderSide: BorderSide(
        color: AppColors.borderSubtle.withOpacity(0.5),
        width: 1,
      ),
    ),
  );

  static CheckboxThemeData get _checkboxTheme => CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.accentCyan;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(AppColors.backgroundPrimary),
    side: BorderSide(
      color: AppColors.borderAccent,
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );

  static SwitchThemeData get _switchTheme => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.accentCyan;
      }
      return AppColors.textSecondary;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.accentCyan.withOpacity(0.4);
      }
      return AppColors.textMuted.withOpacity(0.3);
    }),
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  );

  static SliderThemeData get _sliderTheme => SliderThemeData(
    activeTrackColor: AppColors.accentCyan,
    inactiveTrackColor: AppColors.textMuted.withOpacity(0.3),
    thumbColor: AppColors.accentCyan,
    overlayColor: AppColors.accentCyan.withOpacity(0.2),
    valueIndicatorColor: AppColors.accentCyan,
    valueIndicatorTextStyle: AppTypography.labelSmall.copyWith(
      color: AppColors.backgroundPrimary,
    ),
    trackHeight: 4,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
  );

  static ProgressIndicatorThemeData get _progressIndicatorTheme =>
    const ProgressIndicatorThemeData(
      color: AppColors.accentCyan,
      linearTrackColor: AppColors.textMuted,
      circularTrackColor: AppColors.textMuted,
      linearMinHeight: 4,
    );

  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
    backgroundColor: AppColors.surfaceGlassStrong,
    contentTextStyle: AppTypography.bodyMedium,
    actionTextColor: AppColors.accentCyan,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: AppBorders.radiusMd,
      side: BorderSide(
        color: AppColors.borderAccent,
        width: 1,
      ),
    ),
  );

  static DialogTheme get _dialogTheme => DialogTheme(
    backgroundColor: AppColors.surfaceGlassStrong,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: AppBorders.radiusLg,
      side: BorderSide(
        color: AppColors.borderAccent,
        width: 1,
      ),
    ),
    titleTextStyle: AppTypography.headingMedium,
    contentTextStyle: AppTypography.bodyMedium,
  );

  static BottomSheetThemeData get _bottomSheetTheme => BottomSheetThemeData(
    backgroundColor: AppColors.surfaceGlassStrong,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXl),
      ),
    ),
    showDragHandle: true,
    dragHandleColor: AppColors.borderAccent,
  );

  static TabBarTheme get _tabBarTheme => TabBarTheme(
    labelColor: AppColors.accentCyan,
    unselectedLabelColor: AppColors.textSecondary,
    labelStyle: AppTypography.labelLarge,
    unselectedLabelStyle: AppTypography.labelLarge,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: AppColors.accentCyan.withOpacity(0.8),
          width: 2,
        ),
      ),
    ),
    indicatorSize: TabBarIndicatorSize.label,
  );

  static ChipThemeData get _chipTheme => ChipThemeData(
    backgroundColor: AppColors.surfaceGlass,
    selectedColor: AppColors.accentCyan.withOpacity(0.2),
    disabledColor: AppColors.surfaceGlass.withOpacity(0.5),
    labelStyle: AppTypography.labelMedium,
    secondaryLabelStyle: AppTypography.labelMedium,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: AppBorders.radiusPill,
      side: BorderSide(
        color: AppColors.borderAccent,
        width: 1,
      ),
    ),
  );

  static TooltipThemeData get _tooltipTheme => TooltipThemeData(
    decoration: BoxDecoration(
      color: AppColors.surfaceGlassStrong,
      borderRadius: AppBorders.radiusSm,
      border: Border.all(
        color: AppColors.borderAccent,
        width: 1,
      ),
    ),
    textStyle: AppTypography.bodySmall,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
  );

  static PageTransitionsTheme get _pageTransitionsTheme =>
    const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    );

  static TextSelectionThemeData get _textSelectionTheme =>
    TextSelectionThemeData(
      cursorColor: AppColors.accentCyan,
      selectionColor: AppColors.accentCyan.withOpacity(0.3),
      selectionHandleColor: AppColors.accentCyan,
    );
}
