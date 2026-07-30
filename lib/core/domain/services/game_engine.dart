import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'persistence_service.dart';

/// Complete game state.
class GameState {
  const GameState({
    this.xpState = const XPState(),
    this.userStats = const UserStats(),
    this.progression = const ProgressionState(),
    this.recovery = const RecoveryState(),
    this.achievements = const AchievementState(),
    this.missions = const [],
    this.activeMission,
    this.workoutHistory = const [],
    this.recentEvents = const [],
    this.isLoading = true,
    this.lastSync,
  });

  final XPState xpState;
  final UserStats userStats;
  final ProgressionState progression;
  final RecoveryState recovery;
  final AchievementState achievements;
  final List<Mission> missions;
  final Mission? activeMission;
  final List<WorkoutSession> workoutHistory;
  final List<SystemEvent> recentEvents;
  final bool isLoading;
  final DateTime? lastSync;

  GameState copyWith({
    XPState? xpState,
    UserStats? userStats,
    ProgressionState? progression,
    RecoveryState? recovery,
    AchievementState? achievements,
    List<Mission>? missions,
    Mission? activeMission,
    List<WorkoutSession>? workoutHistory,
    List<SystemEvent>? recentEvents,
    bool? isLoading,
    DateTime? lastSync,
  }) {
    return GameState(
      xpState: xpState ?? this.xpState,
      userStats: userStats ?? this.userStats,
      progression: progression ?? this.progression,
      recovery: recovery ?? this.recovery,
      achievements: achievements ?? this.achievements,
      missions: missions ?? this.missions,
      activeMission: activeMission ?? this.activeMission,
      workoutHistory: workoutHistory ?? this.workoutHistory,
      recentEvents: recentEvents ?? this.recentEvents,
      isLoading: isLoading ?? this.isLoading,
      lastSync: lastSync ?? this.lastSync,
    );
  }
}

/// Main game engine that manages all progression systems.
class GameEngine extends StateNotifier<GameState> {
  GameEngine(this._persistence) : super(const GameState()) {
    _loadState();
  }

  final PersistenceService _persistence;
  final _eventController = StreamController<SystemEvent>.broadcast();

  Stream<SystemEvent> get eventStream => _eventController.stream;

  Future<void> _loadState() async {
    await _persistence.initialize();

    final xpState = _persistence.loadXPState() ?? const XPState();
    final userStats = _persistence.loadUserStats() ?? const UserStats();
    final progression = _persistence.loadProgression() ?? const ProgressionState();
    final recovery = _persistence.loadRecoveryState() ?? const RecoveryState();
    final achievements = _persistence.loadAchievements() ?? AchievementState(
      achievements: AchievementCatalog.all,
    );
    final missions = _persistence.loadMissions();
    final activeMission = _persistence.loadActiveMission();
    final workoutHistory = _persistence.loadWorkoutHistory();
    final recentEvents = _persistence.loadEventHistory();
    final lastSync = _persistence.loadLastSync();

    state = GameState(
      xpState: xpState,
      userStats: userStats,
      progression: progression,
      recovery: recovery,
      achievements: achievements,
      missions: missions,
      activeMission: activeMission,
      workoutHistory: workoutHistory,
      recentEvents: recentEvents,
      isLoading: false,
      lastSync: lastSync,
    );

    // Generate initial mission if none exists
    if (state.missions.isEmpty) {
      _generateInitialMissions();
    }
  }

  Future<void> _saveAll() async {
    await Future.wait([
      _persistence.saveXPState(state.xpState),
      _persistence.saveUserStats(state.userStats),
      _persistence.saveProgression(state.progression),
      _persistence.saveRecoveryState(state.recovery),
      _persistence.saveAchievements(state.achievements),
      _persistence.saveMissions(state.missions),
      _persistence.saveActiveMission(state.activeMission),
      _persistence.saveWorkoutHistory(state.workoutHistory),
      _persistence.saveEventHistory(state.recentEvents),
      _persistence.saveLastSync(DateTime.now()),
    ]);
  }

