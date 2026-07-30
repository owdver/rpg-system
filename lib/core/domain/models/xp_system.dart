/// XP event sources.
enum XPSource {
  workoutCompletion,
  exerciseQuality,
  recoveryQuality,
  missionCompletion,
  dailyStreak,
  weeklyStreak,
  monthlyStreak,
  bossVictory,
  achievementUnlock,
  waterLogged,
  sleepRecorded,
  goalAchieved,
  specialEvent,
}

extension XPSourceExtension on XPSource {
  String get label {
    switch (this) {
      case XPSource.workoutCompletion:
        return 'Workout';
      case XPSource.exerciseQuality:
        return 'Quality';
      case XPSource.recoveryQuality:
        return 'Recovery';
      case XPSource.missionCompletion:
        return 'Mission';
      case XPSource.dailyStreak:
        return 'Daily Streak';
      case XPSource.weeklyStreak:
        return 'Weekly Streak';
      case XPSource.monthlyStreak:
        return 'Monthly Streak';
      case XPSource.bossVictory:
        return 'Boss Victory';
      case XPSource.achievementUnlock:
        return 'Achievement';
      case XPSource.waterLogged:
        return 'Hydration';
      case XPSource.sleepRecorded:
        return 'Sleep';
      case XPSource.goalAchieved:
        return 'Goal';
      case XPSource.specialEvent:
        return 'Special';
    }
  }

  String get icon {
    switch (this) {
      case XPSource.workoutCompletion:
        return '💪';
      case XPSource.exerciseQuality:
        return '⭐';
      case XPSource.recoveryQuality:
        return '🔄';
      case XPSource.missionCompletion:
        return '🎯';
      case XPSource.dailyStreak:
        return '🔥';
      case XPSource.weeklyStreak:
        return '📅';
      case XPSource.monthlyStreak:
        return '🗓️';
      case XPSource.bossVictory:
        return '🏆';
      case XPSource.achievementUnlock:
        return '🏅';
      case XPSource.waterLogged:
        return '💧';
      case XPSource.sleepRecorded:
        return '😴';
      case XPSource.goalAchieved:
        return '🎯';
      case XPSource.specialEvent:
        return '✨';
    }
  }

  /// Base XP multiplier for this source type.
  double get baseMultiplier {
    switch (this) {
      case XPSource.workoutCompletion:
        return 1.0;
      case XPSource.exerciseQuality:
        return 0.5;
      case XPSource.recoveryQuality:
        return 0.3;
      case XPSource.missionCompletion:
        return 1.5;
      case XPSource.dailyStreak:
        return 1.2;
      case XPSource.weeklyStreak:
        return 2.0;
      case XPSource.monthlyStreak:
        return 5.0;
      case XPSource.bossVictory:
        return 3.0;
      case XPSource.achievementUnlock:
        return 1.0;
      case XPSource.waterLogged:
        return 0.1;
      case XPSource.sleepRecorded:
        return 0.5;
      case XPSource.goalAchieved:
        return 1.5;
      case XPSource.specialEvent:
        return 2.0;
    }
  }
}

/// An individual XP reward event.
class XPEvent {
  const XPEvent({
    required this.id,
    required this.source,
    required this.amount,
    required this.timestamp,
    this.multiplier = 1.0,
    this.relatedMissionId,
    this.relatedWorkoutId,
    this.relatedAchievementId,
  });

  final String id;
  final XPSource source;
  final int amount;
  final DateTime timestamp;
  final double multiplier;
  final String? relatedMissionId;
  final String? relatedWorkoutId;
  final String? relatedAchievementId;

  /// Effective XP after multiplier.
  int get effectiveXP => (amount * multiplier).round();

  Map<String, dynamic> toJson() => {
        'id': id,
        'source': source.index,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
        'multiplier': multiplier,
        'relatedMissionId': relatedMissionId,
        'relatedWorkoutId': relatedWorkoutId,
        'relatedAchievementId': relatedAchievementId,
      };

