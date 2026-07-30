import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/domain/models/models.dart';
import '../../../../core/domain/services/services.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Progress page showing stats, history, and charts.
class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameEngineProvider);
    final xpState = gameState.xpState;
    final workouts = gameState.workoutHistory;
    final missions = gameState.missions;

    final totalWorkouts = workouts.length;
    final completedMissions = missions.where((m) => m.status == MissionStatus.completed).length;
    final totalMinutes = workouts.fold<int>(0, (sum, w) => sum + w.duration.inMinutes);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.ambientBackground,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                title: Row(
                  children: [
                    const Icon(Icons.trending_up, color: AppColors.accentViolet),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'PROGRESS',
                      style: AppTypography.headingLarge.copyWith(letterSpacing: 2),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Level & XP
                    _LevelProgressSection(xpState: xpState),
                    const SizedBox(height: AppSpacing.xxl),

                    // Stats overview
                    _StatsOverviewSection(
                      totalXP: xpState.totalXP,
                      workouts: totalWorkouts,
                      missions: completedMissions,
                      minutes: totalMinutes,
                      days: xpState.streakDays,
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Capability stats
                    _CapabilityStatsSection(stats: gameState.userStats),
                    const SizedBox(height: AppSpacing.xxl),

                    // Weekly activity
                    _WeeklyActivitySection(workouts: workouts),
                    const SizedBox(height: AppSpacing.xxl),

                    // Personal records
                    const _PersonalRecordsSection(),
                    const SizedBox(height: AppSpacing.huge),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelProgressSection extends StatelessWidget {
  const _LevelProgressSection({required this.xpState});

  final XPState xpState;

  @override
  Widget build(BuildContext context) {
    final rank = RankTierExtension.fromLevel(xpState.level);

    return HolographicContainer(
      borderRadius: AppSpacing.radiusLg,
      glowColor: AppColors.accentAmber,
      glowIntensity: 0.25,
      enableScanline: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    gradient: AppColors.progressionRare,
                  ),
                  child: Center(
                    child: Text(
                      '${xpState.level}',
                      style: AppTypography.displayMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LEVEL', style: AppTypography.labelSmall),
                      Text(rank.fullName.toUpperCase(), style: AppTypography.headingMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        rank.label,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.accentViolet,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progress to Level ${xpState.level + 1}', style: AppTypography.labelMedium),
                Text(
                  '${xpState.totalXP} / ${xpState.totalXP + xpState.xpToNextLevel} XP',
                  style: AppTypography.numericSmall.copyWith(
                    color: AppColors.accentCyan,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.surfaceGlass,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: xpState.levelProgress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.energyActive,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsOverviewSection extends StatelessWidget {
  const _StatsOverviewSection({
    required this.totalXP,
    required this.workouts,
    required this.missions,
    required this.minutes,
    required this.days,
  });

  final int totalXP;
  final int workouts;
  final int missions;
  final int minutes;
  final int days;

  String get _formatXP {
    if (totalXP >= 1000000) {
      return '${(totalXP / 1000000).toStringAsFixed(1)}M';
    } else if (totalXP >= 1000) {
      return '${(totalXP / 1000).toStringAsFixed(1)}K';
    }
    return '$totalXP';
  }

  String get _formatMinutes {
    if (minutes >= 60) {
      return '${(minutes / 60).toStringAsFixed(1)}h';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatOverviewCard(
                label: 'Total XP',
                value: _formatXP,
                icon: Icons.bolt,
                color: AppColors.accentCyan,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatOverviewCard(
                label: 'Workouts',
                value: '$workouts',
                icon: Icons.fitness_center,
                color: AppColors.accentBlue,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatOverviewCard(
                label: 'Missions',
                value: '$missions',
                icon: Icons.flag,
                color: AppColors.accentAmber,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _StatOverviewCard(
                label: 'Training Time',
                value: _formatMinutes,
                icon: Icons.timer,
                color: AppColors.accentSuccess,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatOverviewCard(
                label: 'Streak Days',
                value: '$days',
                icon: Icons.local_fire_department,
                color: AppColors.accentViolet,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}

class _StatOverviewCard extends StatelessWidget {
  const _StatOverviewCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: color,
      glowIntensity: 0.15,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: AppTypography.numericMedium.copyWith(color: color),
            ),
            Text(label, style: AppTypography.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _CapabilityStatsSection extends StatelessWidget {
  const _CapabilityStatsSection({required this.stats});

  final UserStats stats;

  Color _getStatColor(PrimaryStat stat) {
    switch (stat) {
      case PrimaryStat.strength:
        return AppColors.accentError;
      case PrimaryStat.endurance:
        return AppColors.accentCyan;
      case PrimaryStat.recovery:
        return AppColors.accentSuccess;
      case PrimaryStat.mobility:
        return AppColors.accentViolet;
      case PrimaryStat.focus:
        return AppColors.accentAmber;
      case PrimaryStat.precision:
        return AppColors.accentBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CAPABILITY LEVELS',
          style: AppTypography.labelMedium.copyWith(letterSpacing: 2),
        ),
        const SizedBox(height: AppSpacing.md),
        ...PrimaryStat.values.map((stat) {
          final value = stats.getStat(stat);
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _CapabilityBar(
              label: stat.label,
              value: value.current.round(),
              maxValue: value.max.round(),
              color: _getStatColor(stat),
            ),
          );
        }),
      ],
    );
  }
}

class _CapabilityBar extends StatelessWidget {
  const _CapabilityBar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  final String label;
  final int value;
  final int maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: color,
      glowIntensity: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: AppTypography.labelLarge),
                Text(
                  '$value / $maxValue',
                  style: AppTypography.numericSmall.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.surfaceGlass,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: value / maxValue,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyActivitySection extends StatelessWidget {
  const _WeeklyActivitySection({required this.workouts});

  final List<WorkoutSession> workouts;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    // Get workouts for each day of the week
    final weekDays = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final dayWorkouts = <bool>[];
    final dayMinutes = <int>[];

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayWorkoutList = workouts.where((w) {
        return w.startTime.year == day.year &&
            w.startTime.month == day.month &&
            w.startTime.day == day.day;
      }).toList();

      final dayTotalMinutes = dayWorkoutList.fold<int>(0, (sum, w) => sum + w.duration.inMinutes);
      final isActive = dayWorkoutList.isNotEmpty && day.isBefore(now);
      dayWorkouts.add(isActive);
      dayMinutes.add(dayTotalMinutes);
    }

    final totalWorkouts = workouts.where((w) {
      return w.startTime.isAfter(weekStart);
    }).length;
    final totalMinutes = workouts.where((w) => w.startTime.isAfter(weekStart))
        .fold<int>(0, (sum, w) => sum + w.duration.inMinutes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THIS WEEK',
          style: AppTypography.labelMedium.copyWith(letterSpacing: 2),
        ),
        const SizedBox(height: AppSpacing.md),
        HolographicContainer(
          borderRadius: AppSpacing.radiusLg,
          glowColor: AppColors.accentCyan,
          glowIntensity: 0.15,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (i) {
                    return _DayColumn(
                      day: weekDays[i],
                      isActive: dayWorkouts[i],
                      minutes: dayMinutes[i],
                    );
                  }),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    color: AppColors.surfaceGlass,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$totalWorkouts',
                            style: AppTypography.numericLarge.copyWith(
                              color: AppColors.accentCyan,
                            ),
                          ),
                          Text('Workouts', style: AppTypography.labelSmall),
                        ],
                      ),
                      Container(width: 1, height: 40, color: AppColors.borderSubtle),
                      Column(
                        children: [
                          Text(
                            '${totalMinutes ~/ 60}h ${totalMinutes % 60}m',
                            style: AppTypography.numericLarge.copyWith(
                              color: AppColors.accentAmber,
                            ),
                          ),
                          Text('Active Time', style: AppTypography.labelSmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.day,
    required this.isActive,
    required this.minutes,
  });

  final String day;
  final bool isActive;
  final int minutes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isActive ? AppColors.energyActive : null,
            color: isActive ? null : AppColors.surfaceGlass,
          ),
          child: Center(
            child: Text(
              day,
              style: AppTypography.labelMedium.copyWith(
                color: isActive
                    ? AppColors.backgroundPrimary
                    : AppColors.textMuted,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          isActive ? '${minutes}m' : '-',
          style: AppTypography.labelSmall.copyWith(
            color: isActive ? AppColors.accentCyan : AppColors.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _PersonalRecordsSection extends StatelessWidget {
  const _PersonalRecordsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERSONAL RECORDS',
          style: AppTypography.labelMedium.copyWith(letterSpacing: 2),
        ),
        const SizedBox(height: AppSpacing.md),
        const _RecordItem(
          label: 'Longest Workout',
          value: '75 min',
          date: 'Oct 15',
          icon: Icons.timer,
        ),
        const SizedBox(height: AppSpacing.sm),
        const _RecordItem(
          label: 'Most XP in a Day',
          value: '850 XP',
          date: 'Oct 20',
          icon: Icons.bolt,
        ),
        const SizedBox(height: AppSpacing.sm),
        const _RecordItem(
          label: 'Longest Streak',
          value: '14 days',
          date: 'Sep 1-14',
          icon: Icons.local_fire_department,
        ),
      ],
    );
  }
}

class _RecordItem extends StatelessWidget {
  const _RecordItem({
    required this.label,
    required this.value,
    required this.date,
    required this.icon,
  });

  final String label;
  final String value;
  final String date;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: AppColors.surfaceGlass,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              color: AppColors.accentAmber.withOpacity(0.2),
            ),
            child: Icon(icon, color: AppColors.accentAmber, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.labelLarge),
                Text('Set on $date', style: AppTypography.bodySmall),
              ],
            ),
          ),
          Text(
            value,
            style: AppTypography.numericMedium.copyWith(
              color: AppColors.accentAmber,
            ),
          ),
        ],
      ),
    );
  }
}
