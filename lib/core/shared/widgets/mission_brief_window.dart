import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_typography.dart';
import 'holographic_container.dart';

/// Mission difficulty levels.
enum MissionDifficulty {
  trivial,
  easy,
  medium,
  hard,
  extreme,
  legendary,
}

extension MissionDifficultyExtension on MissionDifficulty {
  String get label {
    switch (this) {
      case MissionDifficulty.trivial:
        return 'TRIVIAL';
      case MissionDifficulty.easy:
        return 'EASY';
      case MissionDifficulty.medium:
        return 'MEDIUM';
      case MissionDifficulty.hard:
        return 'HARD';
      case MissionDifficulty.extreme:
        return 'EXTREME';
      case MissionDifficulty.legendary:
        return 'LEGENDARY';
    }
  }

  Color get color {
    switch (this) {
      case MissionDifficulty.trivial:
        return AppColors.textMuted;
      case MissionDifficulty.easy:
        return AppColors.accentSuccess;
      case MissionDifficulty.medium:
        return AppColors.accentCyan;
      case MissionDifficulty.hard:
        return AppColors.accentAmber;
      case MissionDifficulty.extreme:
        return AppColors.accentError;
      case MissionDifficulty.legendary:
        return AppColors.accentViolet;
    }
  }
}

/// Mission brief window - displays current mission details.
class MissionBriefWindow extends StatelessWidget {
  const MissionBriefWindow({
    super.key,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.xpReward,
    this.timeRemaining,
    this.onAccept,
    this.onViewDetails,
    this.isCompact = false,
  });

  final String title;
  final String description;
  final MissionDifficulty difficulty;
  final int xpReward;
  final Duration? timeRemaining;
  final VoidCallback? onAccept;
  final VoidCallback? onViewDetails;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildCompact(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: difficulty.color,
      glowIntensity: 0.2,
      child: InkWell(
        onTap: onViewDetails,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  gradient: LinearGradient(
                    colors: [
                      difficulty.color.withOpacity(0.3),
                      difficulty.color.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(
                    color: difficulty.color.withOpacity(0.5),
                  ),
                ),
                child: Icon(
                  Icons.flag_outlined,
                  color: difficulty.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        _DifficultyBadge(difficulty: difficulty, small: true),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '+$xpReward XP',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.accentAmber,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFull(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusLg,
      glowColor: difficulty.color,
      glowIntensity: 0.25,
      enableScanline: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    color: difficulty.color.withOpacity(0.2),
                    border: Border.all(
                      color: difficulty.color.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    'ACTIVE MISSION',
                    style: AppTypography.labelSmall.copyWith(
                      color: difficulty.color,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const Spacer(),
                if (timeRemaining != null)
                  _TimeRemainingDisplay(time: timeRemaining!),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Title
            Text(
              title,
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Description
            Text(
              description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Stats row
            Row(
              children: [
                _DifficultyBadge(difficulty: difficulty),
                const SizedBox(width: AppSpacing.md),
                _XPRewardBadge(xp: xpReward),
                const Spacer(),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Actions
            Row(
              children: [
                if (onViewDetails != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onViewDetails,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.borderSubtle),
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      ),
                      child: Text(
                        'DETAILS',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                if (onViewDetails != null && onAccept != null)
                  const SizedBox(width: AppSpacing.md),
                if (onAccept != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: difficulty.color,
                        foregroundColor: AppColors.backgroundPrimary,
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      ),
                      child: Text(
                        'ACCEPT',
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty, this.small = false});

  final MissionDifficulty difficulty;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? AppSpacing.xs : AppSpacing.sm,
        vertical: small ? 2 : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        color: difficulty.color.withOpacity(0.15),
        border: Border.all(
          color: difficulty.color.withOpacity(0.4),
        ),
      ),
      child: Text(
        difficulty.label,
        style: (small ? AppTypography.labelSmall : AppTypography.labelMedium)
            .copyWith(
          color: difficulty.color,
          fontSize: small ? 10 : null,
        ),
      ),
    );
  }
}

class _XPRewardBadge extends StatelessWidget {
  const _XPRewardBadge({required this.xp});

  final int xp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        color: AppColors.accentAmber.withOpacity(0.15),
        border: Border.all(
          color: AppColors.accentAmber.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 14,
            color: AppColors.accentAmber,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '+$xp XP',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.accentAmber,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeRemainingDisplay extends StatelessWidget {
  const _TimeRemainingDisplay({required this.time});

  final Duration time;

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUrgent = time.inHours < 1;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        color: (isUrgent ? AppColors.accentError : AppColors.accentCyan)
            .withOpacity(0.15),
        border: Border.all(
          color: (isUrgent ? AppColors.accentError : AppColors.accentCyan)
              .withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 14,
            color: isUrgent ? AppColors.accentError : AppColors.accentCyan,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            _formatDuration(time),
            style: AppTypography.labelSmall.copyWith(
              color: isUrgent ? AppColors.accentError : AppColors.accentCyan,
            ),
          ),
        ],
      ),
    );
  }
}
