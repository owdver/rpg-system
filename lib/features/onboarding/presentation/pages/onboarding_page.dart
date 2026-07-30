import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/services/haptic_manager.dart';
import '../../../../core/services/sound_manager.dart';
import '../../../../core/shared/widgets/widgets.dart';
import '../providers/onboarding_provider.dart';

/// Enhanced onboarding page with full animations, haptics, and sound.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _onStepComplete() {
    final haptic = ref.read(hapticManagerProvider);
    final sound = ref.read(soundManagerProvider);
    haptic.success();
    sound.playScanReveal();
    ref.read(onboardingProvider.notifier).nextStep();
  }

  void _onInteraction() {
    final haptic = ref.read(hapticManagerProvider);
    haptic.lightTap();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dynamic background
          const DynamicBackground(),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Progress bar
                _OnboardingProgressBar(
                  progress: onboardingState.progress,
                  currentStep: onboardingState.currentStep,
                ),

                // Page content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: AppAnimations.standard,
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _buildStep(onboardingState.currentStep),
                  ),
                ),

                // Navigation buttons
                _OnboardingNavigation(
                  currentStep: onboardingState.currentStep,
                  totalSteps: onboardingState.totalSteps,
                  canProceed: _canProceed(onboardingState),
                  onBack: onboardingState.currentStep > 0
                      ? () {
                          _onInteraction();
                          ref.read(onboardingProvider.notifier).previousStep();
                        }
                      : null,
                  onNext: _canProceed(onboardingState)
                      ? () {
                          _onStepComplete();
                        }
                      : null,
                  onComplete: () {
                    final haptic = ref.read(hapticManagerProvider);
                    final sound = ref.read(soundManagerProvider);
                    haptic.heavyImpact();
                    sound.playSystemActivation();
                    ref.read(onboardingProvider.notifier).completeOnboarding();
                    context.go(AppRoutes.home);
                  },
                ),
              ],
            ),
          ),

          // Scanline overlay
          AnimatedBuilder(
            animation: _scanController,
            builder: (context, child) {
              return CustomPaint(
                painter: _ScanPainter(progress: _scanController.value),
                size: Size.infinite,
              );
            },
          ),
        ],
      ),
    );
  }

  bool _canProceed(OnboardingState state) {
    switch (state.currentStep) {
      case 0:
        return state.displayName.isNotEmpty;
      case 1:
        return state.selectedGoal != null;
      case 2:
        return state.selectedExperience != null;
      case 3:
        return state.selectedFrequency != null;
      case 4:
        return state.selectedTrainingTypes.isNotEmpty;
      case 5:
        return true;
      case 6:
        return state.hasAcceptedTerms;
      default:
        return false;
    }
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return _WelcomeStep(key: const ValueKey('welcome'));
      case 1:
        return _GoalStep(key: const ValueKey('goal'));
      case 2:
        return _ExperienceStep(key: const ValueKey('experience'));
      case 3:
        return _FrequencyStep(key: const ValueKey('frequency'));
      case 4:
        return _TrainingTypesStep(key: const ValueKey('types'));
      case 5:
        return _BaselineStep(key: const ValueKey('baseline'));
      case 6:
        return _FinalizeStep(key: const ValueKey('finalize'));
      default:
        return const SizedBox.shrink();
    }
  }
}

class _OnboardingProgressBar extends StatelessWidget {
  const _OnboardingProgressBar({
    required this.progress,
    required this.currentStep,
  });

  final double progress;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STEP ${currentStep + 1}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 2,
                ),
              ),
              Text(
                _getStepTitle(currentStep),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.accentCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColors.backgroundTertiary,
              valueColor: const AlwaysStoppedAnimation(AppColors.accentCyan),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    const titles = [
      'IDENTIFICATION',
      'OBJECTIVE',
      'CAPABILITY LEVEL',
      'TRAINING FREQUENCY',
      'TRAINING TYPES',
      'BASELINE ASSESSMENT',
      'SYSTEM INITIALIZATION',
    ];
    return titles[step];
  }
}

