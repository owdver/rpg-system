/// Boss challenge difficulty tiers.
enum BossTier {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
  mythic,
}

extension BossTierExtension on BossTier {
  String get label {
    switch (this) {
      case BossTier.bronze:
        return 'Bronze';
      case BossTier.silver:
        return 'Silver';
      case BossTier.gold:
        return 'Gold';
      case BossTier.platinum:
        return 'Platinum';
      case BossTier.diamond:
        return 'Diamond';
      case BossTier.mythic:
        return 'Mythic';
    }
  }

  int get colorValue {
    switch (this) {
      case BossTier.bronze:
        return 0xFFCD7F32;
      case BossTier.silver:
        return 0xFFC0C0C0;
      case BossTier.gold:
        return 0xFFFFD700;
      case BossTier.platinum:
        return 0xFFE5E4E2;
      case BossTier.diamond:
        return 0xFFB9F2FF;
      case BossTier.mythic:
        return 0xFFFF00FF;
    }
  }

  int get xpMultiplier {
    switch (this) {
      case BossTier.bronze:
        return 1;
      case BossTier.silver:
        return 2;
      case BossTier.gold:
        return 3;
      case BossTier.platinum:
        return 5;
      case BossTier.diamond:
        return 8;
      case BossTier.mythic:
        return 15;
    }
  }
}

/// Boss challenge phase.
class BossPhase {
  const BossPhase({
    required this.id,
    required this.name,
    required this.description,
    required this.target,
    this.current = 0,
    this.isComplete = false,
    this.rewards = const {},
  });

  final String id;
  final String name;
  final String description;
  final int target;
  final int current;
  final bool isComplete;
  final Map<String, dynamic> rewards;

  double get progress => target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

  BossPhase copyWith({
    String? id,
    String? name,
    String? description,
    int? target,
    int? current,
    bool? isComplete,
    Map<String, dynamic>? rewards,
  }) {
    return BossPhase(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      target: target ?? this.target,
      current: current ?? this.current,
      isComplete: isComplete ?? this.isComplete,
      rewards: rewards ?? this.rewards,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'target': target,
        'current': current,
        'isComplete': isComplete,
        'rewards': rewards,
      };

  factory BossPhase.fromJson(Map<String, dynamic> json) {
    return BossPhase(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      target: json['target'] as int,
      current: json['current'] as int? ?? 0,
      isComplete: json['isComplete'] as bool? ?? false,
      rewards: json['rewards'] as Map<String, dynamic>? ?? {},
    );
  }
}

/// A boss challenge.
class BossChallenge {
  const BossChallenge({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tier,
    required this.phases,
    required this.startTime,
    this.deadline,
    this.xpReward = 500,
    this.statRewards = const {},
    this.status = BossStatus.available,
    this.currentPhaseIndex = 0,
    this.completedAt,
    this.icon,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final BossTier tier;
  final List<BossPhase> phases;
  final DateTime startTime;
  final DateTime? deadline;
  final int xpReward;
  final Map<String, double> statRewards;
  final BossStatus status;
  final int currentPhaseIndex;
  final DateTime? completedAt;
  final String? icon;

  BossPhase get currentPhase => phases[currentPhaseIndex];
  
  bool get isComplete => phases.every((p) => p.isComplete);
  
  double get overallProgress {
    if (phases.isEmpty) return 0;
    return phases.fold(0.0, (sum, p) => sum + p.progress) / phases.length;
  }

  int get totalXpReward {
    if (!isComplete) return 0;
    return (xpReward * tier.xpMultiplier).round();
  }

  Duration? get timeRemaining {
    if (deadline == null) return null;
    return deadline!.difference(DateTime.now());
  }

  bool get isExpired {
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline!);
  }

  BossChallenge copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    BossTier? tier,
    List<BossPhase>? phases,
    DateTime? startTime,
    DateTime? deadline,
    int? xpReward,
    Map<String, double>? statRewards,
    BossStatus? status,
    int? currentPhaseIndex,
    DateTime? completedAt,
    String? icon,
  }) {
    return BossChallenge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      tier: tier ?? this.tier,
      phases: phases ?? this.phases,
      startTime: startTime ?? this.startTime,
      deadline: deadline ?? this.deadline,
      xpReward: xpReward ?? this.xpReward,
      statRewards: statRewards ?? this.statRewards,
      status: status ?? this.status,
      currentPhaseIndex: currentPhaseIndex ?? this.currentPhaseIndex,
      completedAt: completedAt ?? this.completedAt,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'tier': tier.index,
        'phases': phases.map((p) => p.toJson()).toList(),
        'startTime': startTime.toIso8601String(),
        'deadline': deadline?.toIso8601String(),
        'xpReward': xpReward,
        'statRewards': statRewards,
        'status': status.index,
        'currentPhaseIndex': currentPhaseIndex,
        'completedAt': completedAt?.toIso8601String(),
        'icon': icon,
      };

