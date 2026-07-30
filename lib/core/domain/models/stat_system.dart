/// Primary stats in the system.
enum PrimaryStat {
  strength,
  endurance,
  mobility,
  recovery,
  precision,
  focus,
}

extension PrimaryStatExtension on PrimaryStat {
  String get label {
    switch (this) {
      case PrimaryStat.strength:
        return 'Strength';
      case PrimaryStat.endurance:
        return 'Endurance';
      case PrimaryStat.mobility:
        return 'Mobility';
      case PrimaryStat.recovery:
        return 'Recovery';
      case PrimaryStat.precision:
        return 'Precision';
      case PrimaryStat.focus:
        return 'Focus';
    }
  }

  String get description {
    switch (this) {
      case PrimaryStat.strength:
        return 'Raw power and force output';
      case PrimaryStat.endurance:
        return 'Stamina and sustained effort';
      case PrimaryStat.mobility:
        return 'Flexibility and range of motion';
      case PrimaryStat.recovery:
        return 'Adaptation and bounce back';
      case PrimaryStat.precision:
        return 'Accuracy and control';
      case PrimaryStat.focus:
        return 'Mental clarity and concentration';
    }
  }

  String get icon {
    switch (this) {
      case PrimaryStat.strength:
        return '💪';
      case PrimaryStat.endurance:
        return '🏃';
      case PrimaryStat.mobility:
        return '🧘';
      case PrimaryStat.recovery:
        return '🔄';
      case PrimaryStat.precision:
        return '🎯';
      case PrimaryStat.focus:
        return '🧠';
    }
  }

  /// Which workout types contribute to this stat.
  List<String> get contributingWorkouts {
    switch (this) {
      case PrimaryStat.strength:
        return ['strength', 'hypertrophy'];
      case PrimaryStat.endurance:
        return ['cardio', 'running', 'cycling', 'swimming'];
      case PrimaryStat.mobility:
        return ['yoga', 'mobility', 'pilates'];
      case PrimaryStat.recovery:
        return ['recovery', 'rest'];
      case PrimaryStat.precision:
        return ['hiit', 'calisthenics'];
      case PrimaryStat.focus:
        return ['meditation', 'yoga'];
    }
  }
}

/// Secondary stats derived from primary stats.
enum SecondaryStat {
  stamina,
  resilience,
  adaptability,
  rhythm,
}

extension SecondaryStatExtension on SecondaryStat {
  String get label {
    switch (this) {
      case SecondaryStat.stamina:
        return 'Stamina';
      case SecondaryStat.resilience:
        return 'Resilience';
      case SecondaryStat.adaptability:
        return 'Adaptability';
      case SecondaryStat.rhythm:
        return 'Rhythm';
    }
  }

  /// The primary stat that influences this secondary stat.
  PrimaryStat get primaryInfluence {
    switch (this) {
      case SecondaryStat.stamina:
        return PrimaryStat.endurance;
      case SecondaryStat.resilience:
        return PrimaryStat.recovery;
      case SecondaryStat.adaptability:
        return PrimaryStat.mobility;
      case SecondaryStat.rhythm:
        return PrimaryStat.precision;
    }
  }
}

/// A stat value with its current and max value.
class StatValue {
  const StatValue({
    required this.current,
    this.max = 100,
  });

  final double current;
  final double max;

  double get percentage => max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;

  StatValue copyWith({
    double? current,
    double? max,
  }) {
    return StatValue(
      current: current ?? this.current,
      max: max ?? this.max,
    );
  }

  StatValue add(double amount) {
    return copyWith(current: (current + amount).clamp(0, max));
  }

  Map<String, dynamic> toJson() => {
        'current': current,
        'max': max,
      };

  factory StatValue.fromJson(Map<String, dynamic> json) {
    return StatValue(
      current: (json['current'] as num).toDouble(),
      max: (json['max'] as num?)?.toDouble() ?? 100,
    );
  }
}

/// All user stats.
class UserStats {
  const UserStats({
    this.strength = const StatValue(current: 10),
    this.endurance = const StatValue(current: 10),
    this.mobility = const StatValue(current: 10),
    this.recovery = const StatValue(current: 10),
    this.precision = const StatValue(current: 10),
    this.focus = const StatValue(current: 10),
  });

  final StatValue strength;
  final StatValue endurance;
  final StatValue mobility;
  final StatValue recovery;
  final StatValue precision;
  final StatValue focus;

  StatValue getStat(PrimaryStat stat) {
    switch (stat) {
      case PrimaryStat.strength:
        return strength;
      case PrimaryStat.endurance:
        return endurance;
      case PrimaryStat.mobility:
        return mobility;
      case PrimaryStat.recovery:
        return recovery;
      case PrimaryStat.precision:
        return precision;
      case PrimaryStat.focus:
        return focus;
    }
  }

  double get secondaryStatValue => 0.0;

  UserStats copyWith({
    StatValue? strength,
    StatValue? endurance,
    StatValue? mobility,
    StatValue? recovery,
    StatValue? precision,
    StatValue? focus,
  }) {
    return UserStats(
      strength: strength ?? this.strength,
      endurance: endurance ?? this.endurance,
      mobility: mobility ?? this.mobility,
      recovery: recovery ?? this.recovery,
      precision: precision ?? this.precision,
      focus: focus ?? this.focus,
    );
  }

  UserStats addStat(PrimaryStat stat, double amount) {
    switch (stat) {
      case PrimaryStat.strength:
        return copyWith(strength: strength.add(amount));
      case PrimaryStat.endurance:
        return copyWith(endurance: endurance.add(amount));
      case PrimaryStat.mobility:
        return copyWith(mobility: mobility.add(amount));
      case PrimaryStat.recovery:
        return copyWith(recovery: recovery.add(amount));
      case PrimaryStat.precision:
        return copyWith(precision: precision.add(amount));
      case PrimaryStat.focus:
        return copyWith(focus: focus.add(amount));
    }
  }

  Map<String, dynamic> toJson() => {
        'strength': strength.toJson(),
        'endurance': endurance.toJson(),
        'mobility': mobility.toJson(),
        'recovery': recovery.toJson(),
        'precision': precision.toJson(),
        'focus': focus.toJson(),
      };

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      strength: StatValue.fromJson(json['strength'] ?? {'current': 10}),
      endurance: StatValue.fromJson(json['endurance'] ?? {'current': 10}),
      mobility: StatValue.fromJson(json['mobility'] ?? {'current': 10}),
      recovery: StatValue.fromJson(json['recovery'] ?? {'current': 10}),
      precision: StatValue.fromJson(json['precision'] ?? {'current': 10}),
      focus: StatValue.fromJson(json['focus'] ?? {'current': 10}),
    );
  }
}
