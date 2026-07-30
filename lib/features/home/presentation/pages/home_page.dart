import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/auth_provider.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/services/haptic_manager.dart';
import '../../../../core/shared/widgets/widgets.dart';

/// Home screen - the primary command surface with dynamic background.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dynamic holographic background
          const DynamicBackground(),

          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // System header
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: _SystemHeader(userName: user?.displayName ?? 'Operative'),
                  actions: [
                    _NotificationButton(
                      onTap: () {
                        ref.read(hapticManagerProvider).lightTap();
                        // Show notifications
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      color: AppColors.textSecondary,
                      onPressed: () {
                        ref.read(hapticManagerProvider).lightTap();
                        context.push(AppRoutes.settings);
                      },
                    ),
                  ],
                ),

                // Main content
                SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Welcome message
                      const _WelcomeSection(),
                      const SizedBox(height: AppSpacing.xxl),

                      // Mission brief
                      MissionBriefWindow(
                        title: 'Daily Endurance Challenge',
                        description: 'Complete a 30-minute cardio session to earn bonus XP.',
                        difficulty: MissionDifficulty.medium,
                        xpReward: 250,
                        timeRemaining: const Duration(hours: 12),
                        onAccept: () {
                          ref.read(hapticManagerProvider).doubleTap();
                        },
                        onViewDetails: () {},
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Status overview with XP
                      CinematicXPBar(
                        currentXP: 1250,
                        xpToNextLevel: 2000,
                        level: 7,
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Stats row
                      const _StatsRow(),
                      const SizedBox(height: AppSpacing.xxl),

                      // Recovery card
                      RecoveryIndexCard(
                        readinessScore: 78,
                        sleepHours: 7.5,
                        hrvValue: 45,
                        restingHR: 62,
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Quick actions
                      const _QuickActionsSection(),
                      const SizedBox(height: AppSpacing.xxl),

                      // Recent activity
                      const _RecentActivitySection(),
                      const SizedBox(height: AppSpacing.huge),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemHeader extends StatelessWidget {
  const _SystemHeader({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            gradient: AppColors.energyActive,
          ),
          child: const Icon(
            Icons.psychology,
            color: AppColors.backgroundPrimary,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SYSTEM',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 2,
              ),
            ),
            Text(
              userName,
              style: AppTypography.headingSmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.textSecondary,
          onPressed: onTap,
        ),
        // Notification badge
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentError,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'STREAK',
            value: '7',
            icon: Icons.local_fire_department,
            color: AppColors.accentWarning,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            label: 'RANK',
            value: 'E-5',
            icon: Icons.military_tech,
            color: AppColors.accentViolet,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            label: 'ACTIVE',
            value: '5/7',
            icon: Icons.calendar_today,
            color: AppColors.accentSuccess,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
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
            Icon(icon, color: color, size: 20),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: AppTypography.headingSmall.copyWith(color: color),
            ),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 6) {
      greeting = 'OPERATIVE ACTIVE';
    } else if (hour < 12) {
      greeting = 'GOOD MORNING';
    } else if (hour < 17) {
      greeting = 'GOOD AFTERNOON';
    } else {
      greeting = 'GOOD EVENING';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: AppTypography.displaySmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Your mission awaits.',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatusOverviewSection extends StatelessWidget {
  const _StatusOverviewSection();

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusLg,
      glowColor: AppColors.accentCyan,
      glowIntensity: 0.2,
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
                    color: AppColors.accentSuccess.withOpacity(0.2),
                    border: Border.all(
                      color: AppColors.accentSuccess.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentSuccess,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'ONLINE',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.accentSuccess,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'LEVEL',
                    value: '12',
                    icon: Icons.star_outline,
                    color: AppColors.accentAmber,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatTile(
                    label: 'XP',
                    value: '3.2K',
                    icon: Icons.bolt,
                    color: AppColors.accentCyan,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatTile(
                    label: 'STREAK',
                    value: '7',
                    icon: Icons.local_fire_department,
                    color: AppColors.accentWarning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // XP Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level Progress',
                      style: AppTypography.labelMedium,
                    ),
                    Text(
                      '2,450 / 4,000 XP',
                      style: AppTypography.numericSmall.copyWith(
                        color: AppColors.accentCyan,
                      ),
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
                          widthFactor: 0.61,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.energyActive,
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
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: color.withOpacity(0.1),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.numericLarge.copyWith(color: color),
          ),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentMissionSection extends StatelessWidget {
  const _CurrentMissionSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CURRENT MISSION',
              style: AppTypography.labelMedium.copyWith(
                letterSpacing: 2,
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.missions),
              child: Text(
                'View All',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.accentCyan,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        HolographicContainer(
          borderRadius: AppSpacing.radiusLg,
          glowColor: AppColors.accentViolet,
          glowIntensity: 0.25,
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
                        color: AppColors.accentWarning.withOpacity(0.2),
                        border: Border.all(
                          color: AppColors.accentWarning.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        'MEDIUM',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.accentWarning,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '2:30:00',
                      style: AppTypography.numericMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Morning Cardio Protocol',
                  style: AppTypography.headingMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Complete 30 minutes of cardiovascular training',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    _MissionReward(
                      icon: Icons.bolt,
                      value: '+150 XP',
                      color: AppColors.accentCyan,
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    _MissionReward(
                      icon: Icons.star,
                      value: '+50 Strength',
                      color: AppColors.accentAmber,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push(AppRoutes.workoutSession),
                    child: const Text('BEGIN MISSION'),
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

class _MissionReward extends StatelessWidget {
  const _MissionReward({
    required this.icon,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.labelMedium.copyWith(color: color),
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ACTIONS',
          style: AppTypography.labelMedium.copyWith(
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.fitness_center,
                label: 'Start\nWorkout',
                color: AppColors.accentBlue,
                onTap: () => context.push(AppRoutes.workoutSession),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.self_improvement,
                label: 'Recovery\nMode',
                color: AppColors.accentSuccess,
                onTap: () => context.push(AppRoutes.recovery),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.bar_chart,
                label: 'View\nStats',
                color: AppColors.accentViolet,
                onTap: () => context.push(AppRoutes.progress),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: color,
      glowIntensity: 0.15,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecoveryStatusSection extends StatelessWidget {
  const _RecoveryStatusSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECOVERY STATUS',
              style: AppTypography.labelMedium.copyWith(
                letterSpacing: 2,
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.recovery),
              child: Text(
                'Details',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.accentCyan,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        HolographicContainer(
          borderRadius: AppSpacing.radiusLg,
          glowColor: AppColors.accentSuccess,
          glowIntensity: 0.2,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                _RecoveryMetric(
                  label: 'Readiness',
                  value: '87%',
                  color: AppColors.accentSuccess,
                ),
                _VerticalDivider(),
                _RecoveryMetric(
                  label: 'Sleep',
                  value: '7.5h',
                  color: AppColors.accentBlue,
                ),
                _VerticalDivider(),
                _RecoveryMetric(
                  label: 'HRV',
                  value: 'Good',
                  color: AppColors.accentViolet,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RecoveryMetric extends StatelessWidget {
  const _RecoveryMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.numericLarge.copyWith(color: color),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.borderSubtle,
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT ACTIVITY',
          style: AppTypography.labelMedium.copyWith(
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const _ActivityItem(
          icon: Icons.fitness_center,
          title: 'Strength Training Complete',
          subtitle: 'Upper Body Focus • 45 min',
          time: '2 hours ago',
          xp: '+120 XP',
        ),
        const SizedBox(height: AppSpacing.sm),
        const _ActivityItem(
          icon: Icons.local_fire_department,
          title: 'Streak Extended',
          subtitle: '7 days consecutive training',
          time: 'Today',
          xp: '+50 XP',
        ),
        const SizedBox(height: AppSpacing.sm),
        const _ActivityItem(
          icon: Icons.emoji_events,
          title: 'Achievement Unlocked',
          subtitle: 'Early Bird',
          time: 'Yesterday',
          xp: '',
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.xp,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final String xp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: AppColors.surfaceGlass,
        border: Border.all(
          color: AppColors.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              color: AppColors.accentCyan.withOpacity(0.1),
            ),
            child: Icon(icon, color: AppColors.accentCyan, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLarge),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              if (xp.isNotEmpty)
                Text(
                  xp,
                  style: AppTypography.numericSmall.copyWith(
                    color: AppColors.accentCyan,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
