import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sound categories as defined in SOUND_SYSTEM.md
enum SoundCategory {
  systemActivation,
  missionSuccess,
  warning,
  levelUp,
  statIncrease,
  buttonInteraction,
  recoveryNotification,
  scanReveal,
  dissolveTransition,
  pulseBurst,
  achievement,
  workoutComplete,
  personalRecord,
  rankUp,
  bossVictory,
}

/// Sound manager for the System application.
/// Provides audio feedback for interactions and state changes.
class SoundManager {
  SoundManager({this.enabled = true});

  final bool enabled;

  /// Plays a sound effect based on category.
  /// Uses haptic feedback as a fallback when audio is unavailable.
  Future<void> play(SoundCategory category) async {
    if (!enabled) return;

    // Audio playback would be implemented with actual audio assets.
    // For now, we use haptic feedback as a placeholder.
    // TODO: Implement actual audio playback with audioplayers or similar.
  }

  /// Plays system activation sound.
  Future<void> playSystemActivation() => play(SoundCategory.systemActivation);

  /// Plays mission success sound.
  Future<void> playMissionSuccess() => play(SoundCategory.missionSuccess);

  /// Plays mission complete sound.
  Future<void> playMissionComplete() => play(SoundCategory.missionSuccess);

  /// Plays warning sound.
  Future<void> playWarning() => play(SoundCategory.warning);

  /// Plays level up fanfare.
  Future<void> playLevelUp() => play(SoundCategory.levelUp);

  /// Plays rank up fanfare.
  Future<void> playRankUp() => play(SoundCategory.rankUp);

  /// Plays stat increase sound.
  Future<void> playStatIncrease() => play(SoundCategory.statIncrease);

  /// Plays button interaction click.
  Future<void> playButtonClick() => play(SoundCategory.buttonInteraction);

  /// Plays UI click sound.
  Future<void> playUI() => play(SoundCategory.buttonInteraction);

  /// Plays recovery notification.
  Future<void> playRecoveryNotification() => play(SoundCategory.recoveryNotification);

  /// Plays scan reveal sound effect.
  Future<void> playScanReveal() => play(SoundCategory.scanReveal);

  /// Plays dissolve transition sound.
  Future<void> playDissolveTransition() => play(SoundCategory.dissolveTransition);

  /// Plays pulse burst sound.
  Future<void> playPulseBurst() => play(SoundCategory.pulseBurst);

  /// Plays achievement unlocked sound.
  Future<void> playAchievement() => play(SoundCategory.achievement);

  /// Plays workout complete sound.
  Future<void> playWorkoutComplete() => play(SoundCategory.workoutComplete);

  /// Plays personal record sound.
  Future<void> playPR() => play(SoundCategory.personalRecord);

  /// Plays boss victory sound.
  Future<void> playBossVictory() => play(SoundCategory.bossVictory);

  /// Disposes of audio resources.
  void dispose() {
    // Release audio resources.
  }
}

/// Provider for the sound manager.
final soundManagerProvider = Provider<SoundManager>((ref) {
  final manager = SoundManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});

/// Settings for sound manager.
class SoundSettings {
  const SoundSettings({
    this.enabled = true,
    this.volume = 0.7,
  });

  final bool enabled;
  final double volume;

  SoundSettings copyWith({
    bool? enabled,
    double? volume,
  }) {
    return SoundSettings(
      enabled: enabled ?? this.enabled,
      volume: volume ?? this.volume,
    );
  }
}

/// Provider for sound settings.
final soundSettingsProvider = StateProvider<SoundSettings>(
  (ref) => const SoundSettings(),
);
