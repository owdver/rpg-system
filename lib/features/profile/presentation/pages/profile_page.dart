import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/auth_provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Profile page showing user info and settings access.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.ambientBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'PROFILE',
                      style: AppTypography.headingLarge.copyWith(
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      // Avatar and name
                      HolographicContainer(
                        borderRadius: AppSpacing.radiusXl,
                        glowColor: AppColors.accentCyan,
                        glowIntensity: 0.25,
                        enableScanline: true,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.energyActive,
                                ),
                                child: Center(
                                  child: Text(
                                    user?.displayName.isNotEmpty == true
                                        ? user!.displayName[0].toUpperCase()
                                        : '?',
                                    style: AppTypography.displayLarge.copyWith(
                                      color: AppColors.backgroundPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Text(
                                user?.displayName ?? 'Unknown Operative',
                                style: AppTypography.headingMedium,
                              ),
                              Text(
                                user?.email ?? '',
                                style: AppTypography.bodySmall,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _ProfileBadge(
                                    label: 'Level ${user?.level ?? 1}',
                                    color: AppColors.accentAmber,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  _ProfileBadge(
                                    label: user?.rank ?? 'Initiate',
                                    color: AppColors.accentViolet,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Stats grid
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Total XP',
                              value: '${user?.totalXp ?? 0}',
                              icon: Icons.bolt,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _StatCard(
                              label: 'Workouts',
                              value: '127',
                              icon: Icons.fitness_center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Achievements',
                              value: '24',
                              icon: Icons.emoji_events,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _StatCard(
                              label: 'Badges',
                              value: '12',
                              icon: Icons.military_tech,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Menu items
                      _ProfileMenuItem(
                        icon: Icons.person_outline,
                        label: 'Edit Profile',
                        onTap: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _ProfileMenuItem(
                        icon: Icons.health_and_safety_outlined,
                        label: 'Health Integrations',
                        onTap: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _ProfileMenuItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        onTap: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _ProfileMenuItem(
                        icon: Icons.lock_outline,
                        label: 'Privacy & Security',
                        onTap: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _ProfileMenuItem(
                        icon: Icons.help_outline,
                        label: 'Help & Support',
                        onTap: () {},
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Sign out
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ref.read(authNotifierProvider.notifier).signOut();
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('SIGN OUT'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        color: color.withOpacity(0.2),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(color: color),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: AppColors.accentCyan,
      glowIntensity: 0.15,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accentCyan, size: 24),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: AppTypography.numericLarge,
            ),
            Text(label, style: AppTypography.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: AppColors.surfaceGlass,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textSecondary, size: 24),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(label, style: AppTypography.labelLarge),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textMuted,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
