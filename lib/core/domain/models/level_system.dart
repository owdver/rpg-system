/// Rank tiers in the system.
enum RankTier {
  e,
  d,
  c,
  b,
  a,
  s,
  ss,
  sss,
}

extension RankTierExtension on RankTier {
  String get label {
    switch (this) {
      case RankTier.e:
        return 'E';
      case RankTier.d:
        return 'D';
      case RankTier.c:
        return 'C';
      case RankTier.b:
        return 'B';
      case RankTier.a:
        return 'A';
      case RankTier.s:
        return 'S';
      case RankTier.ss:
        return 'SS';
      case RankTier.sss:
        return 'SSS';
    }
  }

  String get fullName {
    switch (this) {
      case RankTier.e:
        return 'Entry';
      case RankTier.d:
        return 'Developed';
      case RankTier.c:
        return 'Capable';
      case RankTier.b:
        return 'Battle-Ready';
      case RankTier.a:
        return 'Advanced';
      case RankTier.s:
        return 'Specialist';
      case RankTier.ss:
        return 'Elite';
      case RankTier.sss:
        return 'Legendary';
    }
  }

  /// Level threshold for this rank.
  int get levelThreshold {
    switch (this) {
      case RankTier.e:
        return 1;
      case RankTier.d:
        return 10;
      case RankTier.c:
        return 25;
      case RankTier.b:
        return 50;
      case RankTier.a:
        return 75;
      case RankTier.s:
        return 100;
      case RankTier.ss:
        return 150;
      case RankTier.sss:
        return 200;
    }
  }

  /// XP multiplier for this rank.
  double get xpMultiplier {
    switch (this) {
      case RankTier.e:
        return 1.0;
      case RankTier.d:
        return 1.1;
      case RankTier.c:
        return 1.2;
      case RankTier.b:
        return 1.4;
      case RankTier.a:
        return 1.6;
      case RankTier.s:
        return 2.0;
      case RankTier.ss:
        return 2.5;
      case RankTier.sss:
        return 3.0;
    }
  }

  static RankTier fromLevel(int level) {
    for (final tier in RankTier.values.reversed) {
      if (level >= tier.levelThreshold) {
        return tier;
      }
    }
    return RankTier.e;
  }
}

/// Title tiers.
enum TitleTier {
  initiate,
  operator,
  vanguard,
  sentinel,
  architect,
}

extension TitleTierExtension on TitleTier {
  String get label {
    switch (this) {
      case TitleTier.initiate:
        return 'Initiate';
      case TitleTier.operator:
        return 'Operator';
      case TitleTier.vanguard:
        return 'Vanguard';
      case TitleTier.sentinel:
        return 'Sentinel';
      case TitleTier.architect:
        return 'Architect';
    }
  }

  /// Level threshold for this title tier.
  int get levelThreshold {
    switch (this) {
      case TitleTier.initiate:
        return 1;
      case TitleTier.operator:
        return 20;
      case TitleTier.vanguard:
        return 50;
      case TitleTier.sentinel:
        return 100;
      case TitleTier.architect:
        return 200;
    }
  }

  static TitleTier fromLevel(int level) {
    for (final tier in TitleTier.values.reversed) {
      if (level >= tier.levelThreshold) {
        return tier;
      }
    }
    return TitleTier.initiate;
  }
}

/// A specific title that can be earned.
class Title {
  const Title({
    required this.id,
    required this.name,
    required this.tier,
    required this.description,
    this.isHidden = false,
    this.icon,
  });

  final String id;
  final String name;
  final TitleTier tier;
  final String description;
  final bool isHidden;
  final String? icon;

  static const defaultTitles = [
    Title(
      id: 'initiate_rookie',
      name: 'Rookie',
      tier: TitleTier.initiate,
      description: 'Just starting your journey.',
    ),
    Title(
      id: 'initiate_learner',
      name: 'Learner',
      tier: TitleTier.initiate,
      description: 'Absorbing knowledge daily.',
    ),
    Title(
      id: 'operator_trainer',
      name: 'Trainer',
      tier: TitleTier.operator,
      description: 'Developing solid foundations.',
    ),
    Title(
      id: 'operator_warrior',
      name: 'Warrior',
      tier: TitleTier.operator,
      description: 'Battle-ready and improving.',
    ),
    Title(
      id: 'vanguard_veteran',
      name: 'Veteran',
      tier: TitleTier.vanguard,
      description: 'Experienced in many missions.',
    ),
    Title(
      id: 'vanguard_champion',
      name: 'Champion',
      tier: TitleTier.vanguard,
      description: 'Consistently achieving excellence.',
    ),
    Title(
      id: 'sentinel_guardian',
      name: 'Guardian',
      tier: TitleTier.sentinel,
      description: 'Protector of your progress.',
    ),
    Title(
      id: 'sentinel_master',
      name: 'Master',
      tier: TitleTier.sentinel,
      description: 'Mastery achieved through discipline.',
    ),
    Title(
      id: 'architect_legend',
      name: 'Legend',
      tier: TitleTier.architect,
      description: 'A living legend.',
    ),
    Title(
      id: 'architect_transcendent',
      name: 'Transcendent',
      tier: TitleTier.architect,
      description: 'Beyond ordinary limits.',
    ),
  ];
}

/// User's progression state.
class ProgressionState {
  const ProgressionState({
    this.currentTitle,
    this.unlockedTitles = const [],
    this.currentRank = RankTier.e,
    this.displayTitle = 'Operative',
  });

  final Title? currentTitle;
  final List<Title> unlockedTitles;
  final RankTier currentRank;
  final String displayTitle;

  /// Get rank based on level.
  static RankTier rankForLevel(int level) {
    return RankTierExtension.fromLevel(level);
  }

  /// Get title tier based on level.
  static TitleTier titleTierForLevel(int level) {
    return TitleTierExtension.fromLevel(level);
  }

  ProgressionState copyWith({
    Title? currentTitle,
    List<Title>? unlockedTitles,
    RankTier? currentRank,
    String? displayTitle,
  }) {
    return ProgressionState(
      currentTitle: currentTitle ?? this.currentTitle,
      unlockedTitles: unlockedTitles ?? this.unlockedTitles,
      currentRank: currentRank ?? this.currentRank,
      displayTitle: displayTitle ?? this.displayTitle,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentTitle': currentTitle?.id,
        'unlockedTitles': unlockedTitles.map((t) => t.id).toList(),
        'currentRank': currentRank.index,
        'displayTitle': displayTitle,
      };

  factory ProgressionState.fromJson(Map<String, dynamic> json) {
    final titleId = json['currentTitle'] as String?;
    final title = titleId != null
        ? Title.defaultTitles.firstWhere(
            (t) => t.id == titleId,
            orElse: () => Title.defaultTitles.first,
          )
        : null;

    final unlockedIds =
        (json['unlockedTitles'] as List<dynamic>?)?.cast<String>() ?? [];
    final unlocked = unlockedIds
        .map((id) => Title.defaultTitles.where((t) => t.id == id))
        .expand((t) => t)
        .toList();

    return ProgressionState(
      currentTitle: title,
      unlockedTitles: unlocked,
      currentRank: RankTier.values[json['currentRank'] as int? ?? 0],
      displayTitle: json['displayTitle'] as String? ?? 'Operative',
    );
  }
}
