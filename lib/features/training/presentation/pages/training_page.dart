import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Training page with workout selection and tracking.
class TrainingPage extends ConsumerWidget {
  const TrainingPage({super.key});

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
                'TRAINING',
                style: AppTypography.headingLarge.copyWith(letterSpacing: 2),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.history),
                  color: AppColors.textSecondary,
                  onPressed: () {},
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Quick start
                  const _QuickStartSection(),
                  const SizedBox(height: AppSpacing.xxl),

                  // Workout types
                  const _WorkoutTypesSection(),
                  const SizedBox(height: AppSpacing.xxl),

                  // Today's recommended
                  const _RecommendedWorkoutsSection(),
                  const SizedBox(height: AppSpacing.xxl),

                  // Recent workouts
                  const _RecentWorkoutsSection(),
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

class _QuickStartSection extends StatelessWidget {
  const _QuickStartSection();

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusXl,
      glowColor: AppColors.accentCyan,
      glowIntensity: 0.3,
      enableScanline: true,
      child: InkWell(
        onTap: () => context.push(AppRoutes.workoutSession),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  gradient: AppColors.energyActive,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: AppColors.backgroundPrimary,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUICK START',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.accentCyan,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Begin a randomized workout session',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Estimated: 20-30 min',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutTypesSection extends StatelessWidget {
  const _WorkoutTypesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WORKOUT TYPES',
          style: AppTypography.labelMedium.copyWith(letterSpacing: 2),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _WorkoutTypeCard(
                icon: Icons.fitness_center,
                label: 'Strength',
                color: AppColors.accentBlue,
                description: 'Build muscle',
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _WorkoutTypeCard(
                icon: Icons.directions_run,
                label: 'Cardio',
                color: AppColors.accentCyan,
                description: 'Build endurance',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _WorkoutTypeCard(
                icon: Icons.self_improvement,
                label: 'Mobility',
                color: AppColors.accentViolet,
                description: 'Improve flexibility',
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _WorkoutTypeCard(
                icon: Icons.bolt,
                label: 'HIIT',
                color: AppColors.accentWarning,
                description: 'Max intensity',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WorkoutTypeCard extends StatelessWidget {
  const _WorkoutTypeCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.description,
  });

  final IconData icon;
  final String label;
  final Color color;
  final String description;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: color,
      glowIntensity: 0.15,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(AppRoutes.workoutSession),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: AppSpacing.sm),
                Text(label, style: AppTypography.labelLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecommendedWorkoutsSection extends StatelessWidget {
  const _RecommendedWorkoutsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECOMMENDED FOR TODAY',
          style: AppTypography.labelMedium.copyWith(letterSpacing: 2),
        ),
        const SizedBox(height: AppSpacing.md),
        const _RecommendedWorkoutCard(
          title: 'Upper Body Power',
          duration: 35,
          difficulty: 'MEDIUM',
          xp: '+200 XP',
          exercises: 6,
          color: AppColors.accentBlue,
        ),
        const SizedBox(height: AppSpacing.md),
        const _RecommendedWorkoutCard(
          title: 'Core Stability',
          duration: 20,
          difficulty: 'EASY',
          xp: '+100 XP',
          exercises: 4,
          color: AppColors.accentViolet,
        ),
      ],
    );
  }
}

class _RecommendedWorkoutCard extends StatelessWidget {
  const _RecommendedWorkoutCard({
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.xp,
    required this.exercises,
    required this.color,
  });

  final String title;
  final int duration;
  final String difficulty;
  final String xp;
  final int exercises;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: color,
      glowIntensity: 0.2,
      child: InkWell(
        onTap: () => context.push(AppRoutes.workoutSession),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  color: color.withOpacity(0.2),
                ),
                child: Icon(Icons.fitness_center, color: color, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: color.withOpacity(0.2),
                          ),
                          child: Text(
                            difficulty,
                            style: AppTypography.labelSmall.copyWith(
                              color: color,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(title, style: AppTypography.labelLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '$duration min',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Icon(Icons.list, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '$exercises exercises',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(xp, style: AppTypography.numericSmall.copyWith(color: color)),
                  const SizedBox(height: AppSpacing.xs),
                  const Icon(
                    Icons.play_circle_outline,
                    color: AppColors.accentCyan,
                    size: 28,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentWorkoutsSection extends StatelessWidget {
  const _RecentWorkoutsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT WORKOUTS',
          style: AppTypography.labelMedium.copyWith(letterSpacing: 2),
        ),
        const SizedBox(height: AppSpacing.md),
        const _RecentWorkoutItem(
          title: 'Full Body HIIT',
          date: 'Today, 8:30 AM',
          duration: 28,
          calories: 245,
          xp: '+150 XP',
        ),
        const SizedBox(height: AppSpacing.sm),
        const _RecentWorkoutItem(
          title: 'Upper Body Strength',
          date: 'Yesterday, 6:00 PM',
          duration: 45,
          calories: 320,
          xp: '+180 XP',
        ),
      ],
    );
  }
}

class _RecentWorkoutItem extends StatelessWidget {
  const _RecentWorkoutItem({
    required this.title,
    required this.date,
    required this.duration,
    required this.calories,
    required this.xp,
  });

  final String title;
  final String date;
  final int duration;
  final int calories;
  final String xp;

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
              color: AppColors.accentSuccess.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.check,
              color: AppColors.accentSuccess,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLarge),
                Text(date, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                xp,
                style: AppTypography.numericSmall.copyWith(
                  color: AppColors.accentCyan,
                ),
              ),
              Text(
                '$duration min • $calories cal',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Workout session page placeholder
class WorkoutSessionPage extends StatelessWidget {
  const WorkoutSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.ambientBackground,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HolographicContainer(
                  width: 200,
                  height: 200,
                  borderRadius: AppSpacing.radiusXl,
                  glowColor: AppColors.accentCyan,
                  glowIntensity: 0.4,
                  child: const Center(
                    child: Icon(
                      Icons.fitness_center,
                      size: 80,
                      color: AppColors.accentCyan,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'WORKOUT SESSION',
                  style: AppTypography.displaySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Active workout tracking coming soon',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('END SESSION'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
