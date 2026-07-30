import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/game_engine.dart';

/// AI Coach response types.
enum CoachResponseType {
  evaluation,
  recommendation,
  alert,
  status,
  motivation,
}

extension CoachResponseTypeExtension on CoachResponseType {
  String get label {
    switch (this) {
      case CoachResponseType.evaluation:
        return 'EVALUATION';
      case CoachResponseType.recommendation:
        return 'RECOMMENDATION';
      case CoachResponseType.alert:
        return 'ALERT';
      case CoachResponseType.status:
        return 'STATUS';
      case CoachResponseType.motivation:
        return 'ANALYSIS';
    }
  }
}

/// An AI Coach response.
class CoachResponse {
  const CoachResponse({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.data,
    this.priority = CoachPriority.normal,
  });

  final String id;
  final CoachResponseType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final Map<String, dynamic>? data;
  final CoachPriority priority;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'title': title,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'data': data,
        'priority': priority.index,
      };

  factory CoachResponse.fromJson(Map<String, dynamic> json) {
    return CoachResponse(
      id: json['id'] as String,
      type: CoachResponseType.values[json['type'] as int],
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: json['data'] as Map<String, dynamic>?,
      priority: CoachPriority.values[json['priority'] as int? ?? 1],
    );
  }
}

enum CoachPriority {
  low,
  normal,
  high,
  critical,
}

/// AI Coach state.
class AICoachState {
  const AICoachState({
    this.conversationHistory = const [],
    this.lastEvaluation,
    this.lastRecommendation,
    this.currentMood = 'analytical',
    this.insights = const [],
  });

  final List<CoachResponse> conversationHistory;
  final CoachResponse? lastEvaluation;
  final CoachResponse? lastRecommendation;
  final String currentMood;
  final List<CoachInsight> insights;

  AICoachState copyWith({
    List<CoachResponse>? conversationHistory,
    CoachResponse? lastEvaluation,
    CoachResponse? lastRecommendation,
    String? currentMood,
    List<CoachInsight>? insights,
  }) {
    return AICoachState(
      conversationHistory: conversationHistory ?? this.conversationHistory,
      lastEvaluation: lastEvaluation ?? this.lastEvaluation,
      lastRecommendation: lastRecommendation ?? this.lastRecommendation,
      currentMood: currentMood ?? this.currentMood,
      insights: insights ?? this.insights,
    );
  }
}

/// A coaching insight.
class CoachInsight {
  const CoachInsight({
    required this.category,
    required this.metric,
    required this.value,
    required this.change,
    required this.trend,
  });

  final String category;
  final String metric;
  final double value;
  final double change;
  final InsightTrend trend;

  String get formattedChange {
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(1)}%';
  }
}

enum InsightTrend {
  improving,
  stable,
  declining,
}

/// AI Coach that analyzes user data and provides recommendations.
class AICoach {
  AICoach(this._gameState);

  final GameState _gameState;

  /// Generate a daily evaluation.
  CoachResponse evaluateDaily() {
    final xp = _gameState.xpState;
    final recovery = _gameState.recovery;
    final workouts = _gameState.workoutHistory;
    final missions = _gameState.missions;

    // Calculate metrics
    final todayWorkouts = _getTodayWorkouts(workouts).length;
    final completedMissions = missions.where((m) => m.status == MissionStatus.completed).length;
    final totalMissions = missions.length;
    final missionRate = totalMissions > 0 ? (completedMissions / totalMissions * 100) : 0.0;
    final readiness = recovery.readinessScore;

    // Generate response
    String title;
    String message;
    CoachPriority priority = CoachPriority.normal;

    if (readiness < 40) {
      title = 'RECOVERY INSUFFICIENT';
      message = 'Readiness at ${readiness.toInt()}%. Recommend reducing workload by ${_calculateWorkloadReduction(readiness)}%.';
      priority = CoachPriority.high;
    } else if (todayWorkouts == 0) {
      title = 'DAILY MISSION AVAILABLE';
      message = 'No workout logged today. ${_getNextMissionBrief(missions)}';
      priority = CoachPriority.normal;
    } else {
      title = 'EVALUATION COMPLETE';
      message = 'Today\'s performance within expected parameters. $todayWorkouts workout(s) logged. Mission completion rate: ${missionRate.toStringAsFixed(0)}%.';
    }

    return CoachResponse(
      id: 'eval_${DateTime.now().millisecondsSinceEpoch}',
      type: CoachResponseType.evaluation,
      title: title,
      message: message,
      timestamp: DateTime.now(),
      priority: priority,
      data: {
        'readiness': readiness,
        'todayWorkouts': todayWorkouts,
        'missionRate': missionRate,
        'xpToday': xp.recentEvents.where((e) => _isToday(e.timestamp)).fold(0, (sum, e) => sum + e.effectiveXP),
      },
    );
  }

