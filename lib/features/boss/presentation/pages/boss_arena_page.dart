import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/domain/models/models.dart';
import '../../../../core/shared/widgets/widgets.dart';

/// Boss Arena page - boss challenges with phases.
class BossArenaPage extends ConsumerWidget {
  const BossArenaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.ambientBackground),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    const Icon(Icons.whatshot, color: AppColors.accentPurple),
                    const SizedBox(width: AppSpacing.md),
                    Text('BOSS ARENA',
                        style: AppTypography.headingMedium
                            .copyWith(letterSpacing: 2)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: BossCatalog.allBosses.length,
                  itemBuilder: (context, index) {
                    final boss = BossCatalog.allBosses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: _BossCard(boss: boss),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BossCard extends StatelessWidget {
  const _BossCard({required this.boss});
  final BossChallenge boss;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusLg,
      glowColor: Color(boss.tier.colorValue),
      glowIntensity: 0.15,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showBossDetails(context),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        gradient: LinearGradient(
                          colors: [
                            Color(boss.tier.colorValue),
                            Color(boss.tier.colorValue).withOpacity(0.5)
                          ],
                        ),
                      ),
                      child: Center(
                          child: Text(boss.icon ?? '👹',
                              style: const TextStyle(fontSize: 32))),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(boss.name, style: AppTypography.headingMedium),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              _TierBadge(tier: boss.tier),
                              const SizedBox(width: AppSpacing.sm),
                              Text(boss.category.toUpperCase(),
                                  style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textTertiary,
                                      letterSpacing: 1)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(children: [
                          const Icon(Icons.stars,
                              size: 14, color: AppColors.accentCyan),
                          Text('${boss.xpReward * boss.tier.xpMultiplier}',
                              style: AppTypography.labelMedium
                                  .copyWith(color: AppColors.accentCyan)),
                        ]),
                        Text('XP',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.textTertiary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(boss.description,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.md),
                ...boss.phases.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _PhaseProgress(
                          phase: e.value, phaseNumber: e.key + 1),
                    )),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Overall',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.textTertiary)),
                    Text('${(boss.overallProgress * 100).toInt()}%',
                        style: AppTypography.labelSmall
                            .copyWith(color: Color(boss.tier.colorValue))),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: LinearProgressIndicator(
                    value: boss.overallProgress,
                    backgroundColor: AppColors.surfaceGlass,
                    valueColor:
                        AlwaysStoppedAnimation(Color(boss.tier.colorValue)),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBossDetails(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => _BossDetailsSheet(boss: boss));
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.tier});
  final BossTier tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        color: Color(tier.colorValue).withOpacity(0.2),
        border: Border.all(color: Color(tier.colorValue), width: 1),
      ),
      child: Text(tier.label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
              color: Color(tier.colorValue),
              letterSpacing: 1,
              fontWeight: FontWeight.bold)),
    );
  }
}

class _PhaseProgress extends StatelessWidget {
  const _PhaseProgress({required this.phase, required this.phaseNumber});
  final BossPhase phase;
  final int phaseNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: phase.isComplete
                ? AppColors.accentSuccess.withOpacity(0.2)
                : AppColors.surfaceGlass,
            border: Border.all(
                color: phase.isComplete
                    ? AppColors.accentSuccess
                    : AppColors.borderSubtle),
          ),
          child: Center(
            child: Icon(phase.isComplete ? Icons.check : Icons.circle_outlined,
                size: 12,
                color: phase.isComplete
                    ? AppColors.accentSuccess
                    : AppColors.textTertiary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
            child: Text(phase.name,
                style: AppTypography.labelMedium.copyWith(
                    color: phase.isComplete
                        ? AppColors.accentSuccess
                        : AppColors.textPrimary))),
        Text('${phase.current}/${phase.target}',
            style: AppTypography.numericSmall.copyWith(
                color: phase.isComplete
                    ? AppColors.accentSuccess
                    : AppColors.textTertiary)),
      ],
    );
  }
}

class _BossDetailsSheet extends StatelessWidget {
  const _BossDetailsSheet({required this.boss});
  final BossChallenge boss;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl))),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: AppColors.borderSubtle)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          gradient: LinearGradient(colors: [
                            Color(boss.tier.colorValue),
                            Color(boss.tier.colorValue).withOpacity(0.5)
                          ]),
                        ),
                        child: Center(
                            child: Text(boss.icon ?? '👹',
                                style: const TextStyle(fontSize: 48))),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(boss.name, style: AppTypography.headingLarge),
                            const SizedBox(height: AppSpacing.xs),
                            _TierBadge(tier: boss.tier),
                          ])),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(boss.description,
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('REWARDS',
                      style:
                          AppTypography.labelMedium.copyWith(letterSpacing: 2)),
                  const SizedBox(height: AppSpacing.md),
                  _RewardItem(
                      icon: Icons.stars,
                      label: 'XP Reward',
                      value: '${boss.xpReward * boss.tier.xpMultiplier}',
                      color: AppColors.accentCyan),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('PHASES',
                      style:
                          AppTypography.labelMedium.copyWith(letterSpacing: 2)),
                  const SizedBox(height: AppSpacing.md),
                  ...boss.phases.asMap().entries.map((e) =>
                      _PhaseDetail(phase: e.value, phaseNumber: e.key + 1)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  const _RewardItem(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});
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
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              color: color.withOpacity(0.2)),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.textTertiary)),
          Text(value, style: AppTypography.labelLarge.copyWith(color: color)),
        ])),
      ]),
    );
  }
}

class _PhaseDetail extends StatelessWidget {
  const _PhaseDetail({required this.phase, required this.phaseNumber});
  final BossPhase phase;
  final int phaseNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: AppColors.surfaceGlass,
        border: Border.all(
            color: phase.isComplete
                ? AppColors.accentSuccess
                : AppColors.borderSubtle),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: phase.isComplete
                  ? AppColors.accentSuccess.withOpacity(0.2)
                  : AppColors.surfaceGlass,
            ),
            child: Center(
              child: Text('$phaseNumber',
                  style: AppTypography.labelMedium.copyWith(
                      color: phase.isComplete
                          ? AppColors.accentSuccess
                          : AppColors.textTertiary)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(phase.name, style: AppTypography.labelLarge),
                Text(phase.description,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
              ])),
          Text('${phase.current}/${phase.target}',
              style: AppTypography.numericMedium.copyWith(
                  color: phase.isComplete
                      ? AppColors.accentSuccess
                      : AppColors.textPrimary)),
        ]),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: LinearProgressIndicator(
            value: phase.progress,
            backgroundColor: AppColors.surfaceGlass,
            valueColor: AlwaysStoppedAnimation(phase.isComplete
                ? AppColors.accentSuccess
                : AppColors.accentCyan),
            minHeight: 4,
          ),
        ),
      ]),
    );
  }
}
