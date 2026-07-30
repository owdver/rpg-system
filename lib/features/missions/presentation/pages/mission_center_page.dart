import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/domain/models/models.dart';
import '../../../../core/domain/services/services.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Mission Center - Full mission management with tabs.
class MissionCenterPage extends ConsumerStatefulWidget {
  const MissionCenterPage({super.key});

  @override
  ConsumerState<MissionCenterPage> createState() => _MissionCenterPageState();
}

class _MissionCenterPageState extends ConsumerState<MissionCenterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MissionSortOption _sortOption = MissionSortOption.deadline;
  bool _showCompleted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameEngineProvider);
    final missions = _filterMissions(gameState.missions);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.ambientBackground,
        ),
        child: Stack(
          children: [
            const _BackgroundGrid(),
            SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.assignment,
                          color: AppColors.accentCyan,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          'MISSION CENTER',
                          style: AppTypography.headingMedium.copyWith(
                            letterSpacing: 2,
                          ),
                        ),
                        const Spacer(),
                        _SortButton(
                          currentSort: _sortOption,
                          onChanged: (sort) {
                            setState(() => _sortOption = sort);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Tabs
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      color: AppColors.surfaceGlass,
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        gradient: AppColors.energyActive,
                      ),
                      labelColor: AppColors.backgroundPrimary,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: AppTypography.labelSmall,
                      unselectedLabelStyle: AppTypography.labelSmall,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Daily'),
                        Tab(text: 'Weekly'),
                        Tab(text: 'Monthly'),
                        Tab(text: 'Recovery'),
                        Tab(text: 'Boss'),
                        Tab(text: 'Seasonal'),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Mission list
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _MissionList(
                          missions:
                              _getByCategory(missions, MissionCategory.daily),
                          emptyMessage: 'No daily missions available',
                        ),
                        _MissionList(
                          missions:
                              _getByCategory(missions, MissionCategory.weekly),
                          emptyMessage: 'No weekly missions available',
                        ),
                        _MissionList(
                          missions:
                              _getByCategory(missions, MissionCategory.monthly),
                          emptyMessage: 'No monthly missions available',
                        ),
                        _MissionList(
                          missions: _getByCategory(
                              missions, MissionCategory.recovery),
                          emptyMessage: 'No recovery missions available',
                        ),
                        _MissionList(
                          missions:
                              _getByCategory(missions, MissionCategory.boss),
                          emptyMessage: 'No boss missions available',
                        ),
                        _MissionList(
                          missions: _getByCategory(
                              missions, MissionCategory.seasonal),
                          emptyMessage: 'No seasonal missions available',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Mission> _filterMissions(List<Mission> missions) {
    var filtered = missions;

    // Filter completed
    if (!_showCompleted) {
      filtered =
          filtered.where((m) => m.status != MissionStatus.completed).toList();
    }

    // Sort
    switch (_sortOption) {
      case MissionSortOption.deadline:
        filtered.sort((a, b) {
          if (a.deadline == null && b.deadline == null) return 0;
          if (a.deadline == null) return 1;
          if (b.deadline == null) return -1;
          return a.deadline!.compareTo(b.deadline!);
        });
        break;
      case MissionSortOption.difficulty:
        filtered
            .sort((a, b) => b.difficulty.index.compareTo(a.difficulty.index));
        break;
      case MissionSortOption.xpReward:
        filtered.sort((a, b) => b.xpReward.compareTo(a.xpReward));
        break;
      case MissionSortOption.progress:
        filtered.sort((a, b) => b.progress.compareTo(a.progress));
        break;
    }

    return filtered;
  }

  List<Mission> _getByCategory(
      List<Mission> missions, MissionCategory category) {
    return missions.where((m) => m.category == category).toList();
  }
}

enum MissionSortOption {
  deadline,
  difficulty,
  xpReward,
  progress,
}

class _SortButton extends StatelessWidget {
  const _SortButton({
    required this.currentSort,
    required this.onChanged,
  });

  final MissionSortOption currentSort;
  final ValueChanged<MissionSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MissionSortOption>(
      icon: const Icon(Icons.sort, color: AppColors.textSecondary),
      color: AppColors.surfaceGlass,
      onSelected: onChanged,
      itemBuilder: (context) => [
        _buildMenuItem(MissionSortOption.deadline, 'Deadline'),
        _buildMenuItem(MissionSortOption.difficulty, 'Difficulty'),
        _buildMenuItem(MissionSortOption.xpReward, 'XP Reward'),
        _buildMenuItem(MissionSortOption.progress, 'Progress'),
      ],
    );
  }

  PopupMenuItem<MissionSortOption> _buildMenuItem(
    MissionSortOption option,
    String label,
  ) {
    final isSelected = currentSort == option;
    return PopupMenuItem(
      value: option,
      child: Row(
        children: [
          if (isSelected)
            const Icon(Icons.check, size: 16, color: AppColors.accentCyan),
          if (!isSelected) const SizedBox(width: 16),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected ? AppColors.accentCyan : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundGrid extends StatelessWidget {
  const _BackgroundGrid();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _GridPainter(),
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

class _MissionList extends StatelessWidget {
  const _MissionList({
    required this.missions,
    required this.emptyMessage,
  });

  final List<Mission> missions;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (missions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: AppColors.textTertiary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              emptyMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: missions.length,
      itemBuilder: (context, index) {
        final mission = missions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _MissionCard(mission: mission),
        );
      },
    );
  }
}

class _MissionCard extends ConsumerWidget {
  const _MissionCard({required this.mission});

  final Mission mission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = mission.isComplete;
    final isExpired = mission.isExpired;

    return HolographicContainer(
      borderRadius: AppSpacing.radiusLg,
      glowColor: _getDifficultyColor(mission.difficulty),
      glowIntensity: isComplete ? 0.3 : 0.15,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showMissionDetails(context, ref),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
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
                    if (isComplete)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentSuccess.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.accentSuccess,
                          size: 16,
                        ),
                      ),
                    if (isExpired)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentError.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.accentError,
                          size: 16,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Title and description
                Text(
                  mission.title,
                  style: AppTypography.headingMedium.copyWith(
                    decoration: isComplete
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  mission.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Objectives
                ...mission.objectives.map((obj) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        children: [
                          Icon(
                            obj.isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: 16,
                            color: obj.isCompleted
                                ? AppColors.accentSuccess
                                : AppColors.textTertiary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              '${obj.type.label}: ${obj.current}/${obj.target}',
                              style: AppTypography.labelSmall.copyWith(
                                color: obj.isCompleted
                                    ? AppColors.accentSuccess
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Text(
                            '${(obj.progress * 100).toInt()}%',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    )),

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

                const SizedBox(height: AppSpacing.md),

                // Footer
                Row(
                  children: [
                    Icon(
                      Icons.stars,
                      size: 16,
                      color: AppColors.accentCyan,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '+${mission.xpReward} XP',
                      style: AppTypography.numericSmall.copyWith(
                        color: AppColors.accentCyan,
                      ),
                    ),
                    if (mission.statRewards.isNotEmpty) ...[
                      const SizedBox(width: AppSpacing.md),
                      Icon(
                        Icons.trending_up,
                        size: 16,
                        color: AppColors.accentSuccess,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        mission.statRewards.entries
                            .map((e) => '${e.key}+${e.value.toInt()}')
                            .join(', '),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.accentSuccess,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (mission.timeRemaining != null)
                      Text(
                        _formatDuration(mission.timeRemaining!),
                        style: AppTypography.labelSmall.copyWith(
                          color: _getTimeColor(mission.timeRemaining!),
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

  void _showMissionDetails(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _MissionDetailsSheet(mission: mission),
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

  Color _getTimeColor(Duration remaining) {
    if (remaining.inHours < 2) return AppColors.accentError;
    if (remaining.inHours < 12) return AppColors.accentWarning;
    return AppColors.textTertiary;
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d left';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h left';
    } else {
      return '${duration.inMinutes}m left';
    }
  }
}

class _MissionDetailsSheet extends StatelessWidget {
  const _MissionDetailsSheet({required this.mission});

  final Mission mission;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: AppTypography.headingLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    mission.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Objectives
                  Text(
                    'OBJECTIVES',
                    style: AppTypography.labelMedium.copyWith(
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...mission.objectives
                      .map((obj) => _ObjectiveItem(objective: obj)),

                  const SizedBox(height: AppSpacing.xxl),

                  // Rewards
                  Text(
                    'REWARDS',
                    style: AppTypography.labelMedium.copyWith(
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _RewardCard(
                    icon: Icons.stars,
                    label: 'XP Reward',
                    value: '+${mission.xpReward} XP',
                    color: AppColors.accentCyan,
                  ),
                  if (mission.statRewards.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _RewardCard(
                      icon: Icons.trending_up,
                      label: 'Stat Bonuses',
                      value: mission.statRewards.entries
                          .map((e) => '${e.key}+${e.value.toInt()}')
                          .join(', '),
                      color: AppColors.accentSuccess,
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xxl),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: mission.isComplete
                          ? () => Navigator.pop(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentCyan,
                        foregroundColor: AppColors.backgroundPrimary,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: Text(
                        mission.isComplete ? 'CLAIM REWARDS' : 'IN PROGRESS',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.backgroundPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ObjectiveItem extends StatelessWidget {
  const _ObjectiveItem({required this.objective});

  final MissionObjective objective;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: objective.isCompleted
                  ? AppColors.accentSuccess.withOpacity(0.2)
                  : AppColors.surfaceGlass,
            ),
            child: Icon(
              objective.isCompleted
                  ? Icons.check
                  : Icons.radio_button_unchecked,
              color: objective.isCompleted
                  ? AppColors.accentSuccess
                  : AppColors.textTertiary,
              size: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  objective.type.label,
                  style: AppTypography.labelLarge,
                ),
                Text(
                  '${objective.current}/${objective.target}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${(objective.progress * 100).toInt()}%',
            style: AppTypography.numericMedium.copyWith(
              color: objective.isCompleted
                  ? AppColors.accentSuccess
                  : AppColors.accentCyan,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
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
              color: color.withOpacity(0.2),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                Text(
                  value,
                  style: AppTypography.labelLarge.copyWith(
                    color: color,
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
