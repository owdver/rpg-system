/// System event types.
enum SystemEventType {
  workoutStarted,
  workoutFinished,
  missionCompleted,
  missionFailed,
  missionExpired,
  waterLogged,
  mealLogged,
  sleepImported,
  heartRateSpike,
  recoveryUpdated,
  levelUp,
  rankUp,
  titleUnlocked,
  achievementUnlocked,
  statIncreased,
  xpEarned,
  streakMilestone,
  bossVictory,
  inventoryItemReceived,
  systemNotice,
}

extension SystemEventTypeExtension on SystemEventType {
  String get label {
    switch (this) {
      case SystemEventType.workoutStarted:
        return 'Workout Started';
      case SystemEventType.workoutFinished:
        return 'Workout Complete';
      case SystemEventType.missionCompleted:
        return 'Mission Complete';
      case SystemEventType.missionFailed:
        return 'Mission Failed';
      case SystemEventType.missionExpired:
        return 'Mission Expired';
      case SystemEventType.waterLogged:
        return 'Hydration Logged';
      case SystemEventType.mealLogged:
        return 'Meal Logged';
      case SystemEventType.sleepImported:
        return 'Sleep Imported';
      case SystemEventType.heartRateSpike:
        return 'Heart Rate Alert';
      case SystemEventType.recoveryUpdated:
        return 'Recovery Updated';
      case SystemEventType.levelUp:
        return 'Level Up';
      case SystemEventType.rankUp:
        return 'Rank Up';
      case SystemEventType.titleUnlocked:
        return 'Title Unlocked';
      case SystemEventType.achievementUnlocked:
        return 'Achievement Unlocked';
      case SystemEventType.statIncreased:
        return 'Stat Increased';
      case SystemEventType.xpEarned:
        return 'XP Earned';
      case SystemEventType.streakMilestone:
        return 'Streak Milestone';
      case SystemEventType.bossVictory:
        return 'Boss Victory';
      case SystemEventType.inventoryItemReceived:
        return 'Item Received';
      case SystemEventType.systemNotice:
        return 'System Notice';
    }
  }

  String get icon {
    switch (this) {
      case SystemEventType.workoutStarted:
        return '🏃';
      case SystemEventType.workoutFinished:
        return '✅';
      case SystemEventType.missionCompleted:
        return '🎯';
      case SystemEventType.missionFailed:
        return '❌';
      case SystemEventType.missionExpired:
        return '⏰';
      case SystemEventType.waterLogged:
        return '💧';
      case SystemEventType.mealLogged:
        return '🍽️';
      case SystemEventType.sleepImported:
        return '😴';
      case SystemEventType.heartRateSpike:
        return '❤️';
      case SystemEventType.recoveryUpdated:
        return '🔄';
      case SystemEventType.levelUp:
        return '⬆️';
      case SystemEventType.rankUp:
        return '⭐';
      case SystemEventType.titleUnlocked:
        return '👑';
      case SystemEventType.achievementUnlocked:
        return '🏆';
      case SystemEventType.statIncreased:
        return '📈';
      case SystemEventType.xpEarned:
        return '💎';
      case SystemEventType.streakMilestone:
        return '🔥';
      case SystemEventType.bossVictory:
        return '⚔️';
      case SystemEventType.inventoryItemReceived:
        return '🎁';
      case SystemEventType.systemNotice:
        return '📢';
    }
  }

  EventPriority get priority {
    switch (this) {
      case SystemEventType.levelUp:
      case SystemEventType.rankUp:
      case SystemEventType.titleUnlocked:
      case SystemEventType.achievementUnlocked:
      case SystemEventType.bossVictory:
        return EventPriority.high;
      case SystemEventType.missionCompleted:
      case SystemEventType.workoutFinished:
      case SystemEventType.streakMilestone:
        return EventPriority.normal;
      default:
        return EventPriority.low;
    }
  }
}

enum EventPriority {
  low,
  normal,
  high,
}

