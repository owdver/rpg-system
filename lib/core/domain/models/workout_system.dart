/// Workout types supported by the system.
enum WorkoutType {
  strength,
  hypertrophy,
  cardio,
  hiit,
  mobility,
  recovery,
  yoga,
  running,
  cycling,
  swimming,
  custom,
}

extension WorkoutTypeExtension on WorkoutType {
  String get label {
    switch (this) {
      case WorkoutType.strength:
        return 'Strength';
      case WorkoutType.hypertrophy:
        return 'Hypertrophy';
      case WorkoutType.cardio:
        return 'Cardio';
      case WorkoutType.hiit:
        return 'HIIT';
      case WorkoutType.mobility:
        return 'Mobility';
      case WorkoutType.recovery:
        return 'Recovery';
      case WorkoutType.yoga:
        return 'Yoga';
      case WorkoutType.running:
        return 'Running';
      case WorkoutType.cycling:
        return 'Cycling';
      case WorkoutType.swimming:
        return 'Swimming';
      case WorkoutType.custom:
        return 'Custom';
    }
  }

  String get icon {
    switch (this) {
      case WorkoutType.strength:
        return '🏋️';
      case WorkoutType.hypertrophy:
        return '💪';
      case WorkoutType.cardio:
        return '❤️';
      case WorkoutType.hiit:
        return '⚡';
      case WorkoutType.mobility:
        return '🧘';
      case WorkoutType.recovery:
        return '🔄';
      case WorkoutType.yoga:
        return '🧘';
      case WorkoutType.running:
        return '🏃';
      case WorkoutType.cycling:
        return '🚴';
      case WorkoutType.swimming:
        return '🏊';
      case WorkoutType.custom:
        return '⚙️';
    }
  }

  /// Primary stat this workout type develops.
  List<String> get primaryStats {
    switch (this) {
      case WorkoutType.strength:
      case WorkoutType.hypertrophy:
        return ['strength'];
      case WorkoutType.cardio:
      case WorkoutType.running:
      case WorkoutType.cycling:
      case WorkoutType.swimming:
        return ['endurance'];
      case WorkoutType.mobility:
      case WorkoutType.yoga:
        return ['mobility', 'focus'];
      case WorkoutType.hiit:
        return ['endurance', 'strength'];
      case WorkoutType.recovery:
        return ['recovery'];
      case WorkoutType.custom:
        return [];
    }
  }

  /// Base XP multiplier for completing this workout type.
  double get baseXPMultiplier {
    switch (this) {
      case WorkoutType.strength:
      case WorkoutType.hypertrophy:
        return 1.2;
      case WorkoutType.hiit:
        return 1.5;
      case WorkoutType.cardio:
      case WorkoutType.running:
      case WorkoutType.cycling:
      case WorkoutType.swimming:
        return 1.0;
      case WorkoutType.mobility:
      case WorkoutType.yoga:
        return 0.8;
      case WorkoutType.recovery:
        return 0.5;
      case WorkoutType.custom:
        return 1.0;
    }
  }
}

/// An exercise within a workout.
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.type,
    this.sets = const [],
    this.notes,
  });

  final String id;
  final String name;
  final WorkoutType type;
  final List<ExerciseSet> sets;
  final String? notes;

  int get totalReps => sets.fold(0, (sum, s) => sum + s.reps);
  double get totalVolume => sets.fold(0, (sum, s) => sum + s.volume);
  double get totalWeight => sets.fold(0, (sum, s) => sum + s.weight);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.index,
        'sets': sets.map((s) => s.toJson()).toList(),
        'notes': notes,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      type: WorkoutType.values[json['type'] as int],
      sets: (json['sets'] as List<dynamic>)
          .map((s) => ExerciseSet.fromJson(s as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );
  }
}

/// A set within an exercise.
class ExerciseSet {
  const ExerciseSet({
    this.reps = 0,
    this.weight = 0,
    this.duration,
    this.distance,
    this.isCompleted = false,
    this.isPersonalRecord = false,
  });

  final int reps;
  final double weight;
  final Duration? duration;
  final double? distance;
  final bool isCompleted;
  final bool isPersonalRecord;

  double get volume => reps * weight;

  Map<String, dynamic> toJson() => {
        'reps': reps,
        'weight': weight,
        'duration': duration?.inSeconds,
        'distance': distance,
        'isCompleted': isCompleted,
        'isPersonalRecord': isPersonalRecord,
      };

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      reps: json['reps'] as int? ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      duration: json['duration'] != null
          ? Duration(seconds: json['duration'] as int)
          : null,
      distance: (json['distance'] as num?)?.toDouble(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      isPersonalRecord: json['isPersonalRecord'] as bool? ?? false,
    );
  }
}

/// Workout session state.
class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.type,
    required this.startTime,
    this.endTime,
    this.exercises = const [],
    this.status = WorkoutStatus.active,
    this.intensity = 1.0,
    this.qualityScore = 0,
    this.effortScore = 0,
    this.estimatedCalories = 0,
    this.notes,
  });

  final String id;
  final WorkoutType type;
  final DateTime startTime;
  final DateTime? endTime;
  final List<Exercise> exercises;
  final WorkoutStatus status;
  final double intensity;
  final int qualityScore;
  final int effortScore;
  final int estimatedCalories;
  final String? notes;

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  double get totalVolume {
    return exercises.fold(0, (sum, e) => sum + e.totalVolume);
  }

  int get totalSets {
    return exercises.fold(0, (sum, e) => sum + e.sets.where((s) => s.isCompleted).length);
  }

  int get totalReps {
    return exercises.fold(0, (sum, e) => sum + e.totalReps);
  }

  /// Calculate XP earned from this workout.
  int calculateXP() {
    const baseXP = 100;
    final typeMultiplier = type.baseXPMultiplier;
    final intensityMultiplier = intensity;
    final qualityMultiplier = (qualityScore / 100).clamp(0.5, 1.5);
    final durationMinutes = duration.inMinutes;

    return (baseXP * typeMultiplier * intensityMultiplier * qualityMultiplier * (durationMinutes / 30))
        .round()
        .clamp(10, 1000);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'status': status.index,
        'intensity': intensity,
        'qualityScore': qualityScore,
        'effortScore': effortScore,
        'estimatedCalories': estimatedCalories,
        'notes': notes,
      };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      type: WorkoutType.values[json['type'] as int],
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: WorkoutStatus.values[json['status'] as int],
      intensity: (json['intensity'] as num?)?.toDouble() ?? 1.0,
      qualityScore: json['qualityScore'] as int? ?? 0,
      effortScore: json['effortScore'] as int? ?? 0,
      estimatedCalories: json['estimatedCalories'] as int? ?? 0,
      notes: json['notes'] as String?,
    );
  }
}

enum WorkoutStatus {
  active,
  paused,
  completed,
  cancelled,
}

extension WorkoutStatusExtension on WorkoutStatus {
  String get label {
    switch (this) {
      case WorkoutStatus.active:
        return 'Active';
      case WorkoutStatus.paused:
        return 'Paused';
      case WorkoutStatus.completed:
        return 'Completed';
      case WorkoutStatus.cancelled:
        return 'Cancelled';
    }
  }
}
