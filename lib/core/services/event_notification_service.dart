import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpg_system/core/domain/models/models.dart';
import 'package:rpg_system/core/domain/providers/providers.dart';
import 'package:rpg_system/core/services/haptic_manager.dart';
import 'package:rpg_system/core/services/sound_manager.dart';

/// Event notification service - handles live reactions to system events.
class EventNotificationService {
  EventNotificationService({
    required this.hapticManager,
    required this.soundManager,
    required this.gameState,
  });

  final HapticManager hapticManager;
  final SoundManager soundManager;
  final GameState gameState;

  SystemEvent? _lastEvent;

  /// React to a new event.
  void onEvent(SystemEvent event) {
    // Avoid duplicate events
    if (event.id == _lastEvent?.id) return;
    _lastEvent = event;

    // Trigger haptic feedback based on event type
    _triggerHaptic(event.type);

    // Play sound based on event type
    _playSound(event.type);
  }

  void _triggerHaptic(SystemEventType type) {
    switch (type) {
      case SystemEventType.levelUp:
      case SystemEventType.rankUp:
        hapticManager.success();
        break;
      case SystemEventType.achievementUnlocked:
        hapticManager.success();
        break;
      case SystemEventType.missionCompleted:
        hapticManager.doubleTap();
        break;
      case SystemEventType.workoutFinished:
        hapticManager.success();
        break;
      case SystemEventType.statIncreased:
        hapticManager.lightTap();
        break;
      case SystemEventType.bossVictory:
        hapticManager.heavyImpact();
        break;
      default:
        hapticManager.lightTap();
    }
  }

  void _playSound(SystemEventType type) {
    switch (type) {
      case SystemEventType.levelUp:
        soundManager.playLevelUp();
        break;
      case SystemEventType.rankUp:
        soundManager.playRankUp();
        break;
      case SystemEventType.achievementUnlocked:
        soundManager.playAchievement();
        break;
      case SystemEventType.missionCompleted:
        soundManager.playMissionComplete();
        break;
      case SystemEventType.workoutFinished:
        soundManager.playWorkoutComplete();
        break;
      case SystemEventType.bossVictory:
        soundManager.playBossVictory();
        break;
      default:
        soundManager.playUI();
    }
  }
}

/// Provider for event notification service.
final eventNotificationServiceProvider = Provider<EventNotificationService>((ref) {
  final service = EventNotificationService(
    hapticManager: ref.watch(hapticManagerProvider),
    soundManager: ref.watch(soundManagerProvider),
    gameState: ref.watch(gameEngineProvider),
  );
  return service;
});

/// System message toast overlay manager.
class SystemMessageManager {
  static final SystemMessageManager _instance = SystemMessageManager._internal();
  factory SystemMessageManager() => _instance;
  SystemMessageManager._internal();

  OverlayEntry? _currentOverlay;

  void showMessage(
    BuildContext context, {
    required String title,
    required String message,
    required SystemEventType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    _currentOverlay?.remove();

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _SystemMessageToast(
        title: title,
        message: message,
        type: type,
        onDismiss: () => entry.remove(),
        duration: duration,
      ),
    );

    _currentOverlay = entry;
    overlay.insert(entry);
  }

  void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

class _SystemMessageToast extends StatefulWidget {
  const _SystemMessageToast({
    required this.title,
    required this.message,
    required this.type,
    required this.onDismiss,
    required this.duration,
  });

  final String title;
  final String message;
  final SystemEventType type;
  final VoidCallback onDismiss;
  final Duration duration;

  @override
  State<_SystemMessageToast> createState() => _SystemMessageToastState();
}

class _SystemMessageToastState extends State<_SystemMessageToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    // Auto-dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _accentColor {
    switch (widget.type) {
      case SystemEventType.levelUp:
      case SystemEventType.rankUp:
        return const Color(0xFFFFB84D);
      case SystemEventType.achievementUnlocked:
        return const Color(0xFFB84DFF);
      case SystemEventType.missionCompleted:
        return const Color(0xFF44E28A);
      case SystemEventType.workoutFinished:
        return const Color(0xFF54E6FF);
      case SystemEventType.bossVictory:
        return const Color(0xFFB84DFF);
      case SystemEventType.recoveryUpdated:
        return const Color(0xFFFF4757);
      default:
        return const Color(0xFF54E6FF);
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case SystemEventType.levelUp:
        return Icons.arrow_upward;
      case SystemEventType.rankUp:
        return Icons.military_tech;
      case SystemEventType.achievementUnlocked:
        return Icons.emoji_events;
      case SystemEventType.missionCompleted:
        return Icons.check_circle;
      case SystemEventType.workoutFinished:
        return Icons.fitness_center;
      case SystemEventType.bossVictory:
        return Icons.whatshot;
      case SystemEventType.recoveryUpdated:
        return Icons.favorite;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1626).withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _accentColor.withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _accentColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(_icon, color: _accentColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Color(0xFFF5FAFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.message,
                          style: const TextStyle(
                            color: Color(0xFF9FB2C8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF9FB2C8), size: 18),
                    onPressed: _dismiss,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