class _OnboardingNavigation extends StatelessWidget {
  const _OnboardingNavigation({
    required this.currentStep,
    required this.totalSteps,
    required this.canProceed,
    this.onBack,
    this.onNext,
    this.onComplete,
  });

  final int currentStep;
  final int totalSteps;
  final bool canProceed;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps - 1;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          if (onBack != null)
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  side: BorderSide(color: AppColors.borderSubtle),
                ),
                child: Text(
                  'BACK',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          if (onBack != null) const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: onBack != null ? 1 : 2,
            child: ElevatedButton(
              onPressed: canProceed
                  ? (isLastStep ? onComplete : onNext)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isLastStep
                    ? AppColors.accentSuccess
                    : AppColors.accentCyan,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                disabledBackgroundColor: AppColors.backgroundTertiary,
              ),
              child: Text(
                isLastStep ? 'INITIALIZE SYSTEM' : 'CONTINUE',
                style: AppTypography.labelMedium.copyWith(
                  color: canProceed
                      ? AppColors.backgroundPrimary
                      : AppColors.textMuted,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeStep extends ConsumerStatefulWidget {
  const _WelcomeStep({super.key});

  @override
  ConsumerState<_WelcomeStep> createState() => _WelcomeStepState();
}

class _WelcomeStepState extends ConsumerState<_WelcomeStep> {
  final _nameController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController.text = ref.read(onboardingProvider).displayName;
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    ref.read(onboardingProvider.notifier).setDisplayName(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          HolographicContainer(
            width: 120,
            height: 120,
            borderRadius: AppSpacing.radiusXl,
            glowColor: AppColors.accentCyan,
            child: const Icon(
              Icons.psychology_outlined,
              size: 56,
              color: AppColors.accentCyan,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'SYSTEM ACCESS',
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Enter your designation to begin',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _HoloTextField(
            controller: _nameController,
            focusNode: _focusNode,
            label: 'DESIGNATION',
            hint: 'Enter your name',
            icon: Icons.person_outline,
          ),
        ],
      ),
    );
  }
}

class _GoalStep extends ConsumerWidget {
  const _GoalStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoal = ref.watch(onboardingProvider).selectedGoal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'SELECT OBJECTIVE',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'What is your primary fitness goal?',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          ...FitnessGoal.values.map((goal) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _SelectionCard(
                  title: goal.label,
                  subtitle: goal.description,
                  icon: goal.icon,
                  isSelected: selectedGoal == goal,
                  onTap: () {
                    ref.read(hapticManagerProvider).selection();
                    ref.read(onboardingProvider.notifier).selectGoal(goal);
                  },
                ),
              )),
        ],
      ),
    );
  }
}

class _ExperienceStep extends ConsumerWidget {
  const _ExperienceStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(onboardingProvider).selectedExperience;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'CAPABILITY LEVEL',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'What is your training experience?',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          ...ExperienceLevel.values.map((level) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _SelectionCard(
                  title: level.label,
                  subtitle: level.description,
                  icon: level.icon,
                  isSelected: selectedLevel == level,
                  onTap: () {
                    ref.read(hapticManagerProvider).selection();
                    ref.read(onboardingProvider.notifier).selectExperience(level);
                  },
                ),
              )),
        ],
      ),
    );
  }
}

class _FrequencyStep extends ConsumerWidget {
  const _FrequencyStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFrequency = ref.watch(onboardingProvider).selectedFrequency;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'TRAINING FREQUENCY',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'How often do you train?',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          ...WorkoutFrequency.values.map((frequency) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _SelectionCard(
                  title: frequency.label,
                  subtitle: frequency.description,
                  icon: null,
                  isSelected: selectedFrequency == frequency,
                  onTap: () {
                    ref.read(hapticManagerProvider).selection();
                    ref.read(onboardingProvider.notifier).selectFrequency(frequency);
                  },
                ),
              )),
        ],
      ),
    );
  }
}

