import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Missions page showing active, daily, and weekly missions.
class MissionsPage extends ConsumerWidget {
  const MissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              title: Text(
                'MISSIONS',
                style: AppTypography.headingLarge.copyWith(letterSpacing: 2),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Mission filters
                  const _MissionFilters(),
                  const SizedBox(height: AppSpacing.xxl),

                  // Daily missions
                  const _MissionSection(
                    title: 'DAILY MISSIONS',
                    missions: _dailyMissions,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Weekly missions
                  const _MissionSection(
                    title: 'WEEKLY MISSIONS',
                    missions: _weeklyMissions,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Boss missions
                  const _MissionSection(
                    title: 'BOSS CHALLENGES',
                    missions: _bossMissions,
                    isBoss: true,
                  ),
                  const SizedBox(height: AppSpacing.huge),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionFilters extends StatelessWidget {
  const _MissionFilters();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(label: 'All', isSelected: true),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(label: 'Daily'),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(label: 'Weekly'),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(label: 'Active'),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(label: 'Completed'),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        gradient: isSelected ? AppColors.energyActive : null,
        color: isSelected ? null : AppColors.surfaceGlass,
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : AppColors.borderAccent.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: isSelected
              ? AppColors.backgroundPrimary
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _MissionSection extends StatelessWidget {
  const _MissionSection({
    required this.title,
    required this.missions,
    this.isBoss = false,
  });

  final String title;
  final List<_MissionData> missions;
  final bool isBoss;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.labelMedium.copyWith(
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...missions.map((mission) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _MissionCard(mission: mission, isBoss: isBoss),
            )),
      ],
    );
  }
}

class _MissionData {
  const _MissionData({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.xp,
    required this.reward,
    required this.timeRemaining,
    required this.progress,
    required this.status,
  });

  final String title;
  final String description;
  final String difficulty;
  final String xp;
  final String reward;
  final String timeRemaining;
  final double progress;
  final String status;
}

const _dailyMissions = [
  _MissionData(
    title: 'Morning Protocol',
    description: 'Complete 30 min cardio',
    difficulty: 'EASY',
    xp: '+100 XP',
    reward: '+25 Energy',
    timeRemaining: '8:30:00',
    progress: 0.0,
    status: 'Available',
  ),
  _MissionData(
    title: 'Strength Foundation',
    description: 'Complete 3 strength exercises',
    difficulty: 'MEDIUM',
    xp: '+150 XP',
    reward: '+50 Strength',
    timeRemaining: '8:30:00',
    progress: 0.33,
    status: 'In Progress',
  ),
];

const _weeklyMissions = [
  _MissionData(
    title: 'Consistency Protocol',
    description: 'Train 5 days this week',
    difficulty: 'MEDIUM',
    xp: '+500 XP',
    reward: 'Legendary Title',
    timeRemaining: '4d 12h',
    progress: 0.4,
    status: 'In Progress',
  ),
];

const _bossMissions = [
  _MissionData(
    title: 'The Iron Gauntlet',
    description: 'Complete 1000 push-ups',
    difficulty: 'EXTREME',
    xp: '+2000 XP',
    reward: 'Mythic Armor Set',
    timeRemaining: '7d',
    progress: 0.15,
    status: 'Active',
  ),
];

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.mission, this.isBoss = false});

  final _MissionData mission;
  final bool isBoss;

  Color get _difficultyColor {
    switch (mission.difficulty) {
      case 'EASY':
        return AppColors.accentSuccess;
      case 'MEDIUM':
        return AppColors.accentAmber;
      case 'HARD':
        return AppColors.accentWarning;
      case 'EXTREME':
        return AppColors.accentError;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusLg,
      glowColor: isBoss ? AppColors.accentError : AppColors.accentViolet,
      glowIntensity: isBoss ? 0.35 : 0.2,
      enableScanline: isBoss,
      child: InkWell(
        onTap: () => context.push('/missions/${mission.title.hashCode}'),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
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
                      color: _difficultyColor.withOpacity(0.2),
                      border: Border.all(
                        color: _difficultyColor.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      mission.difficulty,
                      style: AppTypography.labelSmall.copyWith(
                        color: _difficultyColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    mission.timeRemaining,
                    style: AppTypography.numericSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                mission.title,
                style: AppTypography.headingMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                mission.description,
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Progress bar
              if (mission.progress > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mission.status,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.accentCyan,
                      ),
                    ),
                    Text(
                      '${(mission.progress * 100).toInt()}%',
                      style: AppTypography.numericSmall.copyWith(
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: AppColors.surfaceGlass,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: mission.progress,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.energyActive,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Rewards
              Row(
                children: [
                  _RewardChip(icon: Icons.bolt, label: mission.xp),
                  const SizedBox(width: AppSpacing.sm),
                  _RewardChip(icon: Icons.star, label: mission.reward),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardChip extends StatelessWidget {
  const _RewardChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        color: AppColors.accentAmber.withOpacity(0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.accentAmber),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.accentAmber,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mission detail page placeholder
class MissionDetailPage extends StatelessWidget {
  const MissionDetailPage({super.key, required this.missionId});

  final String missionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Details'),
      ),
      body: Center(
        child: Text('Mission: $missionId'),
      ),
    );
  }
}
