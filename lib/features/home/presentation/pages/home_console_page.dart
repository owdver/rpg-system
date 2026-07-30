import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/domain/models/models.dart';
import '../../../../core/domain/services/services.dart';
import '../../../../core/services/haptic_manager.dart';
import '../../../../core/shared/widgets/holographic_container.dart';
import '../../../../core/shared/widgets/holo_stat_bar.dart';

/// Production Home Console - integrates all game systems.
class HomeConsolePage extends ConsumerStatefulWidget {
  const HomeConsolePage({super.key});

  @override
  ConsumerState<HomeConsolePage> createState() => _HomeConsolePageState();
}

class _HomeConsolePageState extends ConsumerState<HomeConsolePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameEngineProvider);
    final xpState = gameState.xpState;
    final recovery = gameState.recovery;
    final activeMission = gameState.activeMission;
    final recentEvents = gameState.recentEvents.take(5).toList();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated background
          const _AnimatedBackground(),

          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: _SystemHeader(
                    title: gameState.progression.displayTitle,
                    level: xpState.level,
                    rank: RankTierExtension.fromLevel(xpState.level),
                  ),
                  actions: [
                    _NotificationBadge(
                      onTap: () => _showNotifications(context, recentEvents),
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
                      // AI Daily Evaluation
                      _AIEvaluationCard(
                        coachState: ref.watch(aiCoachProvider),
                        onRefresh: () => _refreshEvaluation(),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Mission Brief
                      if (activeMission != null)
                        _MissionBriefCard(mission: activeMission),
                      const SizedBox(height: AppSpacing.xxl),

                      // XP Progress
                      CinematicXPBar(
                        currentXP: xpState.totalXP,
                        xpToNextLevel: xpState.xpToNextLevel,
                        level: xpState.level,
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Quick Stats
                      _QuickStatsRow(
                        xpState: xpState,
                        rank: RankTierExtension.fromLevel(xpState.level),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Recovery Index
                      _RecoveryIndexCard(recovery: recovery),
                      const SizedBox(height: AppSpacing.xxl),

                      // Quick Actions
                      _QuickActionsGrid(
                        onStartWorkout: () => context.push(AppRoutes.training),
                        onViewMissions: () => context.push(AppRoutes.missions),
                        onViewProgress: () => context.push(AppRoutes.progress),
                        onViewSkills: () => context.push('/skills'),
                        onBossArena: () => context.push('/boss'),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Recent Activity
                      _RecentActivityFeed(events: recentEvents),
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

  void _refreshEvaluation() {
    ref.read(aiCoachProvider.notifier).evaluateDaily();
    ref.read(hapticManagerProvider).doubleTap();
  }

  void _showNotifications(BuildContext context, List<SystemEvent> events) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _NotificationsSheet(events: events),
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.ambientBackground,
      ),
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: _GridPainter(),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentCyan.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 60.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SystemHeader extends StatelessWidget {
  const _SystemHeader({
    required this.title,
    required this.level,
    required this.rank,
  });

  final String title;
  final int level;
  final RankTier rank;

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
          child: Center(
            child: Text(
              rank.label,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.backgroundPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SYSTEM ACTIVE',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 2,
              ),
            ),
            Row(
              children: [
                Text(
                  title,
                  style: AppTypography.headingSmall,
                ),
                const SizedBox(width: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    color: AppColors.accentCyan.withOpacity(0.2),
                  ),
                  child: Text(
                    'LV.$level',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.accentCyan,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge({required this.onTap});

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

class _AIEvaluationCard extends StatelessWidget {
  const _AIEvaluationCard({
    required this.coachState,
    required this.onRefresh,
  });

  final AICoachState coachState;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final lastEval = coachState.lastEvaluation;

    return HolographicContainer(
      borderRadius: AppSpacing.radiusLg,
      glowColor: AppColors.accentCyan,
      glowIntensity: 0.2,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    color: AppColors.accentCyan.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: AppColors.accentCyan,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'AI EVALUATION',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accentCyan,
                    letterSpacing: 2,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18),
                  color: AppColors.textSecondary,
                  onPressed: onRefresh,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (lastEval != null) ...[
              Text(
                lastEval.title,
                style: AppTypography.headingMedium.copyWith(
                  color: _getPriorityColor(lastEval.priority),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                lastEval.message,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ] else ...[
              Text(
                'Initializing...',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(CoachPriority priority) {
    switch (priority) {
      case CoachPriority.critical:
        return AppColors.accentError;
      case CoachPriority.high:
        return AppColors.accentWarning;
      case CoachPriority.normal:
        return AppColors.accentCyan;
      case CoachPriority.low:
        return AppColors.textSecondary;
    }
  }
}

class _MissionBriefCard extends StatelessWidget {
  const _MissionBriefCard({required this.mission});

  final Mission mission;

  @override
  Widget build(BuildContext context) {
    final timeRemaining = mission.timeRemaining;
    final timeText = timeRemaining != null
        ? '${timeRemaining.inHours}h remaining'
        : 'No deadline';

    return HolographicContainer(
      borderRadius: AppSpacing.radiusLg,
      glowColor: _getDifficultyColor(mission.difficulty),
      glowIntensity: 0.15,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/mission/${mission.id}'),
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
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                        color: _getDifficultyColor(mission.difficulty)
                            .withOpacity(0.2),
                      ),
                      child: Text(
                        mission.difficulty.label.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          color: _getDifficultyColor(mission.difficulty),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                        color: AppColors.accentViolet.withOpacity(0.2),
                      ),
                      child: Text(
                        mission.category.label.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.accentViolet,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '+${mission.xpReward} XP',
                      style: AppTypography.numericSmall.copyWith(
                        color: AppColors.accentCyan,
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
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: LinearProgressIndicator(
                    value: mission.progress,
                    backgroundColor: AppColors.surfaceGlass,
                    valueColor: AlwaysStoppedAnimation(
                      _getDifficultyColor(mission.difficulty),
                    ),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(mission.progress * 100).toInt()}% complete',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    Text(
                      timeText,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(MissionDifficulty difficulty) {
    switch (difficulty) {
      case MissionDifficulty.trivial:
        return AppColors.textSecondary;
      case MissionDifficulty.easy:
        return AppColors.accentSuccess;
      case MissionDifficulty.medium:
        return AppColors.accentBlue;
      case MissionDifficulty.hard:
        return AppColors.accentWarning;
      case MissionDifficulty.extreme:
        return AppColors.accentError;
      case MissionDifficulty.legendary:
        return AppColors.accentPurple;
    }
  }
}

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow({
    required this.xpState,
    required this.rank,
  });

  final XPState xpState;
  final RankTier rank;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'STREAK',
            value: '${xpState.streakDays}',
            icon: Icons.local_fire_department,
            color: AppColors.accentWarning,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            label: 'RANK',
            value: rank.label,
            icon: Icons.military_tech,
            color: AppColors.accentViolet,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            label: 'TOTAL XP',
            value: '${xpState.totalXP}',
            icon: Icons.stars,
            color: AppColors.accentCyan,
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

class _RecoveryIndexCard extends StatelessWidget {
  const _RecoveryIndexCard({required this.recovery});

  final RecoveryState recovery;

  @override
  Widget build(BuildContext context) {
    final level = recovery.level;
    final metrics = recovery.metrics;

    return HolographicContainer(
      borderRadius: AppSpacing.radiusLg,
      glowColor: Color(level.colorValue),
      glowIntensity: 0.2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    color: Color(level.colorValue).withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Color(level.colorValue),
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECOVERY INDEX',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      level.label.toUpperCase(),
                      style: AppTypography.headingSmall.copyWith(
                        color: Color(level.colorValue),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${recovery.readinessScore.toInt()}%',
                  style: AppTypography.numericLarge.copyWith(
                    color: Color(level.colorValue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Metrics row
            Row(
              children: [
                _RecoveryMetric(
                  label: 'Sleep',
                  value: '${metrics.sleepHours.toStringAsFixed(1)}h',
                  color: AppColors.accentBlue,
                ),
                _VerticalDivider(),
                _RecoveryMetric(
                  label: 'HRV',
                  value: '${metrics.hrvValue}',
                  color: AppColors.accentViolet,
                ),
                _VerticalDivider(),
                _RecoveryMetric(
                  label: 'HR',
                  value: '${metrics.restingHeartRate}',
                  color: AppColors.accentError,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              level.recommendation,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
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
            style: AppTypography.numericMedium.copyWith(color: color),
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
      height: 30,
      color: AppColors.borderSubtle,
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.onStartWorkout,
    required this.onViewMissions,
    required this.onViewProgress,
    required this.onViewSkills,
    required this.onBossArena,
  });

  final VoidCallback onStartWorkout;
  final VoidCallback onViewMissions;
  final VoidCallback onViewProgress;
  final VoidCallback onViewSkills;
  final VoidCallback onBossArena;

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
                icon: Icons.play_arrow,
                label: 'Start\nWorkout',
                color: AppColors.accentSuccess,
                onTap: onStartWorkout,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.assignment,
                label: 'View\nMissions',
                color: AppColors.accentCyan,
                onTap: onViewMissions,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.bar_chart,
                label: 'View\nProgress',
                color: AppColors.accentViolet,
                onTap: onViewProgress,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.account_tree,
                label: 'Skill\nTree',
                color: AppColors.accentWarning,
                onTap: onViewSkills,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.whatshot,
                label: 'Boss\nArena',
                color: AppColors.accentPurple,
                onTap: onBossArena,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.inventory_2,
                label: 'Inventory',
                color: AppColors.accentBlue,
                onTap: () => context.push(AppRoutes.inventory),
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
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTypography.labelSmall.copyWith(
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

class _RecentActivityFeed extends StatelessWidget {
  const _RecentActivityFeed({required this.events});

  final List<SystemEvent> events;

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
        if (events.isEmpty)
          Center(
            child: Text(
              'No recent activity',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          )
        else
          ...events.map((event) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _ActivityItem(event: event),
              )),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.event});

  final SystemEvent event;

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
              color: _getEventColor(event.type).withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                event.type.icon,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTypography.labelLarge,
                ),
                Text(
                  event.body,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatTime(event.timestamp),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getEventColor(SystemEventType type) {
    switch (type) {
      case SystemEventType.levelUp:
      case SystemEventType.rankUp:
        return AppColors.accentWarning;
      case SystemEventType.achievementUnlocked:
        return AppColors.accentPurple;
      case SystemEventType.missionCompleted:
        return AppColors.accentSuccess;
      case SystemEventType.workoutFinished:
        return AppColors.accentCyan;
      case SystemEventType.recoveryUpdated:
        return AppColors.accentBlue;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet({required this.events});

  final List<SystemEvent> events;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: AppColors.borderSubtle,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Text(
                  'NOTIFICATIONS',
                  style: AppTypography.labelMedium.copyWith(
                    letterSpacing: 2,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Clear All',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.accentError,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text(
                      'No notifications',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: events.length,
                    itemBuilder: (context, index) => _NotificationItem(
                      event: events[index],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({required this.event});

  final SystemEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: AppColors.surfaceGlass,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Text(event.type.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTypography.labelLarge,
                ),
                Text(
                  event.body,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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
