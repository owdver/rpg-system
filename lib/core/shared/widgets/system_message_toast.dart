import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_typography.dart';
import '../../constants/app_animations.dart';
import '../../services/system_notification_service.dart';
import 'holographic_container.dart';

/// System message toast widget for displaying notifications.
class SystemMessageToast extends StatefulWidget {
  const SystemMessageToast({
    super.key,
    required this.message,
    this.onDismiss,
    this.onAction,
  });

  final SystemMessage message;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;

  @override
  State<SystemMessageToast> createState() => _SystemMessageToastState();
}

class _SystemMessageToastState extends State<SystemMessageToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.standard,
    );

    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Auto-dismiss based on priority
    if (widget.message.priority != SystemMessagePriority.critical) {
      Future.delayed(widget.message.priority.displayDuration, () {
        if (mounted) {
          _dismiss();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  Color _getCategoryColor() {
    switch (widget.message.category) {
      case SystemMessageCategory.mission:
        return AppColors.accentAmber;
      case SystemMessageCategory.recovery:
        return AppColors.accentBlue;
      case SystemMessageCategory.progress:
        return AppColors.accentCyan;
      case SystemMessageCategory.achievement:
        return AppColors.accentViolet;
      case SystemMessageCategory.system:
        return AppColors.textSecondary;
      case SystemMessageCategory.warning:
        return AppColors.accentWarning;
      case SystemMessageCategory.success:
        return AppColors.accentSuccess;
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.message.category) {
      case SystemMessageCategory.mission:
        return Icons.flag_outlined;
      case SystemMessageCategory.recovery:
        return Icons.bedtime_outlined;
      case SystemMessageCategory.progress:
        return Icons.trending_up;
      case SystemMessageCategory.achievement:
        return Icons.emoji_events_outlined;
      case SystemMessageCategory.system:
        return Icons.psychology_outlined;
      case SystemMessageCategory.warning:
        return Icons.warning_amber_outlined;
      case SystemMessageCategory.success:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0,
              MediaQuery.of(context).size.height * _slideAnimation.value * 0.1),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: HolographicContainer(
          borderRadius: AppSpacing.radiusMd,
          glowColor: color,
          glowIntensity:
              widget.message.priority == SystemMessagePriority.critical
                  ? 0.5
                  : 0.2,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  widget.message.actionKey != null ? widget.onAction : _dismiss,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                        color: color.withOpacity(0.2),
                      ),
                      child: Icon(
                        _getCategoryIcon(),
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.message.category.label,
                                style: AppTypography.labelSmall.copyWith(
                                  color: color,
                                  letterSpacing: 1,
                                ),
                              ),
                              if (widget.message.priority ==
                                      SystemMessagePriority.high ||
                                  widget.message.priority ==
                                      SystemMessagePriority.critical) ...[
                                const SizedBox(width: AppSpacing.xs),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.xs,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: color.withOpacity(0.3),
                                  ),
                                  child: Text(
                                    widget.message.priority.label,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: color,
                                      fontSize: 9,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            widget.message.title,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.message.body,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Actions
                    if (widget.message.actionLabel != null) ...[
                      TextButton(
                        onPressed: widget.onAction,
                        child: Text(
                          widget.message.actionLabel!,
                          style: AppTypography.labelSmall.copyWith(
                            color: color,
                          ),
                        ),
                      ),
                    ] else ...[
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                        onPressed: _dismiss,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Toast overlay manager for showing system messages.
class SystemMessageToastManager extends StatelessWidget {
  const SystemMessageToastManager({
    super.key,
    required this.child,
    required this.messages,
    required this.onDismiss,
    required this.onAction,
  });

  final Widget child;
  final List<SystemMessage> messages;
  final void Function(String id) onDismiss;
  final void Function(SystemMessage message) onAction;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        // Toast notifications at the top
        Positioned(
          top: MediaQuery.of(context).padding.top + AppSpacing.md,
          left: 0,
          right: 0,
          child: Column(
            children: messages
                .take(3)
                .map((message) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: SystemMessageToast(
                        message: message,
                        onDismiss: () => onDismiss(message.id),
                        onAction: () => onAction(message),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