  // XP Management
  Future<List<SystemEvent>> addXP(int amount, XPSource source, {
    String? missionId,
    String? workoutId,
  }) async {
    final events = <SystemEvent>[];

    // Calculate streak bonuses
    int bonusXP = 0;

    if (source == XPSource.workoutCompletion || source == XPSource.missionCompletion) {
      // Daily streak bonus
      if (state.xpState.streakDays >= 7) {
        bonusXP += (amount * 0.2).round();
      } else if (state.xpState.streakDays >= 3) {
        bonusXP += (amount * 0.1).round();
      }
    }

    final totalXP = amount + bonusXP;
    final (newXPState, leveledUp) = state.xpState.addXP(totalXP, source,
      missionId: missionId, workoutId: workoutId);

    state = state.copyWith(xpState: newXPState);

    // Log XP event
    final xpEvent = EventFactory.xpEarned(totalXP, source.label);
    _addEvent(xpEvent);
    events.add(xpEvent);

    // Check for level up
    if (leveledUp) {
      final levelUpEvent = EventFactory.levelUp(newXPState.level);
      _addEvent(levelUpEvent);
      events.add(levelUpEvent);
      _eventController.add(levelUpEvent);

      // Check achievements for level milestones
      await _checkLevelAchievements(newXPState.level);
    }

    // Check streak milestones
    await _checkStreakAchievements();

    await _saveAll();
    return events;
  }

  // Stat Management
  Future<void> addStat(PrimaryStat stat, double amount) async {
    final newStats = state.userStats.addStat(stat, amount);
    state = state.copyWith(userStats: newStats);

    // Check if stat milestone achievement should be unlocked
    final statLevel = newStats.getStat(stat).current.toInt();
    if (statLevel > 0 && statLevel % 10 == 0) {
      // Achieved a milestone
    }

    await _saveAll();
  }

  // Workout Management
  Future<List<SystemEvent>> completeWorkout(WorkoutSession workout) async {
    final events = <SystemEvent>[];

    // Update workout history
    final newHistory = [workout, ...state.workoutHistory].take(100).toList();
    state = state.copyWith(workoutHistory: newHistory);

    // Calculate XP
    final xpEarned = workout.calculateXP();
    final xpEvents = await addXP(xpEarned, XPSource.workoutCompletion, workoutId: workout.id);
    events.addAll(xpEvents);

    // Update stats based on workout type
    for (final statName in workout.type.primaryStats) {
      final stat = PrimaryStat.values.firstWhere(
        (s) => s.name == statName,
        orElse: () => PrimaryStat.strength,
      );
      await addStat(stat, 1.0);
    }

    // Complete workout event
    final workoutEvent = EventFactory.workoutFinished(
      workout.id,
      xpEarned,
      workout.qualityScore,
    );
    _addEvent(workoutEvent);
    events.add(workoutEvent);
    _eventController.add(workoutEvent);

    // Update active mission objectives
    await _updateMissionObjective(MissionObjectiveType.completeWorkout, 1);

    // Check workout achievements
    await _checkWorkoutAchievements();

    await _saveAll();
    return events;
  }

  // Mission Management
  void _generateInitialMissions() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final dailyMission = Mission(
      id: 'daily_${now.millisecondsSinceEpoch}',
      title: 'Daily Endurance Challenge',
      description: 'Complete a 30-minute cardio session to earn bonus XP.',
      category: MissionCategory.daily,
      difficulty: MissionDifficulty.medium,
      objectives: const [
        MissionObjective(
          type: MissionObjectiveType.completeWorkout,
          target: 1,
        ),
      ],
      startTime: now,
      deadline: tomorrow,
      xpReward: 250,
      statRewards: {'endurance': 5},
      status: MissionStatus.available,
      assignedWorkoutType: 'cardio',
    );

