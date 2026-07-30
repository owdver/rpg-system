import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Haptic patterns as defined in HAPTIC_SYSTEM.md
enum HapticPattern {
  /// Light tap for ordinary interaction.
  lightTap,

  /// Double tap for mission acceptance.
  doubleTap,

  /// Pulse for stat changes.
  pulse,

  /// Heavy impact for major milestones.
  heavyImpact,

  /// Selection feedback.
  selection,

  /// Success confirmation.
  success,

  /// Warning notification.
  warning,

  /// Error notification.
  error,

  /// Subtle scan effect.
  scanEffect,

  /// Energy burst effect.
  energyBurst,
}

/// Haptic manager for the System application.
/// Provides tactile feedback for interactions and state changes.
class HapticManager {
  HapticManager({this.enabled = true});

  final bool enabled;

  /// Plays a haptic pattern.
  Future<void> play(HapticPattern pattern) async {
    if (!enabled) return;

    switch (pattern) {
      case HapticPattern.lightTap:
        await HapticFeedback.lightImpact();
        break;

      case HapticPattern.doubleTap:
        await HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.lightImpact();
        break;

      case HapticPattern.pulse:
        await HapticFeedback.mediumImpact();
        break;

      case HapticPattern.heavyImpact:
        await HapticFeedback.heavyImpact();
        break;

      case HapticPattern.selection:
        await HapticFeedback.selectionClick();
        break;

      case HapticPattern.success:
        await HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 50));
        await HapticFeedback.lightImpact();
        break;

      case HapticPattern.warning:
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.mediumImpact();
        break;

      case HapticPattern.error:
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 50));
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 50));
        await HapticFeedback.heavyImpact();
        break;

      case HapticPattern.scanEffect:
        await HapticFeedback.selectionClick();
        await Future.delayed(const Duration(milliseconds: 30));
        await HapticFeedback.selectionClick();
        await Future.delayed(const Duration(milliseconds: 30));
        await HapticFeedback.selectionClick();
        break;

      case HapticPattern.energyBurst:
        await HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 20));
        await HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 20));
        await HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 20));
        await HapticFeedback.mediumImpact();
        break;
    }
  }

  /// Plays light tap for ordinary interaction.
  Future<void> lightTap() => play(HapticPattern.lightTap);

  /// Plays double tap for mission acceptance.
  Future<void> doubleTap() => play(HapticPattern.doubleTap);

  /// Plays pulse for stat changes.
  Future<void> pulse() => play(HapticPattern.pulse);

  /// Plays heavy impact for major milestones.
  Future<void> heavyImpact() => play(HapticPattern.heavyImpact);

  /// Plays selection feedback.
  Future<void> selection() => play(HapticPattern.selection);

  /// Plays success confirmation.
  Future<void> success() => play(HapticPattern.success);

  /// Plays warning notification.
  Future<void> warning() => play(HapticPattern.warning);

  /// Plays error notification.
  Future<void> error() => play(HapticPattern.error);

  /// Plays scan effect.
  Future<void> scanEffect() => play(HapticPattern.scanEffect);

  /// Plays energy burst effect.
  Future<void> energyBurst() => play(HapticPattern.energyBurst);
}

/// Provider for the haptic manager.
final hapticManagerProvider = Provider<HapticManager>((ref) {
  return HapticManager();
});

/// Settings for haptic manager.
class HapticSettings {
  const HapticSettings({
    this.enabled = true,
    this.intensity = 1.0,
  });

  final bool enabled;
  final double intensity;

  HapticSettings copyWith({
    bool? enabled,
    double? intensity,
  }) {
    return HapticSettings(
      enabled: enabled ?? this.enabled,
      intensity: intensity ?? this.intensity,
    );
  }
}

/// Provider for haptic settings.
final hapticSettingsProvider = StateProvider<HapticSettings>(
  (ref) => const HapticSettings(),
);
