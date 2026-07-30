import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_typography.dart';
import '../../constants/app_animations.dart';
import 'holographic_container.dart';

/// Recovery status levels.
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
        return 'CRITICAL';
      case RecoveryLevel.poor:
        return 'POOR';
      case RecoveryLevel.fair:
        return 'FAIR';
      case RecoveryLevel.good:
        return 'GOOD';
      case RecoveryLevel.excellent:
        return 'EXCELLENT';
      case RecoveryLevel.optimal:
        return 'OPTIMAL';
    }
  }

  Color get color {
    switch (this) {
      case RecoveryLevel.critical:
        return AppColors.accentError;
      case RecoveryLevel.poor:
        return AppColors.accentAmber;
      case RecoveryLevel.fair:
        return AppColors.accentWarning;
      case RecoveryLevel.good:
        return AppColors.accentCyan;
      case RecoveryLevel.excellent:
        return AppColors.accentSuccess;
      case RecoveryLevel.optimal:
        return AppColors.accentViolet;
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

/// Recovery index card - displays current recovery status.
class RecoveryIndexCard extends StatelessWidget {
  const RecoveryIndexCard({
    super.key,
    required this.readinessScore,
    this.sleepHours,
    this.hrvValue,
    this.restingHR,
    this.onTap,
    this.isCompact = false,
  });

  final double readinessScore; // 0-100
  final double? sleepHours;
  final int? hrvValue;
  final int? restingHR;
  final VoidCallback? onTap;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildCompact(BuildContext context) {
    final level = RecoveryLevelExtension.fromScore(readinessScore);

    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: level.color,
      glowIntensity: 0.2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              _RecoveryGauge(
                score: readinessScore,
                size: 56,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECOVERY',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      level.label,
                      style: AppTypography.headingSmall.copyWith(
                        color: level.color,
                      ),
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
    final level = RecoveryLevelExtension.fromScore(readinessScore);

    return HolographicContainer(
      borderRadius: AppSpacing.radiusLg,
      glowColor: level.color,
      glowIntensity: 0.25,
      enableScanline: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: level.color.withOpacity(0.2),
                    border: Border.all(
                      color: level.color.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    'RECOVERY INDEX',
                    style: AppTypography.labelSmall.copyWith(
                      color: level.color,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _getRecommendation(level),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Main gauge
            Center(
              child: _RecoveryGauge(
                score: readinessScore,
                size: 120,
                showLabel: true,
                level: level,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Metrics row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (sleepHours != null)
                  _MetricItem(
                    icon: Icons.bedtime_outlined,
                    label: 'SLEEP',
                    value: '${sleepHours!.toStringAsFixed(1)}h',
                    color: AppColors.accentViolet,
                  ),
                if (hrvValue != null)
                  _MetricItem(
                    icon: Icons.favorite_outline,
                    label: 'HRV',
                    value: '$hrvValue',
                    color: AppColors.accentSuccess,
                  ),
                if (restingHR != null)
                  _MetricItem(
                    icon: Icons.monitor_heart_outlined,
                    label: 'RHR',
                    value: '$restingHR',
                    color: AppColors.accentCyan,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRecommendation(RecoveryLevel level) {
    switch (level) {
      case RecoveryLevel.critical:
        return 'Rest recommended';
      case RecoveryLevel.poor:
        return 'Light activity only';
      case RecoveryLevel.fair:
        return 'Moderate training';
      case RecoveryLevel.good:
        return 'Normal training';
      case RecoveryLevel.excellent:
        return 'High intensity OK';
      case RecoveryLevel.optimal:
        return 'Peak performance';
    }
  }
}

class _RecoveryGauge extends StatelessWidget {
  const _RecoveryGauge({
    required this.score,
    required this.size,
    this.showLabel = false,
    this.level,
  });

  final double score;
  final double size;
  final bool showLabel;
  final RecoveryLevel? level;

  @override
  Widget build(BuildContext context) {
    final displayLevel = level ?? RecoveryLevelExtension.fromScore(score);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: size / 12,
              backgroundColor: AppColors.backgroundTertiary,
              valueColor: AlwaysStoppedAnimation(
                AppColors.backgroundTertiary,
              ),
            ),
          ),
          // Progress ring
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: score / 100),
              duration: AppAnimations.slow,
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: size / 12,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(displayLevel.color),
                  strokeCap: StrokeCap.round,
                );
              },
            ),
          ),
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${score.toInt()}',
                style: AppTypography.headingLarge.copyWith(
                  color: displayLevel.color,
                  fontSize: size / 2.5,
                  height: 1,
                ),
              ),
              if (showLabel)
                Text(
                  displayLevel.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: displayLevel.color,
                    letterSpacing: 1,
                    fontSize: size / 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            color: color.withOpacity(0.15),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textMuted,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.labelMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