  /// Generate workout recommendation.
  CoachResponse recommendWorkout() {
    final recovery = _gameState.recovery;
    final stats = _gameState.userStats;
    final recentWorkouts = _getRecentWorkouts(_gameState.workoutHistory, 7);

    final readiness = recovery.readinessScore;
    final lowestStat = _getLowestStat(stats);
    final workoutBalance = _analyzeWorkoutBalance(recentWorkouts);

    String title;
    String message;
    String? suggestedWorkout;
    double intensity = 1.0;

    if (readiness < 30) {
      title = 'RECOVERY MODE RECOMMENDED';
      message = 'Readiness critically low. Suggesting mobility or rest activities.';
      suggestedWorkout = 'recovery';
      intensity = 0.5;
    } else if (readiness < 60) {
      title = 'MODERATE INTENSITY SUGGESTED';
      message = 'Readiness at ${readiness.toInt()}%. Recommend light to moderate training. Focus on ${lowestStat.label} development.';
      suggestedWorkout = _getWorkoutForStat(lowestStat);
      intensity = 0.7;
    } else {
      title = 'HIGH INTENSITY APPROVED';
      message = 'Readiness optimal at ${readiness.toInt()}%. Ready for challenging workout targeting ${lowestStat.label}.';
      suggestedWorkout = _getWorkoutForStat(lowestStat);
      intensity = 1.0;
    }

    return CoachResponse(
      id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
      type: CoachResponseType.recommendation,
      title: title,
      message: message,
      timestamp: DateTime.now(),
      priority: CoachPriority.normal,
      data: {
        'suggestedWorkout': suggestedWorkout,
        'intensity': intensity,
        'focusStat': lowestStat.name,
        'readiness': readiness,
        'workoutBalance': workoutBalance,
      },
    );
  }

  /// Generate weekly report.
  CoachResponse generateWeeklyReport() {
    final recentWorkouts = _getRecentWorkouts(_gameState.workoutHistory, 7);
    final xp = _gameState.xpState;
    final stats = _gameState.userStats;
    final completedMissions = _gameState.missions.where((m) => m.isComplete).length;
    final totalMissions = _gameState.missions.length;

    final workoutCount = recentWorkouts.length;
    final totalDuration = recentWorkouts.fold<int>(0, (sum, w) => sum + w.duration.inMinutes);
    final avgDuration = workoutCount > 0 ? totalDuration / workoutCount : 0;
    final xpEarned = xp.recentEvents
        .where((e) => _isWithinDays(e.timestamp, 7))
        .fold(0, (sum, e) => sum + e.effectiveXP);

    // Calculate stat changes
    final statChanges = _calculateStatTrends(stats);
    final bestStat = statChanges.entries.reduce((a, b) => a.value > b.value ? a : b);

    String title = 'WEEKLY ANALYSIS COMPLETE';
    String message = 'Training volume: $workoutCount sessions. Total duration: $totalDuration minutes. ';
    message += 'Average session: ${avgDuration.toStringAsFixed(0)} minutes. ';
    message += 'XP earned: $xpEarned. ';
    message += 'Missions completed: $completedMissions/$totalMissions. ';
    message += '${bestStat.key.label} showing strongest growth at ${bestStat.value.toStringAsFixed(1)}%.';

    return CoachResponse(
      id: 'weekly_${DateTime.now().millisecondsSinceEpoch}',
      type: CoachResponseType.evaluation,
      title: title,
      message: message,
      timestamp: DateTime.now(),
      priority: CoachPriority.normal,
      data: {
        'workoutCount': workoutCount,
        'totalDuration': totalDuration,
        'avgDuration': avgDuration,
        'xpEarned': xpEarned,
        'statChanges': statChanges.map((k, v) => MapEntry(k.name, v)),
      },
    );
  }

