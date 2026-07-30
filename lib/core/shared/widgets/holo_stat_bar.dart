import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_typography.dart';
import '../../constants/app_animations.dart';

/// Holographic stat bar with animated fill and glow effect.
class HoloStatBar extends StatelessWidget {
  const HoloStatBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    this.icon,
    this.color,
    this.showPercentage = true,
    this.height = 12,
    this.animate = true,
  });

  final String label;
  final double value;
  final double maxValue;
  final IconData? icon;
  final Color? color;
  final bool showPercentage;
  final double height;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final percentage = maxValue > 0 ? (value / maxValue).clamp(0.0, 1.0) : 0.0;
    final displayColor = color ?? AppColors.accentCyan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: displayColor),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  label.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            if (showPercentage)
              Text(
                '${(percentage * 100).toInt()}%',
                style: AppTypography.labelMedium.copyWith(
                  color: displayColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: AppColors.backgroundTertiary,
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: animate ? AppAnimations.standard : Duration.zero,
                curve: Curves.easeOutCubic,
                width: double.infinity,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height / 2),
                      gradient: LinearGradient(
                        colors: [
                          displayColor.withOpacity(0.8),
                          displayColor,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: displayColor.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Shimmer effect
              if (animate)
                AnimatedContainer(
                  duration: AppAnimations.standard,
                  width: double.infinity,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height / 2),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Cinematic XP bar with level indicator and glow.
class CinematicXPBar extends StatelessWidget {
  const CinematicXPBar({
    super.key,
    required this.currentXP,
    required this.xpToNextLevel,
    required this.level,
    this.height = 16,
  });

  final int currentXP;
  final int xpToNextLevel;
  final int level;
  final double height;

  @override
  Widget build(BuildContext context) {
    final progress = xpToNextLevel > 0 ? currentXP / xpToNextLevel : 0.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    gradient: AppColors.energyActive,
                  ),
                  child: Text(
                    'LVL $level',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.backgroundPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'XP',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            Text(
              '$currentXP / $xpToNextLevel',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.accentCyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: AppColors.backgroundTertiary,
            border: Border.all(
              color: AppColors.borderSubtle,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              AnimatedFractionallySizedBox(
                duration: AppAnimations.standard,
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height / 2),
                    gradient: AppColors.progressionRare,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentViolet.withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              // Animated shine effect
              _ShineEffect(height: height),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShineEffect extends StatefulWidget {
  const _ShineEffect({required this.height});

  final double height;

  @override
  State<_ShineEffect> createState() => _ShineEffectState();
}

class _ShineEffectState extends State<_ShineEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.height / 2),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2 * _controller.value, 0),
              end: Alignment(-0.5 + 2 * _controller.value, 0),
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.3),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// System alert banner for notifications and warnings.
class SystemAlertBanner extends StatelessWidget {
  const SystemAlertBanner({
    super.key,
    required this.message,
    this.type = AlertType.info,
    this.dismissible = true,
    this.onDismiss,
  });

  final String message;
  final AlertType type;
  final bool dismissible;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        gradient: LinearGradient(
          colors: [
            type.color.withOpacity(0.2),
            type.color.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: type.color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            type.icon,
            size: 20,
            color: type.color,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: type.color,
              ),
            ),
          ),
          if (dismissible && onDismiss != null)
            IconButton(
              icon: Icon(
                Icons.close,
                size: 16,
                color: type.color.withOpacity(0.7),
              ),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

enum AlertType {
  info,
  success,
  warning,
  error,
  mission,
}

extension AlertTypeExtension on AlertType {
  Color get color {
    switch (this) {
      case AlertType.info:
        return AppColors.accentCyan;
      case AlertType.success:
        return AppColors.accentSuccess;
      case AlertType.warning:
        return AppColors.accentWarning;
      case AlertType.error:
        return AppColors.accentError;
      case AlertType.mission:
        return AppColors.accentAmber;
    }
  }

  IconData get icon {
    switch (this) {
      case AlertType.info:
        return Icons.info_outline;
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.mission:
        return Icons.flag_outlined;
    }
  }
}
