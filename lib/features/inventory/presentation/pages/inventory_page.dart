import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Inventory page showing cosmetics, titles, badges, and rewards.
class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
                      Text(
                        'INVENTORY',
                        style: AppTypography.headingLarge.copyWith(
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    color: AppColors.surfaceGlass,
                  ),
                  child: TabBar(
                    labelColor: AppColors.accentCyan,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      gradient: AppColors.energyActive,
                    ),
                    labelStyle: AppTypography.labelSmall,
                    unselectedLabelStyle: AppTypography.labelSmall,
                    tabs: const [
                      Tab(text: 'COSMETICS'),
                      Tab(text: 'TITLES'),
                      Tab(text: 'BADGES'),
                      Tab(text: 'EFFECTS'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Content
                Expanded(
                  child: TabBarView(
                    children: [
                      _CosmeticsTab(),
                      _TitlesTab(),
                      _BadgesTab(),
                      _EffectsTab(),
                    ],
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

class _CosmeticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(AppSpacing.lg),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 0.85,
      children: [
        _CosmeticItem(
          name: 'Cyber Armor',
          rarity: 'EPIC',
          color: AppColors.accentViolet,
          isEquipped: true,
        ),
        _CosmeticItem(
          name: 'Neon Visor',
          rarity: 'RARE',
          color: AppColors.accentCyan,
          isEquipped: false,
        ),
        _CosmeticItem(
          name: 'Tech Gloves',
          rarity: 'RARE',
          color: AppColors.accentBlue,
          isEquipped: false,
        ),
        _CosmeticItem(
          name: 'Plasma Boots',
          rarity: 'LEGENDARY',
          color: AppColors.accentAmber,
          isEquipped: false,
        ),
        _CosmeticItem(
          name: 'Matrix Core',
          rarity: 'EPIC',
          color: AppColors.accentViolet,
          isEquipped: false,
        ),
        _CosmeticItem(
          name: 'Void Cloak',
          rarity: 'LEGENDARY',
          color: AppColors.accentAmber,
          isEquipped: false,
        ),
      ],
    );
  }
}

class _CosmeticItem extends StatelessWidget {
  const _CosmeticItem({
    required this.name,
    required this.rarity,
    required this.color,
    required this.isEquipped,
  });

  final String name;
  final String rarity;
  final Color color;
  final bool isEquipped;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: color,
      glowIntensity: isEquipped ? 0.3 : 0.15,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    color: color.withOpacity(0.2),
                    border: Border.all(
                      color: color.withOpacity(0.5),
                    ),
                  ),
                  child: Icon(
                    Icons.shield,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  name,
                  style: AppTypography.labelLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: color.withOpacity(0.2),
                  ),
                  child: Text(
                    rarity,
                    style: AppTypography.labelSmall.copyWith(
                      color: color,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isEquipped)
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: AppColors.energyActive,
                ),
                child: Text(
                  'EQUIPPED',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.backgroundPrimary,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TitlesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const _TitleItem(
          title: 'System Initiate',
          description: 'Complete the onboarding process',
          isUnlocked: true,
          isActive: true,
        ),
        const SizedBox(height: AppSpacing.md),
        const _TitleItem(
          title: 'Iron Will',
          description: 'Complete 30 workouts',
          isUnlocked: true,
          isActive: false,
        ),
        const SizedBox(height: AppSpacing.md),
        const _TitleItem(
          title: 'Phoenix Rising',
          description: 'Recover from a 7-day streak loss',
          isUnlocked: false,
          isActive: false,
        ),
        const SizedBox(height: AppSpacing.md),
        const _TitleItem(
          title: 'Unstoppable',
          description: 'Complete 100 workouts',
          isUnlocked: false,
          isActive: false,
        ),
      ],
    );
  }
}

class _TitleItem extends StatelessWidget {
  const _TitleItem({
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.isActive,
  });

  final String title;
  final String description;
  final bool isUnlocked;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: isActive ? AppColors.accentCyan : Colors.transparent,
      glowIntensity: isActive ? 0.2 : 0.0,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: isUnlocked
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                color: Colors.black.withOpacity(0.3),
              ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                color: isUnlocked
                    ? AppColors.accentAmber.withOpacity(0.2)
                    : AppColors.textMuted.withOpacity(0.2),
              ),
              child: Icon(
                isUnlocked ? Icons.workspace_premium : Icons.lock,
                color: isUnlocked ? AppColors.accentAmber : AppColors.textMuted,
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
                      color: isUnlocked
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: isUnlocked
                          ? AppColors.textSecondary
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: AppColors.energyActive,
                ),
                child: Text(
                  'ACTIVE',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.backgroundPrimary,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BadgesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(AppSpacing.lg),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      children: [
        _BadgeItem(name: 'Early Bird', color: AppColors.accentAmber),
        _BadgeItem(name: 'Night Owl', color: AppColors.accentViolet),
        _BadgeItem(name: 'Consistent', color: AppColors.accentSuccess),
        _BadgeItem(name: 'Speed Demon', color: AppColors.accentError),
        _BadgeItem(name: 'Strength', color: AppColors.accentBlue),
        _BadgeItem(name: 'Endurance', color: AppColors.accentCyan),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  const _BadgeItem({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HolographicContainer(
          borderRadius: AppSpacing.radiusMd,
          glowColor: color,
          glowIntensity: 0.2,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              color: color.withOpacity(0.2),
            ),
            child: Icon(Icons.military_tech, color: color, size: 28),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          name,
          style: AppTypography.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _EffectsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _EffectItem(
          name: 'XP Boost',
          description: '+10% XP for 24 hours',
          duration: '23:45:00 remaining',
          color: AppColors.accentCyan,
        ),
        const SizedBox(height: AppSpacing.md),
        _EffectItem(
          name: 'Double Rewards',
          description: '2x mission rewards today',
          duration: 'Active',
          color: AppColors.accentAmber,
        ),
      ],
    );
  }
}

class _EffectItem extends StatelessWidget {
  const _EffectItem({
    required this.name,
    required this.description,
    required this.duration,
    required this.color,
  });

  final String name;
  final String description;
  final String duration;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: color,
      glowIntensity: 0.2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                color: color.withOpacity(0.2),
              ),
              child: Icon(Icons.auto_awesome, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTypography.labelLarge),
                  Text(description, style: AppTypography.bodySmall),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: color.withOpacity(0.2),
              ),
              child: Text(
                duration,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
