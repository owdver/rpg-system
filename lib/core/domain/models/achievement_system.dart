/// Achievement categories.
enum AchievementCategory {
  workout,
  streak,
  milestone,
  seasonal,
  legendary,
  hidden,
}

extension AchievementCategoryExtension on AchievementCategory {
  String get label {
    switch (this) {
      case AchievementCategory.workout:
        return 'Workout';
      case AchievementCategory.streak:
        return 'Streak';
      case AchievementCategory.milestone:
        return 'Milestone';
      case AchievementCategory.seasonal:
        return 'Seasonal';
      case AchievementCategory.legendary:
        return 'Legendary';
      case AchievementCategory.hidden:
        return 'Hidden';
    }
  }

  String get icon {
    switch (this) {
      case AchievementCategory.workout:
        return '💪';
      case AchievementCategory.streak:
        return '🔥';
      case AchievementCategory.milestone:
        return '🏆';
      case AchievementCategory.seasonal:
        return '❄️';
      case AchievementCategory.legendary:
        return '⭐';
      case AchievementCategory.hidden:
        return '❓';
    }
  }
}

/// Achievement type.
enum AchievementType {
  progressive, // Unlock by accumulating progress
  milestone, // Unlock at specific thresholds
  oneTime, // Single unlock condition
  secret, // Hidden until discovered
}

extension AchievementTypeExtension on AchievementType {
  String get label {
    switch (this) {
      case AchievementType.progressive:
        return 'Progressive';
      case AchievementType.milestone:
        return 'Milestone';
      case AchievementType.oneTime:
        return 'One-Time';
      case AchievementType.secret:
        return 'Secret';
    }
  }
}

/// An achievement definition.
class Achievement {
  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.type = AchievementType.oneTime,
    this.targetValue = 1,
    this.currentValue = 0,
    this.xpReward = 100,
    this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
    this.isSecret = false,
  });

  final String id;
  final String name;
  final String description;
  final AchievementCategory category;
  final AchievementType type;
  final int targetValue;
  final int currentValue;
  final int xpReward;
  final String? icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final bool isSecret;

  double get progress => targetValue > 0
      ? (currentValue / targetValue).clamp(0.0, 1.0)
      : 0.0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category.index,
        'type': type.index,
        'targetValue': targetValue,
        'currentValue': currentValue,
        'xpReward': xpReward,
        'icon': icon,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
        'isSecret': isSecret,
      };

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    AchievementCategory? category,
    AchievementType? type,
    int? targetValue,
    int? currentValue,
    int? xpReward,
    String? icon,
    bool? isUnlocked,
    DateTime? unlockedAt,
    bool? isSecret,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      xpReward: xpReward ?? this.xpReward,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isSecret: isSecret ?? this.isSecret,
    );
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: AchievementCategory.values[json['category'] as int],
      type: AchievementType.values[json['type'] as int? ?? 2],
      targetValue: json['targetValue'] as int? ?? 1,
      currentValue: json['currentValue'] as int? ?? 0,
      xpReward: json['xpReward'] as int? ?? 100,
      icon: json['icon'] as String?,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      isSecret: json['isSecret'] as bool? ?? false,
    );
  }
}

/// Predefined achievements catalog.
class AchievementCatalog {
  static const workoutAchievements = [
    Achievement(
      id: 'workout_first',
      name: 'First Step',
      description: 'Complete your first workout',
      category: AchievementCategory.workout,
      xpReward: 50,
      icon: '👟',
    ),
    Achievement(
      id: 'workout_10',
      name: 'Getting Started',
      description: 'Complete 10 workouts',
      category: AchievementCategory.workout,
      type: AchievementType.progressive,
      targetValue: 10,
      xpReward: 150,
      icon: '💪',
    ),
    Achievement(
      id: 'workout_50',
      name: 'Dedicated',
      description: 'Complete 50 workouts',
      category: AchievementCategory.workout,
      type: AchievementType.progressive,
      targetValue: 50,
      xpReward: 500,
      icon: '🔥',
    ),
    Achievement(
      id: 'workout_100',
      name: 'Centurion',
      description: 'Complete 100 workouts',
      category: AchievementCategory.workout,
      type: AchievementType.progressive,
      targetValue: 100,
      xpReward: 1000,
      icon: '🏆',
    ),
  ];