  factory BossChallenge.fromJson(Map<String, dynamic> json) {
    return BossChallenge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      tier: BossTier.values[json['tier'] as int],
      phases: (json['phases'] as List<dynamic>)
          .map((p) => BossPhase.fromJson(p as Map<String, dynamic>))
          .toList(),
      startTime: DateTime.parse(json['startTime'] as String),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      xpReward: json['xpReward'] as int? ?? 500,
      statRewards: (json['statRewards'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
          {},
      status: BossStatus.values[json['status'] as int? ?? 0],
      currentPhaseIndex: json['currentPhaseIndex'] as int? ?? 0,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      icon: json['icon'] as String?,
    );
  }
}

enum BossStatus {
  locked,
  available,
  active,
  defeated,
  failed,
  expired,
}

extension BossStatusExtension on BossStatus {
  String get label {
    switch (this) {
      case BossStatus.locked:
        return 'Locked';
      case BossStatus.available:
        return 'Available';
      case BossStatus.active:
        return 'Active';
      case BossStatus.defeated:
        return 'Defeated';
      case BossStatus.failed:
        return 'Failed';
      case BossStatus.expired:
        return 'Expired';
    }
  }
}

/// Predefined boss challenges.
class BossCatalog {
  static List<BossChallenge> get allBosses => [
        pushup100,
        pullup10,
        run5k,
        plank3min,
        squat100,
        consistency30,
        strength100,
        enduranceChallenge,
        hybridChallenge,
        ultimateChallenge,
      ];

  static final pushup100 = BossChallenge(
    id: 'boss_pushup_100',
    name: 'Push-up Gauntlet',
    description: 'Complete 100 push-ups across multiple sessions.',
    category: 'strength',
    tier: BossTier.bronze,
    phases: const [
      BossPhase(
        id: 'p1',
        name: 'Phase 1',
        description: 'Complete 25 push-ups',
        target: 25,
        rewards: {'xp': 50},
      ),
      BossPhase(
        id: 'p2',
        name: 'Phase 2',
        description: 'Complete 50 push-ups',
        target: 50,
        rewards: {'xp': 100},
      ),
      BossPhase(
        id: 'p3',
        name: 'Phase 3',
        description: 'Complete 100 push-ups',
        target: 100,
        rewards: {'xp': 200, 'stat': {'strength': 2}},
      ),
    ],
    startTime: DateTime.now(),
    deadline: DateTime.now().add(const Duration(days: 7)),
    xpReward: 350,
    statRewards: {'strength': 5},
    icon: '💪',
  );

  static final pullup10 = BossChallenge(
    id: 'boss_pullup_10',
    name: 'Pull-up Master',
    description: 'Master the pull-up with 10 consecutive reps.',
    category: 'strength',
    tier: BossTier.silver,
    phases: const [
      BossPhase(
        id: 'p1',
        name: 'Phase 1',
        description: 'Complete 3 pull-ups',
        target: 3,
        rewards: {'xp': 75},
      ),
      BossPhase(
        id: 'p2',
        name: 'Phase 2',
        description: 'Complete 7 pull-ups',
        target: 7,
        rewards: {'xp': 150},
      ),
      BossPhase(
        id: 'p3',
        name: 'Phase 3',
        description: 'Complete 10 pull-ups',
        target: 10,
        rewards: {'xp': 300, 'stat': {'strength': 3}},
      ),
    ],
    startTime: DateTime.now(),
    deadline: DateTime.now().add(const Duration(days: 14)),
    xpReward: 525,
    statRewards: {'strength': 8},
    icon: '🏋️',
  );

  static final run5k = BossChallenge(
    id: 'boss_run_5k',
    name: '5K Endurance Trial',
    description: 'Complete a 5km run within the time limit.',
    category: 'endurance',
    tier: BossTier.gold,
    phases: const [
      BossPhase(
        id: 'p1',
        name: 'Phase 1',
        description: 'Run 1km',
        target: 1,
        rewards: {'xp': 100},
      ),
      BossPhase(
        id: 'p2',
        name: 'Phase 2',
        description: 'Run 3km',
        target: 3,
        rewards: {'xp': 200},
      ),
      BossPhase(
        id: 'p3',
        name: 'Phase 3',
        description: 'Run 5km',
        target: 5,
        rewards: {'xp': 400, 'stat': {'endurance': 5}},
      ),
    ],
    startTime: DateTime.now(),
    deadline: DateTime.now().add(const Duration(days: 14)),
    xpReward: 700,
    statRewards: {'endurance': 10},
    icon: '🏃',
  );