class _TrainingTypesStep extends ConsumerWidget {
  const _TrainingTypesStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTypes = ref.watch(onboardingProvider).selectedTrainingTypes;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'TRAINING TYPES',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Select your preferred training types',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: TrainingType.values.map((type) {
              final isSelected = selectedTypes.contains(type);
              return _TypeChip(
                label: type.label,
                icon: type.icon,
                isSelected: isSelected,
                onTap: () {
                  ref.read(hapticManagerProvider).selection();
                  ref.read(onboardingProvider.notifier).toggleTrainingType(type);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (selectedTypes.isNotEmpty)
            Text(
              '${selectedTypes.length} types selected',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.accentCyan,
              ),
            ),
        ],
      ),
    );
  }
}

class _BaselineStep extends ConsumerWidget {
  const _BaselineStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'BASELINE ASSESSMENT',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Optional baseline evaluation',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          HolographicContainer(
            borderRadius: AppSpacing.radiusLg,
            glowColor: AppColors.accentViolet,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.health_and_safety_outlined,
                        color: AppColors.accentViolet,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Skip for default values',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Baseline assessment will be calculated based on your selected goal, experience level, and training frequency.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
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

class _FinalizeStep extends ConsumerWidget {
  const _FinalizeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAcceptedTerms = ref.watch(onboardingProvider).hasAcceptedTerms;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          HolographicContainer(
            width: 100,
            height: 100,
            borderRadius: AppSpacing.radiusXl,
            glowColor: AppColors.accentSuccess,
            glowIntensity: 0.4,
            child: const Icon(
              Icons.check_circle_outline,
              size: 48,
              color: AppColors.accentSuccess,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'READY FOR INITIALIZATION',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Accept terms to complete setup',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          InkWell(
            onTap: () {
              ref.read(hapticManagerProvider).selection();
              ref.read(onboardingProvider.notifier).setTermsAccepted(!hasAcceptedTerms);
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: HolographicContainer(
              borderRadius: AppSpacing.radiusMd,
              glowColor: hasAcceptedTerms ? AppColors.accentSuccess : AppColors.textMuted,
              glowIntensity: hasAcceptedTerms ? 0.3 : 0.1,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: hasAcceptedTerms
                            ? AppColors.accentSuccess
                            : Colors.transparent,
                        border: Border.all(
                          color: hasAcceptedTerms
                              ? AppColors.accentSuccess
                              : AppColors.textMuted,
                          width: 2,
                        ),
                      ),
                      child: hasAcceptedTerms
                          ? const Icon(
                              Icons.check,
                              size: 18,
                              color: AppColors.backgroundPrimary,
                            )
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terms & Conditions',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'I accept the terms of service and privacy policy',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String? icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: HolographicContainer(
        borderRadius: AppSpacing.radiusMd,
        glowColor: isSelected ? AppColors.accentCyan : AppColors.textMuted,
        glowIntensity: isSelected ? 0.3 : 0.1,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              if (icon != null)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    color: isSelected
                        ? AppColors.accentCyan.withOpacity(0.2)
                        : AppColors.backgroundTertiary,
                  ),
                  child: Center(
                    child: Text(
                      icon!,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              if (icon != null) const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.accentCyan,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: AnimatedContainer(
        duration: AppAnimations.quick,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          color: isSelected
              ? AppColors.accentCyan.withOpacity(0.2)
              : AppColors.backgroundTertiary,
          border: Border.all(
            color: isSelected ? AppColors.accentCyan : AppColors.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? AppColors.accentCyan : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoloTextField extends StatelessWidget {
  const _HoloTextField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: AppColors.accentCyan,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.accentCyan, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accentCyan,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: controller,
              focusNode: focusNode,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textMuted,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanPainter extends CustomPainter {
  _ScanPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * progress;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.accentCyan.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, y - 30, size.width, 60));

    canvas.drawRect(
      Rect.fromLTWH(0, y - 30, size.width, 60),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
