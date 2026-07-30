import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/domain/models/models.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Skill Tree page - visual skill tree with categories.
class SkillTreePage extends ConsumerStatefulWidget {
  const SkillTreePage({super.key});

  @override
  ConsumerState<SkillTreePage> createState() => _SkillTreePageState();
}

class _SkillTreePageState extends ConsumerState<SkillTreePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.ambientBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    const Icon(Icons.account_tree, color: AppColors.accentWarning),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'SKILL TREE',
                      style: AppTypography.headingMedium.copyWith(
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              // Category tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  color: AppColors.surfaceGlass,
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    color: AppColors.accentWarning.withOpacity(0.3),
                  ),
                  labelColor: AppColors.textPrimary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: AppTypography.labelSmall,
                  unselectedLabelStyle: AppTypography.labelSmall,
                  dividerColor: Colors.transparent,
                  tabs: SkillCategory.values.map((cat) {
                    return Tab(text: cat.label);
                  }).toList(),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Skill content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: SkillCategory.values.map((category) {
                    final skills = SkillTreeCatalog.allSkills
                        .where((s) => s.category == category)
                        .toList();
                    return _SkillCategoryView(
                      category: category,
                      skills: skills,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillCategoryView extends StatelessWidget {
  const _SkillCategoryView({
    required this.category,
    required this.skills,
  });

  final SkillCategory category;
  final List<SkillNode> skills;

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
              color: AppColors.textTertiary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No skills available',
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
      itemCount: skills.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _SkillNodeCard(skill: skills[index]),
        );
      },
    );
  }
}

class _SkillNodeCard extends StatelessWidget {
  const _SkillNodeCard({required this.skill});

  final SkillNode skill;

  @override
  Widget build(BuildContext context) {
    final isUnlocked = skill.isUnlocked;
    final isPurchased = skill.isPurchased;

    return HolographicContainer(
      borderRadius: AppSpacing.radiusLg,
      glowColor: _getGlowColor(),
      glowIntensity: isPurchased ? 0.3 : 0.1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showSkillDetails(context),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        color: _getGlowColor().withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          skill.icon ?? '🔮',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                skill.name,
                                style: AppTypography.headingMedium.copyWith(
                                  color: isUnlocked
                                      ? AppColors.textPrimary
                                      : AppColors.textTertiary,
                                ),
                              ),
                              if (isPurchased) ...[
                                const SizedBox(width: AppSpacing.sm),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.xs,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                    color: AppColors.accentSuccess.withOpacity(0.2),
                                  ),
                                  child: Text(
                                    'OWNED',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.accentSuccess,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            'Tier ${skill.tier}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isPurchased)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          color: AppColors.accentCyan.withOpacity(0.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.stars,
                              size: 14,
                              color: AppColors.accentCyan,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${skill.cost}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.accentCyan,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  skill.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (skill.statBonus.isNotEmpty || skill.xpBonus > 0 || skill.recoveryBonus > 0) ...[
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      ...skill.statBonus.entries.map((e) => _BonusChip(
                            label: '${e.key}+${e.value.toInt()}',
                            color: AppColors.accentSuccess,
                          )),
                      if (skill.xpBonus > 0)
                        _BonusChip(
                          label: 'XP+${(skill.xpBonus * 100).toInt()}%',
                          color: AppColors.accentCyan,
                        ),
                      if (skill.recoveryBonus > 0)
                        _BonusChip(
                          label: 'Recovery+${(skill.recoveryBonus * 100).toInt()}%',
                          color: AppColors.accentBlue,
                        ),
                    ],
                  ),
                ],
                if (!isUnlocked) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      color: AppColors.surfaceGlass,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Unlock at Level ${skill.requiredLevel}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getGlowColor() {
    if (skill.isPurchased) return AppColors.accentSuccess;
    if (skill.isUnlocked) return AppColors.accentWarning;
    return AppColors.textSecondary;
  }

  void _showSkillDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SkillDetailsSheet(skill: skill),
    );
  }
}

class _BonusChip extends StatelessWidget {
  const _BonusChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        color: color.withOpacity(0.2),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }
}

class _SkillDetailsSheet extends StatelessWidget {
  const _SkillDetailsSheet({required this.skill});

  final SkillNode skill;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: AppColors.borderSubtle,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                color: AppColors.accentWarning.withOpacity(0.2),
              ),
              child: Center(
                child: Text(
                  skill.icon ?? '🔮',
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(skill.name, style: AppTypography.headingLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              skill.description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Tier ${skill.tier} • ${skill.cost} XP',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.accentCyan,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