  static const streakAchievements = [
    Achievement(
      id: 'streak_3',
      name: 'Consistent',
      description: 'Maintain a 3-day streak',
      category: AchievementCategory.streak,
      targetValue: 3,
      xpReward: 75,
      icon: '📅',
    ),
    Achievement(
      id: 'streak_7',
      name: 'Week Warrior',
      description: 'Maintain a 7-day streak',
      category: AchievementCategory.streak,
      type: AchievementType.milestone,
      targetValue: 7,
      xpReward: 200,
      icon: '🗓️',
    ),
    Achievement(
      id: 'streak_30',
      name: 'Monthly Master',
      description: 'Maintain a 30-day streak',
      category: AchievementCategory.streak,
      type: AchievementType.milestone,
      targetValue: 30,
      xpReward: 1000,
      icon: '🌟',
    ),
    Achievement(
      id: 'streak_100',
      name: 'Unstoppable',
      description: 'Maintain a 100-day streak',
      category: AchievementCategory.streak,
      type: AchievementType.milestone,
      targetValue: 100,
      xpReward: 5000,
      icon: '⚡',
    ),
  ];

  static const milestoneAchievements = [
    Achievement(
      id: 'level_10',
      name: 'Rising Star',
      description: 'Reach level 10',
      category: AchievementCategory.milestone,
      type: AchievementType.milestone,
      targetValue: 10,
      xpReward: 300,
      icon: '⭐',
    ),
    Achievement(
      id: 'level_25',
      name: 'Proven',
      description: 'Reach level 25',
      category: AchievementCategory.milestone,
      type: AchievementType.milestone,
      targetValue: 25,
      xpReward: 750,
      icon: '🌟',
    ),
    Achievement(
      id: 'level_50',
      name: 'Elite',
      description: 'Reach level 50',
      category: AchievementCategory.milestone,
      type: AchievementType.milestone,
      targetValue: 50,
      xpReward: 2000,
      icon: '💫',
    ),
  ];

  static const legendaryAchievements = [
    Achievement(
      id: 'boss_first',
      name: 'Boss Hunter',
      description: 'Defeat your first boss mission',
      category: AchievementCategory.legendary,
      xpReward: 500,
      icon: '👹',
    ),
    Achievement(
      id: 'boss_5',
      name: 'Boss Slayer',
      description: 'Defeat 5 boss missions',
      category: AchievementCategory.legendary,
      type: AchievementType.progressive,
      targetValue: 5,
      xpReward: 1500,
      icon: '⚔️',
    ),
    Achievement(
      id: 'all_stats_50',
      name: 'Well Rounded',
      description: 'Reach level 50 in all primary stats',
      category: AchievementCategory.legendary,
      type: AchievementType.milestone,
      targetValue: 50,
      xpReward: 3000,
      icon: '🎯',
    ),
  ];

  static List<Achievement> get all => [
        ...workoutAchievements,
        ...streakAchievements,
        ...milestoneAchievements,
        ...legendaryAchievements,
      ];
}

/// Achievement state manager.
class AchievementState {
  const AchievementState({
    this.achievements = const [],
    this.recentlyUnlocked = const [],
  });

  final List<Achievement> achievements;
  final List<Achievement> recentlyUnlocked;

  Achievement? getAchievement(String id) {
    return achievements.where((a) => a.id == id).firstOrNull;
  }

  List<Achievement> getUnlocked() {
    return achievements.where((a) => a.isUnlocked).toList();
  }

  List<Achievement> getLocked() {
    return achievements.where((a) => !a.isUnlocked).toList();
  }

  int get unlockedCount => achievements.where((a) => a.isUnlocked).length;

  double get completionRate {
    if (achievements.isEmpty) return 0;
    return unlockedCount / achievements.length;
  }

  AchievementState copyWith({
    List<Achievement>? achievements,
    List<Achievement>? recentlyUnlocked,
  }) {
    return AchievementState(
      achievements: achievements ?? this.achievements,
      recentlyUnlocked: recentlyUnlocked ?? this.recentlyUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'achievements': achievements.map((a) => a.toJson()).toList(),
        'recentlyUnlocked': recentlyUnlocked.map((a) => a.id).toList(),
      };

  factory AchievementState.fromJson(Map<String, dynamic> json) {
    final achievementsList = (json['achievements'] as List<dynamic>?)
            ?.map((a) => Achievement.fromJson(a as Map<String, dynamic>))
            .toList() ??
        [];

    // Initialize with catalog if empty
    final achievements = achievementsList.isEmpty
        ? AchievementCatalog.all
        : achievementsList;

    return AchievementState(
      achievements: achievements,
      recentlyUnlocked: const [],
    );
  }
}
