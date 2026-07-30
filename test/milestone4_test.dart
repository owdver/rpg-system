import 'package:flutter_test/flutter_test.dart';
import 'package:rpg_system/core/domain/models/models.dart';
import 'package:rpg_system/core/domain/services/services.dart';

void main() {
  group('AI Coach Tests', () {
    test('Coach generates daily evaluation', () {
      final gameState = GameState(
        xpState: const XPState(totalXP: 500),
        recovery: const RecoveryState(readinessScore: 75),
        workoutHistory: [],
        missions: [
          Mission(
            id: 'test_mission',
            title: 'Test Mission',
            description: 'Test',
            category: MissionCategory.daily,
            difficulty: MissionDifficulty.easy,
            objectives: const [
              MissionObjective(
                type: MissionObjectiveType.completeWorkout,
                target: 1,
              ),
            ],
            startTime: DateTime.now(),
            xpReward: 100,
            status: MissionStatus.available,
          ),
        ],
      );

      final coach = AICoach(gameState);
      final response = coach.evaluateDaily();

      expect(response.type, CoachResponseType.evaluation);
      expect(response.title.isNotEmpty, true);
      expect(response.message.isNotEmpty, true);
    });

    test('Coach generates workout recommendation', () {
      final gameState = GameState(
        xpState: const XPState(totalXP: 500),
        recovery: const RecoveryState(readinessScore: 75),
        userStats: const UserStats(
          strength: StatValue(current: 50),
          endurance: StatValue(current: 30),
          mobility: StatValue(current: 40),
        ),
        workoutHistory: [],
      );

      final coach = AICoach(gameState);
      final response = coach.recommendWorkout();

      expect(response.type, CoachResponseType.recommendation);
      expect(response.data?['suggestedWorkout'], isNotNull);
    });

    test('Coach detects critical recovery', () {
      final gameState = GameState(
        recovery: const RecoveryState(readinessScore: 15),
      );

      final coach = AICoach(gameState);
      final response = coach.evaluateDaily();

      // Recovery at 15% should trigger high priority
      expect(response.priority.index, greaterThanOrEqualTo(CoachPriority.normal.index));
    });

    test('Coach generates weekly report', () {
      final gameState = GameState(
        xpState: const XPState(totalXP: 1000),
        workoutHistory: [
          WorkoutSession(
            id: 'w1',
            type: WorkoutType.strength,
            startTime: DateTime.now().subtract(const Duration(days: 1)),
            endTime: DateTime.now().subtract(const Duration(days: 1)).add(const Duration(minutes: 45)),
            status: WorkoutStatus.completed,
          ),
          WorkoutSession(
            id: 'w2',
            type: WorkoutType.cardio,
            startTime: DateTime.now().subtract(const Duration(days: 2)),
            endTime: DateTime.now().subtract(const Duration(days: 2)).add(const Duration(minutes: 30)),
            status: WorkoutStatus.completed,
          ),
        ],
      );

      final coach = AICoach(gameState);
      final response = coach.generateWeeklyReport();

      expect(response.type, CoachResponseType.evaluation);
      expect(response.data?['workoutCount'], 2);
    });
  });

  group('Skill Tree Tests', () {
    test('Skill tree initializes correctly', () {
      final state = SkillTreeState.initial();

      expect(state.skills.isNotEmpty, true);
      expect(state.totalSpent, 0);
    });

    test('Skill nodes have correct tier structure', () {
      final state = SkillTreeState.initial();

      final foundation = state.getSkillsByCategory(SkillCategory.foundation);
      expect(foundation.length, greaterThan(0));

      final firstSkill = foundation.first;
      expect(firstSkill.isUnlocked, true);
      expect(firstSkill.isPurchased, true);
    });

    test('Skill tree calculates XP bonus correctly', () {
      final state = SkillTreeState.initial();

      // Only purchased skills contribute
      final xpBonus = state.totalXpBonus;
      expect(xpBonus, greaterThan(0));
    });

    test('Skill node JSON serialization', () {
      const skill = SkillNode(
        id: 'test_skill',
        name: 'Test Skill',
        description: 'A test skill',
        category: SkillCategory.strength,
        tier: 1,
        cost: 100,
        xpBonus: 0.1,
        requiredLevel: 5,
      );

      final json = skill.toJson();
      final restored = SkillNode.fromJson(json);

      expect(restored.id, skill.id);
      expect(restored.name, skill.name);
      expect(restored.xpBonus, skill.xpBonus);
    });
  });

  group('Inventory Tests', () {
    test('Inventory initializes with items', () {
      final state = InventoryState.initial();

      expect(state.items.isNotEmpty, true);
      expect(state.totalItems, greaterThan(0));
    });

    test('Items have correct rarity', () {
      final state = InventoryState.initial();

      final commonItems = state.items.where((i) => i.rarity == ItemRarity.common);
      final rareItems = state.items.where((i) => i.rarity == ItemRarity.rare);
      final epicItems = state.items.where((i) => i.rarity == ItemRarity.epic);
      final legendaryItems = state.items.where((i) => i.rarity == ItemRarity.legendary);

      expect(commonItems.isNotEmpty, true);
      expect(rareItems.isNotEmpty, true);
      expect(epicItems.isNotEmpty, true);
      expect(legendaryItems.isNotEmpty, true);
    });

    test('Items can be filtered by type', () {
      final state = InventoryState.initial();

      final titles = state.getItemsByType(InventoryItemType.title);
      final badges = state.getItemsByType(InventoryItemType.badge);
      final backgrounds = state.getItemsByType(InventoryItemType.background);

      expect(titles.isNotEmpty, true);
      expect(badges.isNotEmpty, true);
      expect(backgrounds.isNotEmpty, true);
    });

    test('Inventory item JSON serialization', () {
      const item = InventoryItem(
        id: 'test_item',
        name: 'Test Item',
        description: 'A test item',
        type: InventoryItemType.badge,
        rarity: ItemRarity.epic,
        isUnlocked: true,
      );

      final json = item.toJson();
      final restored = InventoryItem.fromJson(json);

      expect(restored.id, item.id);
      expect(restored.name, item.name);
      expect(restored.rarity, item.rarity);
      expect(restored.isUnlocked, item.isUnlocked);
    });

    test('Rarity color values are correct', () {
      expect(ItemRarity.common.colorValue, isA<int>());
      expect(ItemRarity.rare.colorValue, isA<int>());
      expect(ItemRarity.epic.colorValue, isA<int>());
      expect(ItemRarity.legendary.colorValue, isA<int>());
      expect(ItemRarity.mythic.colorValue, isA<int>());
    });
  });

  group('Boss Challenge Tests', () {
    test('Boss catalog has all difficulty tiers', () {
      final bosses = BossCatalog.allBosses;

      expect(bosses.any((b) => b.tier == BossTier.bronze), true);
      expect(bosses.any((b) => b.tier == BossTier.silver), true);
      expect(bosses.any((b) => b.tier == BossTier.gold), true);
      expect(bosses.any((b) => b.tier == BossTier.platinum), true);
      expect(bosses.any((b) => b.tier == BossTier.mythic), true);
    });

    test('Boss phases calculate progress correctly', () {
      const phase = BossPhase(
        id: 'test_phase',
        name: 'Test Phase',
        description: 'Complete 10 reps',
        target: 10,
        current: 5,
      );

      expect(phase.progress, 0.5);
    });

    test('Boss tier multiplier is applied correctly', () {
      final boss = BossCatalog.pushup100;

      // Bronze tier has 1x multiplier
      expect(boss.tier.xpMultiplier, 1);
      // Base XP is 350
      expect(boss.xpReward, 350);
    });

    test('Boss XP reward is zero when incomplete', () {
      final boss = BossCatalog.pushup100;
      // Not all phases complete, so XP should be 0
      expect(boss.totalXpReward, 0);
    });

    test('Boss challenge serialization', () {
      final boss = BossCatalog.pushup100;
      final json = boss.toJson();
      final restored = BossChallenge.fromJson(json);

      expect(restored.id, boss.id);
      expect(restored.name, boss.name);
      expect(restored.tier, boss.tier);
      expect(restored.phases.length, boss.phases.length);
    });

    test('Boss state initializes with all bosses', () {
      final state = BossState.initial();

      expect(state.bosses.isNotEmpty, true);
      expect(state.bosses.length, BossCatalog.allBosses.length);
    });

    test('Boss tier XP multipliers are correct', () {
      expect(BossTier.bronze.xpMultiplier, 1);
      expect(BossTier.silver.xpMultiplier, 2);
      expect(BossTier.gold.xpMultiplier, 3);
      expect(BossTier.platinum.xpMultiplier, 5);
      expect(BossTier.diamond.xpMultiplier, 8);
      expect(BossTier.mythic.xpMultiplier, 15);
    });
  });

  group('Health Integration Tests', () {
    test('Health data point creation', () {
      final point = HealthDataPoint(
        type: HealthDataType.steps,
        value: 8500,
        timestamp: DateTime.now(),
      );

      expect(point.value, 8500);
      expect(point.type, HealthDataType.steps);
    });

    test('Health data type labels are correct', () {
      expect(HealthDataType.steps.label, 'Steps');
      expect(HealthDataType.heartRate.label, 'Heart Rate');
      expect(HealthDataType.hrv.label, 'Heart Rate Variability');
      expect(HealthDataType.sleep.label, 'Sleep');
    });

    test('Sync status labels are correct', () {
      expect(SyncStatus.idle.label, 'Idle');
      expect(SyncStatus.syncing.label, 'Syncing...');
      expect(SyncStatus.success.label, 'Synced');
      expect(SyncStatus.error.label, 'Error');
      expect(SyncStatus.offline.label, 'Offline');
    });

    test('Health data point JSON serialization', () {
      final point = HealthDataPoint(
        type: HealthDataType.calories,
        value: 2150.5,
        timestamp: DateTime(2024, 1, 1, 12, 0),
      );

      final json = point.toJson();
      final restored = HealthDataPoint.fromJson(json);

      expect(restored.value, point.value);
      expect(restored.type, point.type);
    });
  });

  group('Coach Response Tests', () {
    test('Coach response types have labels', () {
      expect(CoachResponseType.evaluation.label, 'EVALUATION');
      expect(CoachResponseType.recommendation.label, 'RECOMMENDATION');
      expect(CoachResponseType.alert.label, 'ALERT');
    });

    test('Coach priority ordering', () {
      expect(CoachPriority.low.index, lessThan(CoachPriority.normal.index));
      expect(CoachPriority.normal.index, lessThan(CoachPriority.high.index));
      expect(CoachPriority.high.index, lessThan(CoachPriority.critical.index));
    });

    test('Coach response JSON serialization', () {
      final response = CoachResponse(
        id: 'test_response',
        type: CoachResponseType.evaluation,
        title: 'Test Title',
        message: 'Test message content',
        timestamp: DateTime.now(),
        priority: CoachPriority.high,
        data: {'test': 123},
      );

      final json = response.toJson();
      final restored = CoachResponse.fromJson(json);

      expect(restored.id, response.id);
      expect(restored.title, response.title);
      expect(restored.priority, response.priority);
    });
  });
}
