import 'package:flutter/material.dart';

/// Accessibility service for managing user preferences.
class AccessibilityService {
  AccessibilityService._();
  static final AccessibilityService _instance =
      AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  /// Whether reduced motion is preferred.
  bool get prefersReducedMotion {
    try {
      final binding = WidgetsBinding.instance;
      // Use platformDispatcher directly - it's always available
      // accessibleNavigation is a proxy for reduced motion check
      return binding.platformDispatcher.accessibilityFeatures.accessibleNavigation;
    } catch (_) {
      return false;
    }
  }

  /// Whether high contrast mode is preferred.
  bool get prefersHighContrast {
    try {
      final binding = WidgetsBinding.instance;
      return binding.platformDispatcher.accessibilityFeatures.invertColors;
    } catch (_) {
      return false;
    }
  }

  /// Whether bold text is preferred.
  bool get prefersBoldText {
    try {
      final binding = WidgetsBinding.instance;
      return binding.platformDispatcher.accessibilityFeatures.boldText;
    } catch (_) {
      return false;
    }
  }

  /// Animation duration based on reduced motion preference.
  Duration get animationDuration {
    return prefersReducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 300);
  }

  /// Animation duration for micro-interactions.
  Duration get microAnimationDuration {
    return prefersReducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 150);
  }

  /// Duration for page transitions.
  Duration get transitionDuration {
    return prefersReducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 400);
  }
}

/// Extension for checking accessibility preferences on BuildContext.
extension AccessibilityExtension on BuildContext {
  /// Get the accessibility service.
  AccessibilityService get accessibility => AccessibilityService();

  /// Check if reduced motion is preferred.
  bool get prefersReducedMotion => accessibility.prefersReducedMotion;

  /// Check if high contrast is preferred.
  bool get prefersHighContrast => accessibility.prefersHighContrast;
}

/// A widget that provides accessibility-aware animation behavior.
class ReducedMotionBuilder extends StatelessWidget {
  const ReducedMotionBuilder({
    super.key,
    required this.builder,
    this.reducedBuilder,
  });

  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context)? reducedBuilder;

  @override
  Widget build(BuildContext context) {
    if (AccessibilityService().prefersReducedMotion && reducedBuilder != null) {
      return reducedBuilder!(context);
    }
    return builder(context);
  }
}
