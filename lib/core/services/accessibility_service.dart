import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Accessibility service for managing user preferences.
class AccessibilityService {
  AccessibilityService._();
  static final AccessibilityService _instance = AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  /// Whether reduced motion is preferred.
  bool get prefersReducedMotion {
    return MediaQueryData.fromView(View.of(WidgetsBinding.instance.rootElement!))
        .disableAnimations;
  }

  /// Whether high contrast mode is preferred.
  bool get prefersHighContrast {
    return MediaQueryData.fromView(View.of(WidgetsBinding.instance.rootElement!))
        .highContrast;
  }

  /// Whether bold text is preferred.
  bool get prefersBoldText {
    return MediaQueryData.fromView(View.of(WidgetsBinding.instance.rootElement!))
        .boldText;
  }

  /// Animation duration based on reduced motion preference.
  Duration get animationDuration {
    return prefersReducedMotion ? Duration.zero : const Duration(milliseconds: 300);
  }

  /// Animation duration for micro-interactions.
  Duration get microAnimationDuration {
    return prefersReducedMotion ? Duration.zero : const Duration(milliseconds: 150);
  }

  /// Duration for page transitions.
  Duration get transitionDuration {
    return prefersReducedMotion ? Duration.zero : const Duration(milliseconds: 400);
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