  static final plank3min = BossChallenge(
    id: 'boss_plank_3min',
    name: 'Plank Master',
    description: 'Hold a plank for 3 minutes total.',
    category: 'strength',
    tier: BossTier.silver,
    phases: const [
      BossPhase(
        id: 'p1',
        name: 'Phase 1',
        description: 'Hold plank for 1 minute',
        target: 60,
        rewards: {'xp': 75},
      ),
      BossPhase(
        id: 'p2',
        name: 'Phase 2',
        description: 'Hold plank for 2 minutes',
        target: 120,
        rewards: {'xp': 150},
      ),
      BossPhase(
        id: 'p3',
        name: 'Phase 3',
        description: 'Hold plank for 3 minutes',
        target: 180,
        rewards: {'xp': 300, 'stat': {'strength': 3, 'focus': 2}},
      ),
    ],
    startTime: DateTime.now(),
    deadline: DateTime.now().add(const Duration(days: 10)),
    xpReward: 525,
    statRewards: {'strength': 5, 'focus': 3},
    icon: '⏱️',
  );

  static final squat100 = BossChallenge(
    id: 'boss_squat_100',
    name: 'Squat Challenge',
    description: 'Complete 100 bodyweight squats.',
    category: 'strength',
    tier: BossTier.bronze,
    phases: const [
      BossPhase(
        id: 'p1',
        name: 'Phase 1',
        description: 'Complete 30 squats',
        target: 30,
        rewards: {'xp': 50},
      ),
      BossPhase(
        id: 'p2',
        name: 'Phase 2',
        description: 'Complete 60 squats',
        target: 60,
        rewards: {'xp': 100},
      ),
      BossPhase(
        id: 'p3',
        name: 'Phase 3',
        description: 'Complete 100 squats',
        target: 100,
        rewards: {'xp': 200, 'stat': {'strength': 2}},
      ),
    ],
    startTime: DateTime.now(),
    deadline: DateTime.now().add(const Duration(days: 7)),
    xpReward: 350,
    statRewards: {'strength': 5},
    icon: '🦵',
  );

  static final consistency30 = BossChallenge(
    id: 'boss_consistency_30',
    name: 'Consistency Champion',
    description: 'Complete a workout every day for 30 days.',
    category: 'endurance',
    tier: BossTier.platinum,
    phases: const [
      BossPhase(
        id: 'p1',
        name: 'Week 1',
        description: 'Complete 7 days',
        target: 7,
        rewards: {'xp': 200},
      ),
      BossPhase(
        id: 'p2',
        name: 'Week 2',
        description: 'Complete 14 days',
        target: 14,
        rewards: {'xp': 400},
      ),
      BossPhase(
        id: 'p3',
        name: 'Week 3',
        description: 'Complete 21 days',
        target: 21,
        rewards: {'xp': 600},
      ),
      BossPhase(
        id: 'p4',
        name: 'Final Phase',
        description: 'Complete 30 days',
        target: 30,
        rewards: {'xp': 1000, 'stat': {'recovery': 5, 'endurance': 5}},
      ),
    ],
    startTime: DateTime.now(),
    deadline: DateTime.now().add(const Duration(days: 45)),
    xpReward: 2200,
    statRewards: {'recovery': 10, 'endurance': 10},
    icon: '🔥',
  );

  static final strength100 = BossChallenge(
    id: 'boss_strength_100',
    name: 'Strength 100',
    description: 'Complete 100 strength workouts.',
    category: 'strength',
    tier: BossTier.gold,
    phases: const [
      BossPhase(
        id: 'p1',
        name: 'Phase 1',
        description: 'Complete 25 workouts',
        target: 25,
        rewards: {'xp': 200},
      ),
      BossPhase(
        id: 'p2',
        name: 'Phase 2',
        description: 'Complete 50 workouts',
        target: 50,
        rewards: {'xp': 400},
      ),
      BossPhase(
        id: 'p3',
        name: 'Phase 3',
        description: 'Complete 100 workouts',
        target: 100,
        rewards: {'xp': 800, 'stat': {'strength': 10}},
      ),
    ],
    startTime: DateTime.now(),
    deadline: DateTime.now().add(const Duration(days: 60)),
    xpReward: 1400,
    statRewards: {'strength': 15},
    icon: '🏆',
  );

  static final enduranceChallenge = BossChallenge(
    id: 'boss_endurance',
    name: 'Endurance Trial',
    description: 'Complete various endurance challenges.',
    category: 'endurance',
    tier: BossTier.gold,
    phases: const [
      BossPhase(
        id: 'p1',
        name: 'Cardio',
        description: '5 cardio sessions',
        target: 5,
        rewards: {'xp': 150},
      ),
      BossPhase(
        id: 'p2',
        name: 'HIIT',
        description: '5 HIIT sessions',
        target: 5,
        rewards: {'xp': 200},
      ),
      BossPhase(
        id: 'p3',
        name: 'Long Run',
        description: 'Complete 10km run',
        target: 10,
        rewards: {'xp': 400, 'stat': {'endurance': 8}},
      ),
    ],
    startTime: DateTime.now(),
    deadline: DateTime.now().add(const Duration(days: 30)),
    xpReward: 750,
    statRewards: {'endurance': 12},
    icon: '❤️',
  );

