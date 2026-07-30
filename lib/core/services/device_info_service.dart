import 'package:flutter/material.dart';

/// Device type classification.
enum DeviceType {
  phone,
  tablet,
  desktop,
}

/// Screen size breakpoints.
class DeviceBreakpoints {
  static const double smallPhone = 320;
  static const double phone = 375;
  static const double largePhone = 414;
  static const double tablet = 600;
  static const double desktop = 900;
  static const double largeDesktop = 1200;
}

/// Responsive layout configuration.
class ResponsiveConfig {
  final DeviceType deviceType;
  final double screenWidth;
  final double screenHeight;
  final bool isLandscape;
  final bool isTablet;
  final bool isFoldable;
  final bool hasNotch;
  final bool hasHomeIndicator;
  final EdgeInsets safeAreaPadding;
  final double textScaleFactor;

  const ResponsiveConfig({
    required this.deviceType,
    required this.screenWidth,
    required this.screenHeight,
    required this.isLandscape,
    required this.isTablet,
    required this.isFoldable,
    required this.hasNotch,
    required this.hasHomeIndicator,
    required this.safeAreaPadding,
    required this.textScaleFactor,
  });

  /// Get padding for notch/dynamic island.
  EdgeInsets get notchPadding => EdgeInsets.only(
        top: safeAreaPadding.top,
        left: safeAreaPadding.left,
        right: safeAreaPadding.right,
      );

  /// Get padding for home indicator.
  EdgeInsets get homeIndicatorPadding => EdgeInsets.only(
        bottom: safeAreaPadding.bottom,
      );

  /// Get horizontal padding.
  double get horizontalPadding {
    if (deviceType == DeviceType.phone) return 16;
    if (deviceType == DeviceType.tablet) return 32;
    return 48;
  }

  /// Get vertical padding.
  double get verticalPadding {
    if (deviceType == DeviceType.phone) return 12;
    if (deviceType == DeviceType.tablet) return 24;
    return 32;
  }

  /// Grid column count based on device type.
  int get gridColumns {
    if (deviceType == DeviceType.phone) return 2;
    if (deviceType == DeviceType.tablet) return 4;
    return 6;
  }

  /// Max content width.
  double get maxContentWidth {
    if (deviceType == DeviceType.phone) return double.infinity;
    if (deviceType == DeviceType.tablet) return 600;
    return 800;
  }
}

/// Service for detecting device characteristics.
class DeviceInfoService {
  DeviceInfoService._();
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  factory DeviceInfoService() => _instance;
  DeviceInfoService._internal();

  /// Get responsive configuration from context.
  ResponsiveConfig getConfig(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final orientation = mediaQuery.orientation;
    final padding = mediaQuery.padding;
    final textScaleFactor = mediaQuery.textScaler.scale(1);

    final isLandscape = orientation == Orientation.landscape;
    final width = isLandscape ? size.height : size.width;
    final height = isLandscape ? size.width : size.height;

    // Detect device type
    final deviceType = _getDeviceType(width);

    // Detect if tablet
    final isTablet = deviceType == DeviceType.tablet;

    // Detect foldable (using shortest side)
    final isFoldable = size.shortestSide < DeviceBreakpoints.phone;

    // Detect notch/dynamic island
    final hasNotch = padding.top > 20;

    // Detect home indicator
    final hasHomeIndicator = padding.bottom > 0;

    return ResponsiveConfig(
      deviceType: deviceType,
      screenWidth: width,
      screenHeight: height,
      isLandscape: isLandscape,
      isTablet: isTablet,
      isFoldable: isFoldable,
      hasNotch: hasNotch,
      hasHomeIndicator: hasHomeIndicator,
      safeAreaPadding: padding,
      textScaleFactor: textScaleFactor,
    );
  }

  DeviceType _getDeviceType(double width) {
    if (width >= DeviceBreakpoints.tablet) {
      return DeviceType.tablet;
    }
    return DeviceType.phone;
  }
}

/// Extension for easy access to device info.
extension DeviceInfoExtension on BuildContext {
  ResponsiveConfig get responsive => DeviceInfoService().getConfig(this);
  DeviceType get deviceType => responsive.deviceType;
  bool get isTablet => responsive.isTablet;
  bool get isLandscape => responsive.isLandscape;
}

/// Responsive builder widget.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.phoneBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
  });

  final Widget Function(BuildContext context, ResponsiveConfig config) builder;
  final Widget Function(BuildContext context, ResponsiveConfig config)? phoneBuilder;
  final Widget Function(BuildContext context, ResponsiveConfig config)? tabletBuilder;
  final Widget Function(BuildContext context, ResponsiveConfig config)? desktopBuilder;

  @override
  Widget build(BuildContext context) {
    final config = context.responsive;

    switch (config.deviceType) {
      case DeviceType.phone:
        return phoneBuilder?.call(context, config) ?? builder(context, config);
      case DeviceType.tablet:
        return tabletBuilder?.call(context, config) ?? builder(context, config);
      case DeviceType.desktop:
        return desktopBuilder?.call(context, config) ?? builder(context, config);
    }
  }
}

/// Widget for phone-specific layouts.
class PhoneLayout extends StatelessWidget {
  const PhoneLayout({
    super.key,
    required this.child,
    this.maxWidth = DeviceBreakpoints.phone,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Widget for tablet-specific layouts.
class TabletLayout extends StatelessWidget {
  const TabletLayout({
    super.key,
    required this.child,
    this.padding = 32,
  });

  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}

/// Safe area wrapper with notch handling.
class SafeAreaWrapper extends StatelessWidget {
  const SafeAreaWrapper({
    super.key,
    required this.child,
    this.includeNotch = true,
    this.includeHomeIndicator = true,
  });

  final Widget child;
  final bool includeNotch;
  final bool includeHomeIndicator;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Padding(
      padding: EdgeInsets.only(
        top: includeNotch ? padding.top : 0,
        bottom: includeHomeIndicator ? padding.bottom : 0,
        left: padding.left,
        right: padding.right,
      ),
      child: child,
    );
  }
}

/// Orientation-aware layout wrapper.
class OrientationLayout extends StatelessWidget {
  const OrientationLayout({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  final Widget portrait;
  final Widget landscape;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait ? portrait : landscape;
  }
}

/// Aspect ratio constraints for different content types.
class AspectRatioConstraints {
  static const double card16x9 = 16 / 9;
  static const double card4x3 = 4 / 3;
  static const double card1x1 = 1;
  static const double card3x4 = 3 / 4;

  static const double banner16x9 = 16 / 9;
  static const double banner3x1 = 3 / 1;

  static const double icon1x1 = 1;
  static const double icon4x3 = 4 / 3;
}