  /// Generate recovery advice.
  CoachResponse adviseRecovery() {
    final recovery = _gameState.recovery;
    final metrics = recovery.metrics;

    final consecutiveDays = metrics.consecutiveTrainingDays;
    final sleepHours = metrics.sleepHours;
    final hydration = metrics.hydrationLevel;
    final fatigue = metrics.fatigueLevel;

    String title;
    String message;
    CoachPriority priority = CoachPriority.normal;

    final recommendations = <String>[];

    if (sleepHours < 7) {
      recommendations.add('Sleep duration below optimal. Target 7-9 hours.');
    }
    if (hydration < 80) {
      recommendations.add('Hydration suboptimal. Increase water intake.');
    }
    if (consecutiveDays > 5) {
      recommendations.add('Training frequency elevated. Consider rest day.');
    }
    if (fatigue > 60) {
      recommendations.add('Fatigue levels high. Reduce intensity.');
    }

    if (recommendations.isEmpty) {
      title = 'RECOVERY OPTIMAL';
      message = 'All recovery metrics within expected parameters. Continue current training approach.';
    } else {
      title = 'RECOVERY ADJUSTMENTS SUGGESTED';
      message = recommendations.join(' ');
      if (consecutiveDays > 5 || fatigue > 60) {
        priority = CoachPriority.high;
      }
    }

    return CoachResponse(
      id: 'recovery_${DateTime.now().millisecondsSinceEpoch}',
      type: CoachResponseType.recommendation,
      title: title,
      message: message,
      timestamp: DateTime.now(),
      priority: priority,
      data: {
        'consecutiveDays': consecutiveDays,
        'sleepHours': sleepHours,
        'hydration': hydration,
        'fatigue': fatigue,
      },
    );
  }

  /// Generate alert for concerning patterns.
  CoachResponse? generateAlert() {
    final recovery = _gameState.recovery;
    final recentWorkouts = _getRecentWorkouts(_gameState.workoutHistory, 14);

    // Check for missed sessions
    final missedDays = _calculateMissedDays(recentWorkouts, 14);

    if (recovery.readinessScore < 20) {
      return CoachResponse(
        id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
        type: CoachResponseType.alert,
        title: 'CRITICAL: RECOVERY DEPLETED',
        message: 'Immediate rest required. Readiness critically low at ${recovery.readinessScore.toInt()}%. Avoid training until recovery improves.',
        timestamp: DateTime.now(),
        priority: CoachPriority.critical,
        data: {'readiness': recovery.readinessScore},
      );
    }

    if (missedDays > 7) {
      return CoachResponse(
        id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
        type: CoachResponseType.alert,
        title: 'CONSISTENCY ALERT',
        message: 'Training consistency below expected levels. $missedDays days without activity in past 14 days. Consider re-engaging routine.',
        timestamp: DateTime.now(),
        priority: CoachPriority.high,
        data: {'missedDays': missedDays},
      );
    }

    return null;
  }

  // Helper methods

  List<WorkoutSession> _getTodayWorkouts(List<WorkoutSession> workouts) {
    return workouts.where((w) => _isToday(w.startTime)).toList();
  }

