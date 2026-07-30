import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// System message priority levels.
enum SystemMessagePriority {
  low,
  normal,
  high,
  critical,
}

extension SystemMessagePriorityExtension on SystemMessagePriority {
  String get label {
    switch (this) {
      case SystemMessagePriority.low:
        return 'LOW';
      case SystemMessagePriority.normal:
        return 'NORMAL';
      case SystemMessagePriority.high:
        return 'HIGH';
      case SystemMessagePriority.critical:
        return 'CRITICAL';
    }
  }

  Duration get displayDuration {
    switch (this) {
      case SystemMessagePriority.low:
        return const Duration(seconds: 3);
      case SystemMessagePriority.normal:
        return const Duration(seconds: 5);
      case SystemMessagePriority.high:
        return const Duration(seconds: 8);
      case SystemMessagePriority.critical:
        return const Duration(seconds: 0); // Manual dismiss
    }
  }
}

/// System message categories.
enum SystemMessageCategory {
  mission,
  recovery,
  progress,
  achievement,
  system,
  warning,
  success,
}

extension SystemMessageCategoryExtension on SystemMessageCategory {
  String get label {
    switch (this) {
      case SystemMessageCategory.mission:
        return 'MISSION';
      case SystemMessageCategory.recovery:
        return 'RECOVERY';
      case SystemMessageCategory.progress:
        return 'PROGRESS';
      case SystemMessageCategory.achievement:
        return 'ACHIEVEMENT';
      case SystemMessageCategory.system:
        return 'SYSTEM';
      case SystemMessageCategory.warning:
        return 'WARNING';
      case SystemMessageCategory.success:
        return 'SUCCESS';
    }
  }
}

/// A system notification message.
class SystemMessage {
  SystemMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    this.priority = SystemMessagePriority.normal,
    this.actionLabel,
    this.actionKey,
    this.icon,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String id;
  final String title;
  final String body;
  final SystemMessageCategory category;
  final SystemMessagePriority priority;
  final String? actionLabel;
  final String? actionKey;
  final String? icon;
  final DateTime timestamp;

  SystemMessage copyWith({
    String? id,
    String? title,
    String? body,
    SystemMessageCategory? category,
    SystemMessagePriority? priority,
    String? actionLabel,
    String? actionKey,
    String? icon,
    DateTime? timestamp,
  }) {
    return SystemMessage(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      actionLabel: actionLabel ?? this.actionLabel,
      actionKey: actionKey ?? this.actionKey,
      icon: icon ?? this.icon,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// State for the system notification system.
class SystemNotificationState {
  const SystemNotificationState({
    this.messages = const [],
    this.isEnabled = true,
    this.soundEnabled = true,
    this.hapticEnabled = true,
  });

  final List<SystemMessage> messages;
  final bool isEnabled;
  final bool soundEnabled;
  final bool hapticEnabled;

  SystemNotificationState copyWith({
    List<SystemMessage>? messages,
    bool? isEnabled,
    bool? soundEnabled,
    bool? hapticEnabled,
  }) {
    return SystemNotificationState(
      messages: messages ?? this.messages,
      isEnabled: isEnabled ?? this.isEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    );
  }
}

/// System notification notifier for managing messages.
class SystemNotificationNotifier extends StateNotifier<SystemNotificationState> {
  SystemNotificationNotifier() : super(const SystemNotificationState());

  final _messageController = StreamController<SystemMessage>.broadcast();
  Timer? _cleanupTimer;

  Stream<SystemMessage> get messageStream => _messageController.stream;

  /// Adds a new system message.
  void addMessage(SystemMessage message) {
    final newMessage = message.copyWith(
      timestamp: DateTime.now(),
    );
    
    state = state.copyWith(
      messages: [newMessage, ...state.messages].take(50).toList(),
    );
    
    _messageController.add(newMessage);
    _scheduleCleanup(message);
  }

  /// Adds a mission-related message.
  void addMissionMessage(String title, String body, {SystemMessagePriority priority = SystemMessagePriority.normal}) {
    addMessage(SystemMessage(
      id: 'mission_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      category: SystemMessageCategory.mission,
      priority: priority,
      icon: '🎯',
    ));
  }

  /// Adds a recovery-related message.
  void addRecoveryMessage(String title, String body, {SystemMessagePriority priority = SystemMessagePriority.normal}) {
    addMessage(SystemMessage(
      id: 'recovery_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      category: SystemMessageCategory.recovery,
      priority: priority,
      icon: '💤',
    ));
  }

  /// Adds a progress-related message.
  void addProgressMessage(String title, String body, {SystemMessagePriority priority = SystemMessagePriority.normal}) {
    addMessage(SystemMessage(
      id: 'progress_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      category: SystemMessageCategory.progress,
      priority: priority,
      icon: '📈',
    ));
  }

  /// Adds an achievement message.
  void addAchievementMessage(String title, String body) {
    addMessage(SystemMessage(
      id: 'achievement_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      category: SystemMessageCategory.achievement,
      priority: SystemMessagePriority.high,
      icon: '🏆',
    ));
  }

  /// Adds a success message.
  void addSuccessMessage(String title, String body) {
    addMessage(SystemMessage(
      id: 'success_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      category: SystemMessageCategory.success,
      priority: SystemMessagePriority.normal,
      icon: '✓',
    ));
  }

  /// Adds a warning message.
  void addWarningMessage(String title, String body) {
    addMessage(SystemMessage(
      id: 'warning_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      category: SystemMessageCategory.warning,
      priority: SystemMessagePriority.high,
      icon: '⚠',
    ));
  }

  /// Dismisses a message by ID.
  void dismissMessage(String id) {
    state = state.copyWith(
      messages: state.messages.where((m) => m.id != id).toList(),
    );
  }

  /// Dismisses all messages.
  void dismissAll() {
    state = state.copyWith(messages: []);
  }

  /// Marks message as read.
  void markAsRead(String id) {
    // In a full implementation, messages would have a 'read' field
    // For now, we just remove them from the list
    dismissMessage(id);
  }

  /// Sets notification enabled state.
  void setEnabled(bool enabled) {
    state = state.copyWith(isEnabled: enabled);
  }

  /// Sets sound enabled state.
  void setSoundEnabled(bool enabled) {
    state = state.copyWith(soundEnabled: enabled);
  }

  /// Sets haptic enabled state.
  void setHapticEnabled(bool enabled) {
    state = state.copyWith(hapticEnabled: enabled);
  }

  void _scheduleCleanup(SystemMessage message) {
    if (message.priority == SystemMessagePriority.critical) {
      return; // Critical messages require manual dismissal
    }

    _cleanupTimer?.cancel();
    _cleanupTimer = Timer(message.priority.displayDuration, () {
      dismissMessage(message.id);
    });
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    _messageController.close();
    super.dispose();
  }
}

/// Provider for system notifications.
final systemNotificationProvider =
    StateNotifierProvider<SystemNotificationNotifier, SystemNotificationState>(
  (ref) => SystemNotificationNotifier(),
);

/// Provider for unread message count.
final unreadMessageCountProvider = Provider<int>((ref) {
  return ref.watch(systemNotificationProvider).messages.length;
});

/// Provider for critical messages only.
final criticalMessagesProvider = Provider<List<SystemMessage>>((ref) {
  return ref.watch(systemNotificationProvider).messages
      .where((m) => m.priority == SystemMessagePriority.critical)
      .toList();
});
