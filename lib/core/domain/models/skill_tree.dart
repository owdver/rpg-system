/// Skill tree categories.
enum SkillCategory {
  foundation,
  strength,
  endurance,
  recovery,
  precision,
  adaptation,
}

extension SkillCategoryExtension on SkillCategory {
  String get label {
    switch (this) {
      case SkillCategory.foundation:
        return 'Foundation';
      case SkillCategory.strength:
        return 'Strength';
      case SkillCategory.endurance:
        return 'Endurance';
      case SkillCategory.recovery:
        return 'Recovery';
      case SkillCategory.precision:
        return 'Precision';
      case SkillCategory.adaptation:
        return 'Adaptation';
    }
  }

  String get description {
    switch (this) {
      case SkillCategory.foundation:
        return 'Core abilities and basic techniques';
      case SkillCategory.strength:
        return 'Power and force development';
      case SkillCategory.endurance:
        return 'Stamina and sustained effort';
      case SkillCategory.recovery:
        return 'Rest and regeneration';
      case SkillCategory.precision:
        return 'Control and accuracy';
      case SkillCategory.adaptation:
        return 'Flexibility and growth';
    }
  }
}

/// Skill node in the skill tree.
class SkillNode {
  const SkillNode({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tier,
    required this.cost,
    this.icon,
    this.statBonus = const {},
    this.xpBonus = 0.0,
    this.recoveryBonus = 0.0,
    this.requiredSkillIds = const [],
    this.requiredLevel = 1,
    this.requiredStats = const {},
    this.isUnlocked = false,
    this.isPurchased = false,
  });

  final String id;
  final String name;
  final String description;
  final SkillCategory category;
  final int tier;
  final int cost;
  final String? icon;
  final Map<String, double> statBonus;
  final double xpBonus;
  final double recoveryBonus;
  final List<String> requiredSkillIds;
  final int requiredLevel;
  final Map<String, int> requiredStats;
  final bool isUnlocked;
  final bool isPurchased;

  bool get canPurchase => isUnlocked && !isPurchased;