  List<WorkoutSession> _getRecentWorkouts(List<WorkoutSession> workouts, int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return workouts.where((w) => w.startTime.isAfter(cutoff)).toList();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isWithinDays(DateTime date, int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return date.isAfter(cutoff);
  }

  int _calculateWorkloadReduction(double readiness) {
    if (readiness < 20) return 80;
    if (readiness < 30) return 60;
    if (readiness < 40) return 40;
    if (readiness < 50) return 20;
    return 0;
  }

  String _getNextMissionBrief(List<Mission> missions) {
    final active = missions.where((m) => m.status == MissionStatus.active || m.status == MissionStatus.available);
    if (active.isEmpty) return 'No active missions.';
    final mission = active.first;
    return 'Current objective: ${mission.title}.';
  }

  PrimaryStat _getLowestStat(UserStats stats) {
    final statValues = {
      PrimaryStat.strength: stats.strength.current,
      PrimaryStat.endurance: stats.endurance.current,
      PrimaryStat.mobility: stats.mobility.current,
      PrimaryStat.recovery: stats.recovery.current,
      PrimaryStat.precision: stats.precision.current,
      PrimaryStat.focus: stats.focus.current,
    };
    return statValues.entries.reduce((a, b) => a.value < b.value ? a : b).key;
  }

  String _getWorkoutForStat(PrimaryStat stat) {
    switch (stat) {
      case PrimaryStat.strength:
        return WorkoutType.strength.name;
      case PrimaryStat.endurance:
        return WorkoutType.cardio.name;
      case PrimaryStat.mobility:
        return WorkoutType.mobility.name;
      case PrimaryStat.recovery:
        return WorkoutType.recovery.name;
      case PrimaryStat.precision:
        return WorkoutType.hiit.name;
      case PrimaryStat.focus:
        return WorkoutType.yoga.name;
    }
  }

  Map<PrimaryStat, double> _analyzeWorkoutBalance(List<WorkoutSession> workouts) {
    final counts = <WorkoutType, int>{};
    for (final w in workouts) {
      counts[w.type] = (counts[w.type] ?? 0) + 1;
    }
    // Return balance analysis
    return {
      PrimaryStat.strength: (counts[WorkoutType.strength] ?? 0).toDouble(),
      PrimaryStat.endurance: (counts[WorkoutType.cardio] ?? 0).toDouble(),
      PrimaryStat.mobility: (counts[WorkoutType.mobility] ?? 0).toDouble(),
      PrimaryStat.recovery: (counts[WorkoutType.recovery] ?? 0).toDouble(),
      PrimaryStat.precision: (counts[WorkoutType.hiit] ?? 0).toDouble(),
      PrimaryStat.focus: (counts[WorkoutType.yoga] ?? 0).toDouble(),
    };
  }

  Map<PrimaryStat, double> _calculateStatTrends(UserStats stats) {
    // Simulate stat trend calculation
    return {
      PrimaryStat.strength: 2.5,
      PrimaryStat.endurance: 3.1,
      PrimaryStat.mobility: 1.8,
      PrimaryStat.recovery: 2.2,
      PrimaryStat.precision: 1.5,
      PrimaryStat.focus: 2.0,
    };
  }

  int _calculateMissedDays(List<WorkoutSession> workouts, int periodDays) {
    final workoutDays = <DateTime>{};
    for (final w in workouts) {
      workoutDays.add(DateTime(w.startTime.year, w.startTime.month, w.startTime.day));
    }

    int missed = 0;
    final now = DateTime.now();
    for (int i = 0; i < periodDays; i++) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      if (!workoutDays.contains(day) && i > 0) {
        missed++;
      }
    }
    return missed;
  }
}

/// AI Coach provider notifier.
class AICoachNotifier extends StateNotifier<AICoachState> {
  AICoachNotifier(this._gameState) : super(const AICoachState());

  final GameState _gameState;

  AICoach get _coach => AICoach(_gameState);

  CoachResponse evaluateDaily() {
    final response = _coach.evaluateDaily();
    state = state.copyWith(
      lastEvaluation: response,
      conversationHistory: [response, ...state.conversationHistory].take(50).toList(),
    );
    return response;
  }

  CoachResponse recommendWorkout() {
    final response = _coach.recommendWorkout();
    state = state.copyWith(
      lastRecommendation: response,
      conversationHistory: [response, ...state.conversationHistory].take(50).toList(),
    );
    return response;
  }

  CoachResponse generateWeeklyReport() {
    final response = _coach.generateWeeklyReport();
    state = state.copyWith(
      conversationHistory: [response, ...state.conversationHistory].take(50).toList(),
    );
    return response;
  }

  CoachResponse adviseRecovery() {
    final response = _coach.adviseRecovery();
    state = state.copyWith(
      conversationHistory: [response, ...state.conversationHistory].take(50).toList(),
    );
    return response;
  }

  CoachResponse? checkForAlerts() {
    final alert = _coach.generateAlert();
    if (alert != null) {
      state = state.copyWith(
        conversationHistory: [alert, ...state.conversationHistory].take(50).toList(),
      );
    }
    return alert;
  }
}

/// Provider for AI Coach.
final aiCoachProvider = StateNotifierProvider<AICoachNotifier, AICoachState>((ref) {
  final gameState = ref.watch(gameEngineProvider);
  return AICoachNotifier(gameState);
});