/// A system event payload.
class SystemEvent {
  const SystemEvent({
    required this.id,
    required this.type,
    required this.timestamp,
    this.title = '',
    this.body = '',
    this.data,
    this.correlationId,
    this.source,
  });

  final String id;
  final SystemEventType type;
  final DateTime timestamp;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final String? correlationId;
  final String? source;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'timestamp': timestamp.toIso8601String(),
        'title': title,
        'body': body,
        'data': data,
        'correlationId': correlationId,
        'source': source,
      };

  factory SystemEvent.fromJson(Map<String, dynamic> json) {
    return SystemEvent(
      id: json['id'] as String,
      type: SystemEventType.values[json['type'] as int],
      timestamp: DateTime.parse(json['timestamp'] as String),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>?,
      correlationId: json['correlationId'] as String?,
      source: json['source'] as String?,
    );
  }
}

/// Event factory for creating common events.
class EventFactory {
  static String _generateId() => '${DateTime.now().millisecondsSinceEpoch}';

  static SystemEvent workoutStarted(String workoutId, String workoutType) {
    return SystemEvent(
      id: _generateId(),
      type: SystemEventType.workoutStarted,
      timestamp: DateTime.now(),
      title: 'Workout Initiated',
      body: 'Starting $workoutType session',
      data: {'workoutId': workoutId, 'workoutType': workoutType},
    );
  }

  static SystemEvent workoutFinished(String workoutId, int xpEarned, int qualityScore) {
    return SystemEvent(
      id: _generateId(),
      type: SystemEventType.workoutFinished,
      timestamp: DateTime.now(),
      title: 'Workout Complete',
      body: 'Performance evaluated. Accuracy: $qualityScore%',
      data: {
        'workoutId': workoutId,
        'xpEarned': xpEarned,
        'qualityScore': qualityScore,
      },
    );
  }

  static SystemEvent missionCompleted(String missionId, String title, int xpReward) {
    return SystemEvent(
      id: _generateId(),
      type: SystemEventType.missionCompleted,
      timestamp: DateTime.now(),
      title: 'Mission Complete',
      body: '$title accomplished. +$xpReward XP',
      data: {'missionId': missionId, 'xpReward': xpReward},
    );
  }

  static SystemEvent levelUp(int newLevel) {
    return SystemEvent(
      id: _generateId(),
      type: SystemEventType.levelUp,
      timestamp: DateTime.now(),
      title: 'Level Up',
      body: 'Advancement achieved. Now level $newLevel.',
      data: {'newLevel': newLevel},
    );
  }

  static SystemEvent achievementUnlocked(String achievementId, String name) {
    return SystemEvent(
      id: _generateId(),
      type: SystemEventType.achievementUnlocked,
      timestamp: DateTime.now(),
      title: 'Achievement Unlocked',
      body: name,
      data: {'achievementId': achievementId},
    );
  }

  static SystemEvent xpEarned(int amount, String source) {
    return SystemEvent(
      id: _generateId(),
      type: SystemEventType.xpEarned,
      timestamp: DateTime.now(),
      title: 'XP Gained',
      body: '+$amount XP from $source',
      data: {'amount': amount, 'source': source},
    );
  }

  static SystemEvent recoveryUpdated(double readinessScore) {
    return SystemEvent(
      id: _generateId(),
      type: SystemEventType.recoveryUpdated,
      timestamp: DateTime.now(),
      title: 'Recovery Evaluated',
      body: 'Readiness: ${readinessScore.toInt()}%',
      data: {'readinessScore': readinessScore},
    );
  }

  static SystemEvent waterLogged(int glasses) {
    return SystemEvent(
      id: _generateId(),
      type: SystemEventType.waterLogged,
      timestamp: DateTime.now(),
      title: 'Hydration Logged',
      body: 'Recovery +2. +25 XP',
      data: {'glasses': glasses},
    );
  }

  static SystemEvent systemNotice(String message) {
    return SystemEvent(
      id: _generateId(),
      type: SystemEventType.systemNotice,
      timestamp: DateTime.now(),
      title: 'System Notice',
      body: message,
    );
  }
}
