/// Mission categories.
enum MissionCategory {
  daily,
  weekly,
  monthly,
  recovery,
  boss,
  seasonal,
  specialEvent,
}

extension MissionCategoryExtension on MissionCategory {
  String get label {
    switch (this) {
      case MissionCategory.daily:
        return 'Daily';
      case MissionCategory.weekly:
        return 'Weekly';
      case MissionCategory.monthly:
        return 'Monthly';
      case MissionCategory.recovery:
        return 'Recovery';
      case MissionCategory.boss:
        return 'Boss';
      case MissionCategory.seasonal:
        return 'Seasonal';
      case MissionCategory.specialEvent:
        return 'Special';
    }
  }

  String get description {
    switch (this) {
      case MissionCategory.daily:
        return 'Complete within 24 hours';
      case MissionCategory.weekly:
        return 'Complete within 7 days';
      case MissionCategory.monthly:
        return 'Complete within 30 days';
      case MissionCategory.recovery:
        return 'Focus on rest and recovery';
      case MissionCategory.boss:
        return 'Challenge your limits';
      case MissionCategory.seasonal:
        return 'Limited time opportunity';
      case MissionCategory.specialEvent:
        return 'Exclusive event mission';
    }
  }

  Duration? get timeLimit {
    switch (this) {
      case MissionCategory.daily:
        return const Duration(hours: 24);
      case MissionCategory.weekly:
        return const Duration(days: 7);
      case MissionCategory.monthly:
        return const Duration(days: 30);
      case MissionCategory.recovery:
        return const Duration(hours: 48);
      case MissionCategory.boss:
        return const Duration(days: 14);
      case MissionCategory.seasonal:
        return null; // Varies by season
      case MissionCategory.specialEvent:
        return null;
    }
  }

  double get baseXPMultiplier {
    switch (this) {
      case MissionCategory.daily:
        return 1.0;
      case MissionCategory.weekly:
        return 2.0;
      case MissionCategory.monthly:
        return 5.0;
      case MissionCategory.recovery:
        return 0.5;
      case MissionCategory.boss:
        return 3.0;
      case MissionCategory.seasonal:
        return 2.5;
      case MissionCategory.specialEvent:
        return 2.0;
    }
  }
}

/// Mission difficulty levels.
enum MissionDifficulty {
  trivial,
  easy,
  medium,
  hard,
  extreme,
  legendary,
}

extension MissionDifficultyExtension on MissionDifficulty {
  String get label {
    switch (this) {
      case MissionDifficulty.trivial:
        return 'Trivial';
      case MissionDifficulty.easy:
        return 'Easy';
      case MissionDifficulty.medium:
        return 'Medium';
      case MissionDifficulty.hard:
        return 'Hard';
      case MissionDifficulty.extreme:
        return 'Extreme';
      case MissionDifficulty.legendary:
        return 'Legendary';
    }
  }

  double get xpMultiplier {
    switch (this) {
      case MissionDifficulty.trivial:
        return 0.5;
      case MissionDifficulty.easy:
        return 0.8;
      case MissionDifficulty.medium:
        return 1.0;
      case MissionDifficulty.hard:
        return 1.5;
      case MissionDifficulty.extreme:
        return 2.0;
      case MissionDifficulty.legendary:
        return 3.0;
    }
  }

  /// Recommended readiness level for this difficulty.
  int get minReadiness {
    switch (this) {
      case MissionDifficulty.trivial:
        return 0;
      case MissionDifficulty.easy:
        return 20;
      case MissionDifficulty.medium:
        return 40;
      case MissionDifficulty.hard:
        return 60;
      case MissionDifficulty.extreme:
        return 80;
      case MissionDifficulty.legendary:
        return 95;
    }
  }
}

/// Mission objective type.
enum MissionObjectiveType {
  completeWorkout,
  achieveStreak,
  reachStatLevel,
  logRecovery,
  logHydration,
  logSleep,
  customMetric,
}

extension MissionObjectiveTypeExtension on MissionObjectiveType {
  String get label {
    switch (this) {
      case MissionObjectiveType.completeWorkout:
        return 'Complete Workout';
      case MissionObjectiveType.achieveStreak:
        return 'Maintain Streak';
      case MissionObjectiveType.reachStatLevel:
        return 'Reach Stat Level';
      case MissionObjectiveType.logRecovery:
        return 'Log Recovery';
      case MissionObjectiveType.logHydration:
        return 'Log Hydration';
      case MissionObjectiveType.logSleep:
        return 'Log Sleep';
      case MissionObjectiveType.customMetric:
        return 'Custom Objective';
    }
  }
}