    state = state.copyWith(
      missions: [dailyMission],
      activeMission: dailyMission.copyWith(status: MissionStatus.active),
    );
    _saveAll();
  }

  Future<List<SystemEvent>> completeMission(String missionId) async {
    final events = <SystemEvent>[];
    final missionIndex = state.missions.indexWhere((m) => m.id == missionId);

    if (missionIndex == -1) return events;

    final mission = state.missions[missionIndex];
    if (mission.isComplete) {
      // Award XP
      final xpReward = mission.calculateXPReward();
      final xpEvents = await addXP(xpReward, XPSource.missionCompletion, missionId: missionId);
      events.addAll(xpEvents);

      // Update mission status
      final updatedMission = mission.copyWith(
        status: MissionStatus.completed,
        endTime: DateTime.now(),
      );

      final updatedMissions = [...state.missions];
      updatedMissions[missionIndex] = updatedMission;

      state = state.copyWith(
        missions: updatedMissions,
        activeMission: state.activeMission?.id == missionId ? null : state.activeMission,
      );

      // Mission complete event
      final missionEvent = EventFactory.missionCompleted(
        missionId,
        mission.title,
        xpReward,
      );
      _addEvent(missionEvent);
      events.add(missionEvent);
      _eventController.add(missionEvent);

      // Generate next mission
      _generateNextMission(mission.category);

      await _saveAll();
    }

    return events;
  }

  void _generateNextMission(MissionCategory completedCategory) {
    // Simple mission generation logic
    final now = DateTime.now();

    switch (completedCategory) {
      case MissionCategory.daily:
        // Generate next daily mission
        final nextDaily = Mission(
          id: 'daily_${now.millisecondsSinceEpoch}',
          title: 'Daily Strength Protocol',
          description: 'Complete a strength training session.',
          category: MissionCategory.daily,
          difficulty: MissionDifficulty.medium,
          objectives: const [
            MissionObjective(
              type: MissionObjectiveType.completeWorkout,
              target: 1,
            ),
          ],
          startTime: now,
          deadline: DateTime(now.year, now.month, now.day + 1),
          xpReward: 200,
          statRewards: {'strength': 5},
          status: MissionStatus.available,
        );
        state = state.copyWith(
          missions: [...state.missions, nextDaily],
        );
        break;
      default:
        break;
    }
  }

  Future<void> _updateMissionObjective(MissionObjectiveType type, int increment) async {
    if (state.activeMission == null) return;

    final objectives = state.activeMission!.objectives.map((obj) {
      if (obj.type == type && !obj.isCompleted) {
        final newCurrent = obj.current + increment;
        return obj.copyWith(
          current: newCurrent,
          isCompleted: newCurrent >= obj.target,
        );
      }
      return obj;
    }).toList();

    final updatedMission = state.activeMission!.copyWith(objectives: objectives);

    // Check if mission is now complete
    if (updatedMission.isComplete && state.activeMission!.status == MissionStatus.active) {
      await completeMission(updatedMission.id);
    }

    state = state.copyWith(activeMission: updatedMission);
    _saveAll();
  }

  // Recovery Management
  Future<List<SystemEvent>> updateRecovery(RecoveryMetrics metrics) async {
    final events = <SystemEvent>[];
    final readiness = RecoveryState.calculateReadiness(metrics);
    final level = RecoveryLevelExtension.fromScore(readiness);

    final newRecovery = RecoveryState(
      readinessScore: readiness,
      metrics: metrics,
      lastUpdated: DateTime.now(),
      recommendation: level.recommendation,
    );

    state = state.copyWith(recovery: newRecovery);

    // Recovery event
    final recoveryEvent = EventFactory.recoveryUpdated(readiness);
    _addEvent(recoveryEvent);
    events.add(recoveryEvent);
    _eventController.add(recoveryEvent);

    await _saveAll();
    return events;
  }

  // Achievement Management
  Future<List<SystemEvent>> _checkWorkoutAchievements() async {
    final events = <SystemEvent>[];
    final workoutCount = state.workoutHistory.length;

    final achievements = state.achievements.achievements.map((a) {
      if (a.isUnlocked) return a;

      int newCurrent = a.currentValue;
      switch (a.id) {
        case 'workout_first':
          if (workoutCount >= 1) {
            return _unlockAchievement(a, events);
          }
          break;
        case 'workout_10':
          newCurrent = workoutCount;
          if (newCurrent >= 10) {
            return _unlockAchievement(a.copyWith(currentValue: newCurrent), events);
          }
          return a.copyWith(currentValue: newCurrent);
        case 'workout_50':
          newCurrent = workoutCount;
          if (newCurrent >= 50) {
            return _unlockAchievement(a.copyWith(currentValue: newCurrent), events);
          }
          return a.copyWith(currentValue: newCurrent);
        case 'workout_100':
          newCurrent = workoutCount;
          if (newCurrent >= 100) {
            return _unlockAchievement(a.copyWith(currentValue: newCurrent), events);
          }
          return a.copyWith(currentValue: newCurrent);
      }
      return a;
    }).toList();

    state = state.copyWith(
      achievements: state.achievements.copyWith(achievements: achievements),
    );
    await _saveAll();
    return events;
  }

  Future<List<SystemEvent>> _checkLevelAchievements(int level) async {
    final events = <SystemEvent>[];

    final achievements = state.achievements.achievements.map((a) {
      if (a.isUnlocked) return a;

      switch (a.id) {
        case 'level_10':
          if (level >= 10) {
            return _unlockAchievement(a, events);
          }
          return a.copyWith(currentValue: level);
        case 'level_25':
          if (level >= 25) {
            return _unlockAchievement(a, events);
          }
          return a.copyWith(currentValue: level);
        case 'level_50':
          if (level >= 50) {
            return _unlockAchievement(a, events);
          }
          return a.copyWith(currentValue: level);
      }
      return a;
    }).toList();

    state = state.copyWith(
      achievements: state.achievements.copyWith(achievements: achievements),
    );
    await _saveAll();
    return events;
  }

  Future<List<SystemEvent>> _checkStreakAchievements() async {
    final events = <SystemEvent>[];
    final streakDays = state.xpState.streakDays;

    final achievements = state.achievements.achievements.map((a) {
      if (a.isUnlocked) return a;

      switch (a.id) {
        case 'streak_3':
          if (streakDays >= 3) {
            return _unlockAchievement(a, events);
          }
          return a.copyWith(currentValue: streakDays);
        case 'streak_7':
          if (streakDays >= 7) {
            return _unlockAchievement(a, events);
          }
          return a.copyWith(currentValue: streakDays);
        case 'streak_30':
          if (streakDays >= 30) {
            return _unlockAchievement(a, events);
          }
          return a.copyWith(currentValue: streakDays);
        case 'streak_100':
          if (streakDays >= 100) {
            return _unlockAchievement(a, events);
          }
          return a.copyWith(currentValue: streakDays);
      }
      return a;
    }).toList();

    state = state.copyWith(
      achievements: state.achievements.copyWith(achievements: achievements),
    );
    await _saveAll();
    return events;
  }

  Achievement _unlockAchievement(Achievement achievement, List<SystemEvent> events) {
    final unlocked = achievement.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );

    // Add achievement event
    final event = EventFactory.achievementUnlocked(achievement.id, achievement.name);
    _addEvent(event);
    events.add(event);
    _eventController.add(event);

    // Award XP
    addXP(achievement.xpReward, XPSource.achievementUnlock);

    return unlocked;
  }

  void _addEvent(SystemEvent event) {
    final events = [event, ...state.recentEvents].take(100).toList();
    state = state.copyWith(recentEvents: events);
  }

  // Event emission for UI
  void emitEvent(SystemEvent event) {
    _eventController.add(event);
  }

  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }
}

/// Provider for the game engine.
final gameEngineProvider = StateNotifierProvider<GameEngine, GameState>((ref) {
  final persistence = ref.watch(persistenceServiceProvider);
  return GameEngine(persistence);
});

/// Provider for just the XP state.
final xpStateProvider = Provider<XPState>((ref) {
  return ref.watch(gameEngineProvider).xpState;
});

/// Provider for just the user stats.
final userStatsProvider = Provider<UserStats>((ref) {
  return ref.watch(gameEngineProvider).userStats;
});

/// Provider for the active mission.
final activeMissionProvider = Provider<Mission?>((ref) {
  return ref.watch(gameEngineProvider).activeMission;
});

/// Provider for recovery state.
final recoveryStateProvider = Provider<RecoveryState>((ref) {
  return ref.watch(gameEngineProvider).recovery;
});

/// Provider for achievement state.
final achievementStateProvider = Provider<AchievementState>((ref) {
  return ref.watch(gameEngineProvider).achievements;
});