  SkillNode copyWith({
    String? id,
    String? name,
    String? description,
    SkillCategory? category,
    int? tier,
    int? cost,
    String? icon,
    Map<String, double>? statBonus,
    double? xpBonus,
    double? recoveryBonus,
    List<String>? requiredSkillIds,
    int? requiredLevel,
    Map<String, int>? requiredStats,
    bool? isUnlocked,
    bool? isPurchased,
  }) {
    return SkillNode(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      tier: tier ?? this.tier,
      cost: cost ?? this.cost,
      icon: icon ?? this.icon,
      statBonus: statBonus ?? this.statBonus,
      xpBonus: xpBonus ?? this.xpBonus,
      recoveryBonus: recoveryBonus ?? this.recoveryBonus,
      requiredSkillIds: requiredSkillIds ?? this.requiredSkillIds,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      requiredStats: requiredStats ?? this.requiredStats,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category.index,
        'tier': tier,
        'cost': cost,
        'icon': icon,
        'statBonus': statBonus,
        'xpBonus': xpBonus,
        'recoveryBonus': recoveryBonus,
        'requiredSkillIds': requiredSkillIds,
        'requiredLevel': requiredLevel,
        'requiredStats': requiredStats,
        'isUnlocked': isUnlocked,
        'isPurchased': isPurchased,
      };

  factory SkillNode.fromJson(Map<String, dynamic> json) {
    return SkillNode(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: SkillCategory.values[json['category'] as int],
      tier: json['tier'] as int,
      cost: json['cost'] as int,
      icon: json['icon'] as String?,
      statBonus: (json['statBonus'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
          {},
      xpBonus: (json['xpBonus'] as num?)?.toDouble() ?? 0,
      recoveryBonus: (json['recoveryBonus'] as num?)?.toDouble() ?? 0,
      requiredSkillIds: (json['requiredSkillIds'] as List<dynamic>?)?.cast<String>() ?? [],
      requiredLevel: json['requiredLevel'] as int? ?? 1,
      requiredStats: (json['requiredStats'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          {},
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      isPurchased: json['isPurchased'] as bool? ?? false,
    );
  }
}

/// Predefined skill tree.
class SkillTreeCatalog {
  static List<SkillNode> get allSkills => [
        ...foundationSkills,
        ...strengthSkills,
        ...enduranceSkills,
        ...recoverySkills,
        ...precisionSkills,
        ...adaptationSkills,
      ];

  static const foundationSkills = [
    SkillNode(
      id: 'foundation_basics',
      name: 'Basics',
      description: 'Master fundamental movement patterns.',
      category: SkillCategory.foundation,
      tier: 1,
      cost: 0,
      icon: '📚',
      xpBonus: 0.05,
      requiredLevel: 1,
      isUnlocked: true,
      isPurchased: true,
    ),
    SkillNode(
      id: 'foundation_form',
      name: 'Form Control',
      description: 'Improve exercise technique.',
      category: SkillCategory.foundation,
      tier: 1,
      cost: 50,
      icon: '🎯',
      statBonus: {'precision': 2},
      xpBonus: 0.1,
      requiredSkillIds: ['foundation_basics'],
      requiredLevel: 3,
    ),
    SkillNode(
      id: 'foundation_breathing',
      name: 'Breath Control',
      description: 'Optimize breathing during exercises.',
      category: SkillCategory.foundation,
      tier: 2,
      cost: 75,
      icon: '🌬️',
      recoveryBonus: 0.05,
      requiredSkillIds: ['foundation_form'],
      requiredLevel: 5,
    ),
    SkillNode(
      id: 'foundation_consistency',
      name: 'Consistency',
      description: 'Build sustainable training habits.',
      category: SkillCategory.foundation,
      tier: 2,
      cost: 100,
      icon: '📅',
      xpBonus: 0.15,
      requiredSkillIds: ['foundation_breathing'],
      requiredLevel: 8,
    ),
  ];

  static const strengthSkills = [
    SkillNode(
      id: 'strength_power',
      name: 'Power',
      description: 'Develop explosive strength.',
      category: SkillCategory.strength,
      tier: 1,
      cost: 100,
      icon: '⚡',
      statBonus: {'strength': 5},
      xpBonus: 0.1,
      requiredSkillIds: ['foundation_form'],
      requiredLevel: 5,
    ),
    SkillNode(
      id: 'strength_endurance',
      name: 'Strength Endurance',
      description: 'Maintain strength over longer sets.',
      category: SkillCategory.strength,
      tier: 2,
      cost: 150,
      icon: '🏋️',
      statBonus: {'strength': 3, 'endurance': 2},
      requiredSkillIds: ['strength_power'],
      requiredLevel: 10,
    ),
    SkillNode(
      id: 'strength_explosive',
      name: 'Explosive Power',
      description: 'Maximize force production.',
      category: SkillCategory.strength,
      tier: 3,
      cost: 250,
      icon: '💥',
      statBonus: {'strength': 8},
      xpBonus: 0.2,
      requiredSkillIds: ['strength_endurance'],
      requiredLevel: 15,
    ),
  ];

  static const enduranceSkills = [
    SkillNode(
      id: 'endurance_cardio',
      name: 'Cardiovascular Base',
      description: 'Build aerobic endurance.',
      category: SkillCategory.endurance,
      tier: 1,
      cost: 100,
      icon: '❤️',
      statBonus: {'endurance': 5},
      xpBonus: 0.1,
      requiredSkillIds: ['foundation_basics'],
      requiredLevel: 5,
    ),
    SkillNode(
      id: 'endurance_stamina',
      name: 'Stamina',
      description: 'Extend workout capacity.',
      category: SkillCategory.endurance,
      tier: 2,
      cost: 150,
      icon: '🏃',
      statBonus: {'endurance': 4, 'recovery': 1},
      requiredSkillIds: ['endurance_cardio'],
      requiredLevel: 10,
    ),
    SkillNode(
      id: 'endurance_ultra',
      name: 'Ultra Endurance',
      description: 'Achieve elite stamina.',
      category: SkillCategory.endurance,
      tier: 3,
      cost: 300,
      icon: '🏔️',
      statBonus: {'endurance': 10},
      xpBonus: 0.25,
      requiredSkillIds: ['endurance_stamina'],
      requiredLevel: 20,
    ),
  ];

  static const recoverySkills = [
    SkillNode(
      id: 'recovery_sleep',
      name: 'Sleep Optimization',
      description: 'Improve sleep quality.',
      category: SkillCategory.recovery,
      tier: 1,
      cost: 75,
      icon: '😴',
      recoveryBonus: 0.1,
      requiredSkillIds: ['foundation_basics'],
      requiredLevel: 3,
    ),
    SkillNode(
      id: 'recovery_adaptation',
      name: 'Adaptation',
      description: 'Speed up recovery between sessions.',
      category: SkillCategory.recovery,
      tier: 2,
      cost: 150,
      icon: '🔄',
      recoveryBonus: 0.15,
      statBonus: {'recovery': 3},
      requiredSkillIds: ['recovery_sleep'],
      requiredLevel: 10,
    ),
    SkillNode(
      id: 'recovery_mastery',
      name: 'Recovery Mastery',
      description: 'Elite recovery capability.',
      category: SkillCategory.recovery,
      tier: 3,
      cost: 300,
      icon: '✨',
      recoveryBonus: 0.25,
      statBonus: {'recovery': 5},
      xpBonus: 0.15,
      requiredSkillIds: ['recovery_adaptation'],
      requiredLevel: 20,
    ),
  ];

  static const precisionSkills = [
    SkillNode(
      id: 'precision_control',
      name: 'Control',
      description: 'Improve movement precision.',
      category: SkillCategory.precision,
      tier: 1,
      cost: 100,
      icon: '🎯',
      statBonus: {'precision': 5},
      xpBonus: 0.1,
      requiredSkillIds: ['foundation_form'],
      requiredLevel: 5,
    ),
    SkillNode(
      id: 'precision_timing',
      name: 'Timing',
      description: 'Master exercise timing.',
      category: SkillCategory.precision,
      tier: 2,
      cost: 150,
      icon: '⏱️',
      statBonus: {'precision': 4, 'focus': 2},
      requiredSkillIds: ['precision_control'],
      requiredLevel: 10,
    ),
    SkillNode(
      id: 'precision_mastery',
      name: 'Precision Mastery',
      description: 'Achieve perfect execution.',
      category: SkillCategory.precision,
      tier: 3,
      cost: 250,
      icon: '👑',
      statBonus: {'precision': 8},
      xpBonus: 0.2,
      requiredSkillIds: ['precision_timing'],
      requiredLevel: 18,
    ),
  ];

  static const adaptationSkills = [
    SkillNode(
      id: 'adaptation_flexibility',
      name: 'Flexibility',
      description: 'Improve range of motion.',
      category: SkillCategory.adaptation,
      tier: 1,
      cost: 75,
      icon: '🧘',
      statBonus: {'mobility': 5},
      requiredSkillIds: ['foundation_basics'],
      requiredLevel: 3,
    ),
    SkillNode(
      id: 'adaptation_resilience',
      name: 'Resilience',
      description: 'Build mental and physical resilience.',
      category: SkillCategory.adaptation,
      tier: 2,
      cost: 150,
      icon: '🛡️',
      statBonus: {'mobility': 3, 'recovery': 2},
      recoveryBonus: 0.1,
      requiredSkillIds: ['adaptation_flexibility'],
      requiredLevel: 10,
    ),
    SkillNode(
      id: 'adaptation_mastery',
      name: 'Adaptation Mastery',
      description: 'Ultimate adaptive capability.',
      category: SkillCategory.adaptation,
      tier: 3,
      cost: 300,
      icon: '🦋',
      statBonus: {'mobility': 6, 'focus': 4},
      xpBonus: 0.2,
      recoveryBonus: 0.15,
      requiredSkillIds: ['adaptation_resilience'],
      requiredLevel: 20,
    ),
  ];
}

/// Skill tree state.
class SkillTreeState {
  const SkillTreeState({
    this.skills = const [],
    this.totalSpent = 0,
    this.categoryUnlocks = const {},
  });

  final List<SkillNode> skills;
  final int totalSpent;
  final Map<SkillCategory, bool> categoryUnlocks;

  factory SkillTreeState.initial() {
    final skills = SkillTreeCatalog.allSkills;
    return SkillTreeState(
      skills: skills,
      categoryUnlocks: {
        for (final cat in SkillCategory.values) cat: false,
      },
    );
  }

  SkillNode? getSkill(String id) {
    return skills.where((s) => s.id == id).firstOrNull;
  }

  List<SkillNode> getSkillsByCategory(SkillCategory category) {
    return skills.where((s) => s.category == category).toList();
  }

  List<SkillNode> getPurchasedSkills() {
    return skills.where((s) => s.isPurchased).toList();
  }

  double get totalXpBonus => getPurchasedSkills().fold(0.0, (sum, s) => sum + s.xpBonus);
  double get totalRecoveryBonus => getPurchasedSkills().fold(0.0, (sum, s) => sum + s.recoveryBonus);

  SkillTreeState copyWith({
    List<SkillNode>? skills,
    int? totalSpent,
    Map<SkillCategory, bool>? categoryUnlocks,
  }) {
    return SkillTreeState(
      skills: skills ?? this.skills,
      totalSpent: totalSpent ?? this.totalSpent,
      categoryUnlocks: categoryUnlocks ?? this.categoryUnlocks,
    );
  }

  Map<String, dynamic> toJson() => {
        'skills': skills.map((s) => s.toJson()).toList(),
        'totalSpent': totalSpent,
        'categoryUnlocks': categoryUnlocks.map((k, v) => MapEntry(k.index.toString(), v)),
      };

  factory SkillTreeState.fromJson(Map<String, dynamic> json) {
    final skillsList = (json['skills'] as List<dynamic>?)
        ?.map((s) => SkillNode.fromJson(s as Map<String, dynamic>))
        .toList();

    return SkillTreeState(
      skills: skillsList ?? SkillTreeCatalog.allSkills,
      totalSpent: json['totalSpent'] as int? ?? 0,
      categoryUnlocks: (json['categoryUnlocks'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(SkillCategory.values[int.parse(k)], v as bool)) ??
          {},
    );
  }
}