/// A mission objective.
class MissionObjective {
  const MissionObjective({
    required this.type,
    required this.target,
    this.current = 0,
    this.isCompleted = false,
  });

  final MissionObjectiveType type;
  final int target;
  final int current;
  final bool isCompleted;

  double get progress => target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

  MissionObjective copyWith({
    MissionObjectiveType? type,
    int? target,
    int? current,
    bool? isCompleted,
  }) {
    return MissionObjective(
      type: type ?? this.type,
      target: target ?? this.target,
      current: current ?? this.current,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'target': target,
        'current': current,
        'isCompleted': isCompleted,
      };

  factory MissionObjective.fromJson(Map<String, dynamic> json) {
    return MissionObjective(
      type: MissionObjectiveType.values[json['type'] as int],
      target: json['target'] as int,
      current: json['current'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

/// A mission entity.
class Mission {
  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.objectives,
    required this.startTime,
    this.endTime,
    this.deadline,
    this.xpReward = 100,
    this.statRewards = const {},
    this.titleProgress = 0,
    this.status = MissionStatus.available,
    this.assignedWorkoutType,
  });

  final String id;
  final String title;
  final String description;
  final MissionCategory category;
  final MissionDifficulty difficulty;
  final List<MissionObjective> objectives;
  final DateTime startTime;
  final DateTime? endTime;
  final DateTime? deadline;
  final int xpReward;
  final Map<String, double> statRewards;
  final int titleProgress;
  final MissionStatus status;
  final String? assignedWorkoutType;

  /// Check if all objectives are complete.
  bool get isComplete => objectives.every((o) => o.isCompleted);

  /// Overall progress across all objectives.
  double get progress {
    if (objectives.isEmpty) return 0.0;
    return objectives.fold(0.0, (sum, o) => sum + o.progress) /
        objectives.length;
  }

  /// Time remaining until deadline.
  Duration? get timeRemaining {
    if (deadline == null) return null;
    return deadline!.difference(DateTime.now());
  }

  /// Check if mission is expired.
  bool get isExpired {
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline!);
  }

  /// Calculate actual XP reward based on difficulty and completion.
  int calculateXPReward() {
    if (!isComplete) return 0;
    final difficultyMultiplier = difficulty.xpMultiplier;
    final categoryMultiplier = category.baseXPMultiplier;
    return (xpReward * difficultyMultiplier * categoryMultiplier).round();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category.index,
        'difficulty': difficulty.index,
        'objectives': objectives.map((o) => o.toJson()).toList(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'deadline': deadline?.toIso8601String(),
        'xpReward': xpReward,
        'statRewards': statRewards,
        'titleProgress': titleProgress,
        'status': status.index,
        'assignedWorkoutType': assignedWorkoutType,
      };

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: MissionCategory.values[json['category'] as int],
      difficulty: MissionDifficulty.values[json['difficulty'] as int],
      objectives: (json['objectives'] as List<dynamic>)
          .map((o) => MissionObjective.fromJson(o as Map<String, dynamic>))
          .toList(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      xpReward: json['xpReward'] as int? ?? 100,
      statRewards: (json['statRewards'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
          {},
      titleProgress: json['titleProgress'] as int? ?? 0,
      status: MissionStatus.values[json['status'] as int? ?? 0],
      assignedWorkoutType: json['assignedWorkoutType'] as String?,
    );
  }

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    MissionCategory? category,
    MissionDifficulty? difficulty,
    List<MissionObjective>? objectives,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? deadline,
    int? xpReward,
    Map<String, double>? statRewards,
    int? titleProgress,
    MissionStatus? status,
    String? assignedWorkoutType,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      objectives: objectives ?? this.objectives,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      deadline: deadline ?? this.deadline,
      xpReward: xpReward ?? this.xpReward,
      statRewards: statRewards ?? this.statRewards,
      titleProgress: titleProgress ?? this.titleProgress,
      status: status ?? this.status,
      assignedWorkoutType: assignedWorkoutType ?? this.assignedWorkoutType,
    );
  }
}

enum MissionStatus {
  available,
  active,
  completed,
  failed,
  expired,
}

extension MissionStatusExtension on MissionStatus {
  String get label {
    switch (this) {
      case MissionStatus.available:
        return 'Available';
      case MissionStatus.active:
        return 'Active';
      case MissionStatus.completed:
        return 'Completed';
      case MissionStatus.failed:
        return 'Failed';
      case MissionStatus.expired:
        return 'Expired';
    }
  }
}
