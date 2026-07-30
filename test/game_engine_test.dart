import 'package:flutter_test/flutter_test.dart';
import 'package:rpg_system/core/domain/models/models.dart';

void main() {
  group('XP State Tests', () {
    test('XP calculation from level works correctly', () {
      // Level 1 requires 0 XP
      expect(XPState.levelFromXP(0), 1);
      // Level increases when XP exceeds threshold
      expect(XPState.levelFromXP(1000), greaterThan(1));
    });

    test('XP threshold calculation is correct', () {
      expect(XPState.xpRequiredForLevel(1), 0);
      expect(XPState.xpRequiredForLevel(2), greaterThan(0));
    });

    test('Adding XP creates correct event', () {
      const state = XPState(totalXP: 0, level: 1);
      final (newState, _) = state.addXP(100, XPSource.workoutCompletion);

      expect(newState.totalXP, 100);
      expect(newState.recentEvents.length, 1);
      expect(newState.recentEvents.first.source, XPSource.workoutCompletion);
      expect(newState.recentEvents.first.amount, 100);
    });

    test('Level up is detected correctly with high XP', () {
      const state = XPState(totalXP: 0, level: 1);
      final (_, leveledUp) = state.addXP(5000, XPSource.workoutCompletion);

      expect(leveledUp, true);
    });
  });

  group('Recovery State Tests', () {
    test('Readiness calculation from metrics', () {
      const goodMetrics = RecoveryMetrics(
        sleepHours: 8,
        sleepQuality: 90,
        hrvValue: 60,
        restingHeartRate: 55,
        fatigueLevel: 10,
        hydrationLevel: 80,
        consecutiveTrainingDays: 2,
        stressLevel: 20,
      );

      final readiness = RecoveryState.calculateReadiness(goodMetrics);
      expect(readiness, greaterThan(70));
    });

    test('Recovery level from score', () {
      expect(RecoveryLevelExtension.fromScore(15), RecoveryLevel.critical);
      expect(RecoveryLevelExtension.fromScore(30), RecoveryLevel.poor);
      expect(RecoveryLevelExtension.fromScore(50), RecoveryLevel.fair);
      expect(RecoveryLevelExtension.fromScore(70), RecoveryLevel.good);
      expect(RecoveryLevelExtension.fromScore(90), RecoveryLevel.excellent);
      expect(RecoveryLevelExtension.fromScore(98), RecoveryLevel.optimal);
    });
  });

  group('Mission Tests', () {
    test('Mission completion detection', () {
      final mission = Mission(
        id: 'test_mission',
        title: 'Test Mission',
        description: 'Test description',
        category: MissionCategory.daily,
        difficulty: MissionDifficulty.easy,
        objectives: const [
          MissionObjective(
            type: MissionObjectiveType.completeWorkout,
            target: 1,
            current: 1,
            isCompleted: true,
          ),
        ],
        startTime: DateTime.now(),
        xpReward: 100,
      );

      expect(mission.isComplete, true);
      expect(mission.progress, 1.0);
    });

    test('Mission XP reward calculation with multipliers', () {
      final mission = Mission(
        id: 'test_mission',
        title: 'Test Mission',
        description: 'Test description',
        category: MissionCategory.weekly,
        difficulty: MissionDifficulty.hard,
        objectives: const [
          MissionObjective(
            type: MissionObjectiveType.completeWorkout,
            target: 1,
            current: 1,
            isCompleted: true,
          ),
        ],
        startTime: DateTime.now(),
        xpReward: 100,
      );

      final reward = mission.calculateXPReward();
      // weekly multiplier (2.0) * hard multiplier (1.5) * base (100) = 300
      expect(reward, 300);
    });
  });

  group('Workout Session Tests', () {
    test('Workout XP calculation', () {
      final workout = WorkoutSession(
        id: 'test_workout',
        type: WorkoutType.strength,
        startTime: DateTime.now().subtract(const Duration(minutes: 45)),
        endTime: DateTime.now(),
        status: WorkoutStatus.completed,
        intensity: 1.0,
        qualityScore: 85,
        effortScore: 80,
      );

      final xp = workout.calculateXP();
      expect(xp, greaterThan(0));
    });

    test('Workout duration calculation', () {
      final startTime = DateTime.now().subtract(const Duration(hours: 1));
      final endTime = DateTime.now();

      final workout = WorkoutSession(
        id: 'test_workout',
        type: WorkoutType.cardio,
        startTime: startTime,
        endTime: endTime,
        status: WorkoutStatus.completed,
      );

      expect(workout.duration.inMinutes, 60);
    });
  });

  group('User Stats Tests', () {
    test('Adding stat increases value', () {
      const stats = UserStats();
      final newStats = stats.addStat(PrimaryStat.strength, 5.0);

      expect(newStats.strength.current, 15.0);
    });

    test('Stat percentage calculation', () {
      const stat = StatValue(current: 50, max: 100);
      expect(stat.percentage, 0.5);
    });
  });

  group('Achievement Tests', () {
    test('Achievement progress calculation', () {
      const achievement = Achievement(
        id: 'test',
        name: 'Test',
        description: 'Test achievement',
        category: AchievementCategory.workout,
        type: AchievementType.progressive,
        targetValue: 10,
        currentValue: 5,
      );

      expect(achievement.progress, 0.5);
    });

    test('Achievement unlock detection', () {
      final unlocked = Achievement(
        id: 'test',
        name: 'Test',
        description: 'Test achievement',
        category: AchievementCategory.workout,
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );

      expect(unlocked.isUnlocked, true);
    });
  });

  group('Event Factory Tests', () {
    test('Workout finished event creation', () {
      final event = EventFactory.workoutFinished('workout_123', 150, 85);

      expect(event.type, SystemEventType.workoutFinished);
      expect(event.title, 'Workout Complete');
      expect(event.data?['xpEarned'], 150);
      expect(event.data?['qualityScore'], 85);
    });

    test('Level up event creation', () {
      final event = EventFactory.levelUp(10);

      expect(event.type, SystemEventType.levelUp);
      expect(event.data?['newLevel'], 10);
    });

    test('Mission completed event creation', () {
      final event =
          EventFactory.missionCompleted('mission_123', 'Daily Challenge', 250);

      expect(event.type, SystemEventType.missionCompleted);
      expect(event.data?['xpReward'], 250);
    });
  });

  group('Rank Tier Tests', () {
    test('Rank from level calculation', () {
      expect(RankTierExtension.fromLevel(1), RankTier.e);
      expect(RankTierExtension.fromLevel(15), RankTier.d);
      expect(RankTierExtension.fromLevel(30), RankTier.c);
      expect(RankTierExtension.fromLevel(60), RankTier.b);
      expect(RankTierExtension.fromLevel(100), RankTier.s);
    });

    test('Rank XP multiplier increases with tier', () {
      expect(RankTier.e.xpMultiplier, 1.0);
      expect(RankTier.a.xpMultiplier, greaterThan(RankTier.e.xpMultiplier));
      expect(RankTier.sss.xpMultiplier, greaterThan(RankTier.s.xpMultiplier));
    });
  });
}
