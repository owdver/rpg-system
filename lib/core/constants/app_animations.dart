import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

/// Design tokens for animations following the holographic system aesthetic.
/// All animation values are defined with semantic naming for consistency.
abstract final class AppAnimations {
  // Duration constants (in milliseconds)
  static const Duration instant = Duration(milliseconds: 80);
  static const Duration quick = Duration(milliseconds: 160);
  static const Duration standard = Duration(milliseconds: 240);
  static const Duration medium = Duration(milliseconds: 360);
  static const Duration slow = Duration(milliseconds: 480);
  static const Duration long = Duration(milliseconds: 600);
  static const Duration cinematic = Duration(milliseconds: 900);
  static const Duration systemBoot = Duration(milliseconds: 1200);

  // Specific animation durations from ANIMATION_LIBRARY.md
  static const Duration windowMaterialize = Duration(milliseconds: 360);
  static const Duration windowDissolve = Duration(milliseconds: 260);
  static const Duration scanReveal = Duration(milliseconds: 500);
  static const Duration particleBurst = Duration(milliseconds: 420);
  static const Duration energySweep = Duration(milliseconds: 280);
  static const Duration xpOverflow = Duration(milliseconds: 700);
  static const Duration statIncrease = Duration(milliseconds: 320);
  static const Duration missionComplete = Duration(milliseconds: 800);
  static const Duration achievementReveal = Duration(milliseconds: 640);
  static const Duration levelUp = Duration(milliseconds: 900);
  static const Duration recoveryPulse = Duration(milliseconds: 460);

  // Easing curves
  static const Curve curveStandard = Curves.easeOutCubic;
  static const Curve energetic = Curves.easeOutQuint;
  static const Curve spring = Curves.easeOutBack;
  static const Curve curveCinematic = Curves.easeOutExpo;
  static const Curve smooth = Curves.easeInOutCubic;
  static const Curve sharp = Curves.easeOutQuad;
  static const Curve bounce = Curves.elasticOut;
  static const Curve overshoot = Curves.easeOutBack;

  // Animation controller values
  static const double defaultAnimationValue = 1.0;
  static const double scaleInFrom = 0.96;
  static const double scaleInTo = 1.0;
  static const double scaleOutFrom = 1.0;
  static const double scaleOutTo = 0.96;

  // Particle system constants
  static const int defaultParticleCount = 50;
  static const double defaultParticleSpeed = 2.0;
  static const double defaultParticleLife = 1.0;
  static const double defaultParticleSize = 4.0;

  // Animation delay sequences
  static const Duration staggeredDelay = Duration(milliseconds: 50);
  static const Duration sequentialDelay = Duration(milliseconds: 100);
  static const Duration reverseDelay = Duration(milliseconds: 75);

  // Loop animation durations
  static const Duration pulseLoop = Duration(milliseconds: 2000);
  static const Duration floatLoop = Duration(milliseconds: 3000);
  static const Duration glowLoop = Duration(milliseconds: 1500);
  static const Duration shimmerLoop = Duration(milliseconds: 1000);

  // Blur and glow values
  static const double blurMin = 8.0;
  static const double blurMax = 24.0;
  static const double blurPanel = 24.0;
  static const double blurOverlay = 40.0;

  // Glow intensities
  static const double glowLow = 0.15;
  static const double glowMedium = 0.30;
  static const double glowHigh = 0.50;
  static const double glowMax = 0.80;
}

/// Predefined animation specs for common holographic effects.
abstract final class AppAnimationSpecs {
  static Animation<double> materialize(AnimationController controller) {
    return CurvedAnimation(
      parent: controller,
      curve: AppAnimations.energetic,
      reverseCurve: AppAnimations.sharp,
    );
  }

  static Animation<double> dissolve(AnimationController controller) {
    return CurvedAnimation(
      parent: controller,
      curve: AppAnimations.curveStandard,
    );
  }

  static Animation<double> scanReveal(AnimationController controller) {
    return CurvedAnimation(
      parent: controller,
      curve: AppAnimations.curveCinematic,
    );
  }

  static Animation<double> pulse(AnimationController controller) {
    return Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  static Animation<double> glow(AnimationController controller) {
    return Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }
}

// Extension for animation utilities
extension AnimationExtensions on Animation<double> {
  Animation<double> get reversed => ReverseAnimation(this);

  Animation<double> withCurve(Curve curve) {
    return CurvedAnimation(parent: this, curve: curve);
  }
}