  factory XPEvent.fromJson(Map<String, dynamic> json) {
    return XPEvent(
      id: json['id'] as String,
      source: XPSource.values[json['source'] as int],
      amount: json['amount'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
      relatedMissionId: json['relatedMissionId'] as String?,
      relatedWorkoutId: json['relatedWorkoutId'] as String?,
      relatedAchievementId: json['relatedAchievementId'] as String?,
    );
  }
}

/// Complete XP state for the user.
class XPState {
  const XPState({
    this.totalXP = 0,
    this.currentLevelXP = 0,
    this.level = 1,
    this.recentEvents = const [],
    this.streakDays = 0,
    this.streakWeeks = 0,
    this.streakMonths = 0,
  });

  final int totalXP;
  final int currentLevelXP;
  final int level;
  final List<XPEvent> recentEvents;
  final int streakDays;
  final int streakWeeks;
  final int streakMonths;

  /// XP needed for the next level.
  int get xpToNextLevel => xpRequiredForLevel(level + 1);

  /// Progress to next level (0.0 to 1.0).
  double get levelProgress {
    final currentThreshold = xpRequiredForLevel(level);
    final nextThreshold = xpRequiredForLevel(level + 1);
    final xpInLevel = totalXP - currentThreshold;
    final xpNeeded = nextThreshold - currentThreshold;
    return xpNeeded > 0 ? (xpInLevel / xpNeeded).clamp(0.0, 1.0) : 0.0;
  }

  /// Calculate XP required for a specific level.
  static int xpRequiredForLevel(int level) {
    // Exponential growth formula: base * (growth ^ level)
    const baseXP = 100;
    const growthRate = 1.15;
    return (baseXP * (level - 1) + baseXP * (growthRate * (level - 1))).round();
  }

  /// Calculate level from total XP.
  static int levelFromXP(int totalXP) {
    int level = 1;
    while (xpRequiredForLevel(level + 1) <= totalXP) {
      level++;
      if (level > 100) break; // Cap at level 100
    }
    return level;
  }

  XPState copyWith({
    int? totalXP,
    int? currentLevelXP,
    int? level,
    List<XPEvent>? recentEvents,
    int? streakDays,
    int? streakWeeks,
    int? streakMonths,
  }) {
    return XPState(
      totalXP: totalXP ?? this.totalXP,
      currentLevelXP: currentLevelXP ?? this.currentLevelXP,
      level: level ?? this.level,
      recentEvents: recentEvents ?? this.recentEvents,
      streakDays: streakDays ?? this.streakDays,
      streakWeeks: streakWeeks ?? this.streakWeeks,
      streakMonths: streakMonths ?? this.streakMonths,
    );
  }

  /// Add XP and return new state with level up if applicable.
  (XPState, bool) addXP(int xp, XPSource source, {String? missionId, String? workoutId}) {
    final newTotalXP = totalXP + xp;
    final newLevel = levelFromXP(newTotalXP);
    final leveledUp = newLevel > level;

    final event = XPEvent(
      id: '${source.name}_${DateTime.now().millisecondsSinceEpoch}',
      source: source,
      amount: xp,
      timestamp: DateTime.now(),
      relatedMissionId: missionId,
      relatedWorkoutId: workoutId,
    );

    return (
      XPState(
        totalXP: newTotalXP,
        currentLevelXP: xp,
        level: newLevel,
        recentEvents: [event, ...recentEvents].take(100).toList(),
        streakDays: source == XPSource.dailyStreak ? streakDays + 1 : streakDays,
        streakWeeks: source == XPSource.weeklyStreak ? streakWeeks + 1 : streakWeeks,
        streakMonths: source == XPSource.monthlyStreak ? streakMonths + 1 : streakMonths,
      ),
      leveledUp
    );
  }

  Map<String, dynamic> toJson() => {
        'totalXP': totalXP,
        'currentLevelXP': currentLevelXP,
        'level': level,
        'recentEvents': recentEvents.map((e) => e.toJson()).toList(),
        'streakDays': streakDays,
        'streakWeeks': streakWeeks,
        'streakMonths': streakMonths,
      };

  factory XPState.fromJson(Map<String, dynamic> json) {
    return XPState(
      totalXP: json['totalXP'] as int? ?? 0,
      currentLevelXP: json['currentLevelXP'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      recentEvents: (json['recentEvents'] as List<dynamic>?)
              ?.map((e) => XPEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      streakDays: json['streakDays'] as int? ?? 0,
      streakWeeks: json['streakWeeks'] as int? ?? 0,
      streakMonths: json['streakMonths'] as int? ?? 0,
    );
  }
}