  static final hybridChallenge = BossChallenge(
    id: 'boss_hybrid',
    name: 'Hybrid Warrior',
    description: 'Balance strength and endurance training.',
    category: 'hybrid',
    tier: BossTier.platinum,
    phases: const [
      BossPhase(
        id: 'p1',
        name: 'Strength',
        description: '20 strength workouts',
        target: 20,
        rewards: {'xp': 300},
      ),
      BossPhase(
        id: 'p2',
        name: 'Endurance',
        description: '20 endurance workouts',
        target: 20,
        rewards: {'xp': 300},
      ),
      BossPhase(
        id: 'p3',
        name: 'Balance',
        description: 'Complete both in 30 days',
        target: 30,
        rewards: {'xp': 600, 'stat': {'strength': 5, 'endurance': 5}},
      ),
    ],
    startTime: DateTime.now(),
    deadline: DateTime.now().add(const Duration(days: 45)),
    xpReward: 1200,
    statRewards: {'strength': 8, 'endurance': 8},
    icon: '⚡',
  );

  static final ultimateChallenge = BossChallenge(
    id: 'boss_ultimate',
    name: 'Ultimate Test',
    description: 'The ultimate test of all capabilities.',
    category: 'ultimate',
    tier: BossTier.mythic,
    phases: const [
      BossPhase(
        id: 'p1',
        name: 'Foundation',
        description: 'Level 25+',
        target: 25,
        rewards: {'xp': 500},
      ),
      BossPhase(
        id: 'p2',
        name: 'Strength',
        description: 'Strength stat 50+',
        target: 50,
        rewards: {'xp': 750},
      ),
      BossPhase(
        id: 'p3',
        name: 'Endurance',
        description: 'Endurance stat 50+',
        target: 50,
        rewards: {'xp': 750},
      ),
      BossPhase(
        id: 'p4',
        name: 'Mastery',
        description: 'All stats 40+',
        target: 40,
        rewards: {'xp': 1000, 'stat': {'strength': 5, 'endurance': 5, 'recovery': 5}},
      ),
    ],
    startTime: DateTime.now(),
    deadline: DateTime.now().add(const Duration(days: 90)),
    xpReward: 3000,
    statRewards: {'strength': 15, 'endurance': 15, 'recovery': 10},
    icon: '👑',
  );
}

/// Boss challenge state.
class BossState {
  const BossState({
    this.bosses = const [],
    this.activeBoss,
    this.completedBosses = const [],
    this.defeatedCount = 0,
  });

  final List<BossChallenge> bosses;
  final BossChallenge? activeBoss;
  final List<String> completedBosses;
  final int defeatedCount;

  factory BossState.initial() {
    return BossState(
      bosses: BossCatalog.allBosses,
    );
  }

  BossChallenge? getBoss(String id) {
    return bosses.where((b) => b.id == id).firstOrNull;
  }

  List<BossChallenge> getAvailableBosses() {
    return bosses.where((b) => b.status == BossStatus.available).toList();
  }

  List<BossChallenge> getCompletedBosses() {
    return bosses.where((b) => b.status == BossStatus.defeated).toList();
  }

  BossState copyWith({
    List<BossChallenge>? bosses,
    BossChallenge? activeBoss,
    List<String>? completedBosses,
    int? defeatedCount,
  }) {
    return BossState(
      bosses: bosses ?? this.bosses,
      activeBoss: activeBoss ?? this.activeBoss,
      completedBosses: completedBosses ?? this.completedBosses,
      defeatedCount: defeatedCount ?? this.defeatedCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'bosses': bosses.map((b) => b.toJson()).toList(),
        'activeBoss': activeBoss?.toJson(),
        'completedBosses': completedBosses,
        'defeatedCount': defeatedCount,
      };

  factory BossState.fromJson(Map<String, dynamic> json) {
    final bossesList = (json['bosses'] as List<dynamic>?)
        ?.map((b) => BossChallenge.fromJson(b as Map<String, dynamic>))
        .toList();

    return BossState(
      bosses: bossesList ?? BossCatalog.allBosses,
      activeBoss: json['activeBoss'] != null
          ? BossChallenge.fromJson(json['activeBoss'] as Map<String, dynamic>)
          : null,
      completedBosses: (json['completedBosses'] as List<dynamic>?)?.cast<String>() ?? [],
      defeatedCount: json['defeatedCount'] as int? ?? 0,
    );
  }
}
