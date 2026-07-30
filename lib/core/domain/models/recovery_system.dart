/// Recovery readiness levels.
enum RecoveryLevel {
  critical,
  poor,
  fair,
  good,
  excellent,
  optimal,
}

extension RecoveryLevelExtension on RecoveryLevel {
  String get label {
    switch (this) {
      case RecoveryLevel.critical:
        return 'Critical';
      case RecoveryLevel.poor:
        return 'Poor';
      case RecoveryLevel.fair:
        return 'Fair';
      case RecoveryLevel.good:
        return 'Good';
      case RecoveryLevel.excellent:
        return 'Excellent';
      case RecoveryLevel.optimal:
        return 'Optimal';
    }
  }

  String get recommendation {
    switch (this) {
      case RecoveryLevel.critical:
        return 'Rest recommended. Avoid intense training.';
      case RecoveryLevel.poor:
        return 'Light activity only. Focus on recovery.';
      case RecoveryLevel.fair:
        return 'Moderate training. Listen to your body.';
      case RecoveryLevel.good:
        return 'Normal training approved.';
      case RecoveryLevel.excellent:
        return 'High intensity training approved.';
      case RecoveryLevel.optimal:
        return 'Peak performance state. Push your limits!';
    }
  }

  int get colorValue {
    switch (this) {
      case RecoveryLevel.critical:
        return 0xFFDC3545;
      case RecoveryLevel.poor:
        return 0xFFFF8C00;
      case RecoveryLevel.fair:
        return 0xFFFFC107;
      case RecoveryLevel.good:
        return 0xFF17A2B8;
      case RecoveryLevel.excellent:
        return 0xFF28A745;
      case RecoveryLevel.optimal:
        return 0xFF9B59B6;
    }
  }

  static RecoveryLevel fromScore(double score) {
    if (score < 20) return RecoveryLevel.critical;
    if (score < 40) return RecoveryLevel.poor;
    if (score < 60) return RecoveryLevel.fair;
    if (score < 80) return RecoveryLevel.good;
    if (score < 95) return RecoveryLevel.excellent;
    return RecoveryLevel.optimal;
  }
}

/// Recovery metrics.
class RecoveryMetrics {
  const RecoveryMetrics({
    this.sleepHours = 0,
    this.sleepQuality = 0,
    this.hrvValue = 0,
    this.restingHeartRate = 0,
    this.fatigueLevel = 0,
    this.hydrationLevel = 0,
    this.previousWorkload = 0,
    this.consecutiveTrainingDays = 0,
    this.stressLevel = 0,
  });

  final double sleepHours;
  final int sleepQuality; // 0-100
  final int hrvValue; // Heart Rate Variability in ms
  final int restingHeartRate;
  final int fatigueLevel; // 0-100
  final int hydrationLevel; // 0-100
  final int previousWorkload; // 0-100
  final int consecutiveTrainingDays;
  final int stressLevel; // 0-100

  Map<String, dynamic> toJson() => {
        'sleepHours': sleepHours,
        'sleepQuality': sleepQuality,
        'hrvValue': hrvValue,
        'restingHeartRate': restingHeartRate,
        'fatigueLevel': fatigueLevel,
        'hydrationLevel': hydrationLevel,
        'previousWorkload': previousWorkload,
        'consecutiveTrainingDays': consecutiveTrainingDays,
        'stressLevel': stressLevel,
      };

  factory RecoveryMetrics.fromJson(Map<String, dynamic> json) {
    return RecoveryMetrics(
      sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 0,
      sleepQuality: json['sleepQuality'] as int? ?? 0,
      hrvValue: json['hrvValue'] as int? ?? 0,
      restingHeartRate: json['restingHeartRate'] as int? ?? 0,
      fatigueLevel: json['fatigueLevel'] as int? ?? 0,
      hydrationLevel: json['hydrationLevel'] as int? ?? 0,
      previousWorkload: json['previousWorkload'] as int? ?? 0,
      consecutiveTrainingDays: json['consecutiveTrainingDays'] as int? ?? 0,
      stressLevel: json['stressLevel'] as int? ?? 0,
    );
  }
}

/// Recovery state containing readiness score and metrics.
class RecoveryState {
  const RecoveryState({
    this.readinessScore = 50,
    this.metrics = const RecoveryMetrics(),
    this.lastUpdated,
    this.recommendation = 'Normal training approved.',
  });

  final double readinessScore;
  final RecoveryMetrics metrics;
  final DateTime? lastUpdated;
  final String recommendation;

  RecoveryLevel get level => RecoveryLevelExtension.fromScore(readinessScore);

  /// Calculate readiness based on metrics.
  static double calculateReadiness(RecoveryMetrics metrics) {
    double score = 0;

    // Sleep contribution (up to 30 points)
    if (metrics.sleepHours >= 7 && metrics.sleepHours <= 9) {
      score += 30;
    } else if (metrics.sleepHours >= 6) {
      score += 20;
    } else if (metrics.sleepHours >= 5) {
      score += 10;
    } else if (metrics.sleepHours > 0) {
      score += 5;
    }

    // Sleep quality contribution (up to 15 points)
    score += (metrics.sleepQuality / 100 * 15);

    // HRV contribution (up to 20 points)
    // Higher HRV = better recovery
    if (metrics.hrvValue > 0) {
      if (metrics.hrvValue >= 60) {
        score += 20;
      } else if (metrics.hrvValue >= 40) {
        score += 15;
      } else if (metrics.hrvValue >= 25) {
        score += 10;
      } else {
        score += 5;
      }
    }

    // Resting HR contribution (up to 10 points)
    // Lower resting HR = better recovery
    if (metrics.restingHeartRate > 0) {
      if (metrics.restingHeartRate < 60) {
        score += 10;
      } else if (metrics.restingHeartRate < 70) {
        score += 7;
      } else if (metrics.restingHeartRate < 80) {
        score += 4;
      } else {
        score += 1;
      }
    }

    // Fatigue penalty (up to -15 points)
    score -= (metrics.fatigueLevel / 100 * 15);

    // Hydration contribution (up to 10 points)
    score += (metrics.hydrationLevel / 100 * 10);

    // Training frequency penalty (up to -10 points)
    if (metrics.consecutiveTrainingDays > 5) {
      score -= 10;
    } else if (metrics.consecutiveTrainingDays > 3) {
      score -= 5;
    }

    // Stress penalty (up to -10 points)
    score -= (metrics.stressLevel / 100 * 10);

    // Previous workload contribution (up to -10 points)
    score -= (metrics.previousWorkload / 100 * 10);

    return score.clamp(0, 100);
  }

  RecoveryState copyWith({
    double? readinessScore,
    RecoveryMetrics? metrics,
    DateTime? lastUpdated,
    String? recommendation,
  }) {
    return RecoveryState(
      readinessScore: readinessScore ?? this.readinessScore,
      metrics: metrics ?? this.metrics,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      recommendation: recommendation ?? this.recommendation,
    );
  }

  Map<String, dynamic> toJson() => {
        'readinessScore': readinessScore,
        'metrics': metrics.toJson(),
        'lastUpdated': lastUpdated?.toIso8601String(),
        'recommendation': recommendation,
      };

  factory RecoveryState.fromJson(Map<String, dynamic> json) {
    return RecoveryState(
      readinessScore: (json['readinessScore'] as num?)?.toDouble() ?? 50,
      metrics: RecoveryMetrics.fromJson(
          json['metrics'] as Map<String, dynamic>? ?? {}),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
      recommendation: json['recommendation'] as String? ?? 'Normal training approved.',
    );
  }
}
