import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fitness goal types.
enum FitnessGoal {
  buildMuscle,
  loseWeight,
  improveEndurance,
  increaseFlexibility,
  generalHealth,
}

extension FitnessGoalExtension on FitnessGoal {
  String get label {
    switch (this) {
      case FitnessGoal.buildMuscle:
        return 'Build Muscle';
      case FitnessGoal.loseWeight:
        return 'Lose Weight';
      case FitnessGoal.improveEndurance:
        return 'Improve Endurance';
      case FitnessGoal.increaseFlexibility:
        return 'Increase Flexibility';
      case FitnessGoal.generalHealth:
        return 'General Health';
    }
  }

  String get description {
    switch (this) {
      case FitnessGoal.buildMuscle:
        return 'Strength training and muscle growth';
      case FitnessGoal.loseWeight:
        return 'Caloric deficit and fat loss';
      case FitnessGoal.improveEndurance:
        return 'Cardio and stamina building';
      case FitnessGoal.increaseFlexibility:
        return 'Mobility and range of motion';
      case FitnessGoal.generalHealth:
        return 'Overall wellness and fitness';
    }
  }

  String get icon {
    switch (this) {
      case FitnessGoal.buildMuscle:
        return '💪';
      case FitnessGoal.loseWeight:
        return '🔥';
      case FitnessGoal.improveEndurance:
        return '🏃';
      case FitnessGoal.increaseFlexibility:
        return '🧘';
      case FitnessGoal.generalHealth:
        return '❤️';
    }
  }
}

/// Experience level.
enum ExperienceLevel {
  beginner,
  intermediate,
  advanced,
}

extension ExperienceLevelExtension on ExperienceLevel {
  String get label {
    switch (this) {
      case ExperienceLevel.beginner:
        return 'Beginner';
      case ExperienceLevel.intermediate:
        return 'Intermediate';
      case ExperienceLevel.advanced:
        return 'Advanced';
    }
  }

  String get description {
    switch (this) {
      case ExperienceLevel.beginner:
        return 'Less than 6 months training';
      case ExperienceLevel.intermediate:
        return '6 months to 2 years';
      case ExperienceLevel.advanced:
        return 'Over 2 years of training';
    }
  }

  String get icon {
    switch (this) {
      case ExperienceLevel.beginner:
        return '🌱';
      case ExperienceLevel.intermediate:
        return '⚡';
      case ExperienceLevel.advanced:
        return '🔥';
    }
  }
}

/// Workout frequency.
enum WorkoutFrequency {
  occasional,
  moderate,
  frequent,
  daily,
}

extension WorkoutFrequencyExtension on WorkoutFrequency {
  String get label {
    switch (this) {
      case WorkoutFrequency.occasional:
        return 'Occasional';
      case WorkoutFrequency.moderate:
        return 'Moderate';
      case WorkoutFrequency.frequent:
        return 'Frequent';
      case WorkoutFrequency.daily:
        return 'Daily';
    }
  }

  String get description {
    switch (this) {
      case WorkoutFrequency.occasional:
        return '1-2 times per week';
      case WorkoutFrequency.moderate:
        return '3-4 times per week';
      case WorkoutFrequency.frequent:
        return '5-6 times per week';
      case WorkoutFrequency.daily:
        return 'Every day';
    }
  }

  int get daysPerWeek {
    switch (this) {
      case WorkoutFrequency.occasional:
        return 1;
      case WorkoutFrequency.moderate:
        return 3;
      case WorkoutFrequency.frequent:
        return 5;
      case WorkoutFrequency.daily:
        return 7;
    }
  }
}

/// Available training types.
enum TrainingType {
  strength,
  cardio,
  hiit,
  yoga,
  pilates,
  crossfit,
  calisthenics,
  swimming,
  cycling,
  running,
}

extension TrainingTypeExtension on TrainingType {
  String get label {
    switch (this) {
      case TrainingType.strength:
        return 'Strength';
      case TrainingType.cardio:
        return 'Cardio';
      case TrainingType.hiit:
        return 'HIIT';
      case TrainingType.yoga:
        return 'Yoga';
      case TrainingType.pilates:
        return 'Pilates';
      case TrainingType.crossfit:
        return 'CrossFit';
      case TrainingType.calisthenics:
        return 'Calisthenics';
      case TrainingType.swimming:
        return 'Swimming';
      case TrainingType.cycling:
        return 'Cycling';
      case TrainingType.running:
        return 'Running';
    }
  }

  String get icon {
    switch (this) {
      case TrainingType.strength:
        return '🏋️';
      case TrainingType.cardio:
        return '❤️';
      case TrainingType.hiit:
        return '⚡';
      case TrainingType.yoga:
        return '🧘';
      case TrainingType.pilates:
        return '🎯';
      case TrainingType.crossfit:
        return '💪';
      case TrainingType.calisthenics:
        return '🤸';
      case TrainingType.swimming:
        return '🏊';
      case TrainingType.cycling:
        return '🚴';
      case TrainingType.running:
        return '🏃';
    }
  }
}

/// Baseline readiness input.
class BaselineReadiness {
  const BaselineReadiness({
    this.fitnessAge = 30,
    this.weeklyExerciseHours = 3,
    this.currentReadiness = 70,
    this.hasHealthConditions = false,
    this.hasInjuries = false,
  });

  final int fitnessAge;
  final double weeklyExerciseHours;
  final int currentReadiness;
  final bool hasHealthConditions;
  final bool hasInjuries;
}

/// Complete onboarding state.
class OnboardingState {
  const OnboardingState({
    this.currentStep = 0,
    this.isComplete = false,
    this.displayName = '',
    this.selectedGoal,
    this.selectedExperience,
    this.selectedFrequency,
    this.selectedTrainingTypes = const [],
    this.baselineReadiness = const BaselineReadiness(),
    this.hasAcceptedTerms = false,
    this.hasEnabledNotifications = false,
    this.hasConnectedHealth = false,
  });

  final int currentStep;
  final bool isComplete;
  final String displayName;
  final FitnessGoal? selectedGoal;
  final ExperienceLevel? selectedExperience;
  final WorkoutFrequency? selectedFrequency;
  final List<TrainingType> selectedTrainingTypes;
  final BaselineReadiness baselineReadiness;
  final bool hasAcceptedTerms;
  final bool hasEnabledNotifications;
  final bool hasConnectedHealth;

  int get totalSteps =>
      7; // Welcome, Goal, Experience, Frequency, Types, Baseline, Finalize

  double get progress => (currentStep + 1) / totalSteps;

  OnboardingState copyWith({
    int? currentStep,
    bool? isComplete,
    String? displayName,
    FitnessGoal? selectedGoal,
    ExperienceLevel? selectedExperience,
    WorkoutFrequency? selectedFrequency,
    List<TrainingType>? selectedTrainingTypes,
    BaselineReadiness? baselineReadiness,
    bool? hasAcceptedTerms,
    bool? hasEnabledNotifications,
    bool? hasConnectedHealth,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      isComplete: isComplete ?? this.isComplete,
      displayName: displayName ?? this.displayName,
      selectedGoal: selectedGoal ?? this.selectedGoal,
      selectedExperience: selectedExperience ?? this.selectedExperience,
      selectedFrequency: selectedFrequency ?? this.selectedFrequency,
      selectedTrainingTypes:
          selectedTrainingTypes ?? this.selectedTrainingTypes,
      baselineReadiness: baselineReadiness ?? this.baselineReadiness,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      hasEnabledNotifications:
          hasEnabledNotifications ?? this.hasEnabledNotifications,
      hasConnectedHealth: hasConnectedHealth ?? this.hasConnectedHealth,
    );
  }
}

/// Onboarding provider.
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void nextStep() {
    if (state.currentStep < state.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < state.totalSteps) {
      state = state.copyWith(currentStep: step);
    }
  }

  void setDisplayName(String name) {
    state = state.copyWith(displayName: name);
  }

  void selectGoal(FitnessGoal goal) {
    state = state.copyWith(selectedGoal: goal);
  }

  void selectExperience(ExperienceLevel level) {
    state = state.copyWith(selectedExperience: level);
  }

  void selectFrequency(WorkoutFrequency frequency) {
    state = state.copyWith(selectedFrequency: frequency);
  }

  void toggleTrainingType(TrainingType type) {
    final types = List<TrainingType>.from(state.selectedTrainingTypes);
    if (types.contains(type)) {
      types.remove(type);
    } else {
      types.add(type);
    }
    state = state.copyWith(selectedTrainingTypes: types);
  }

  void setBaselineReadiness(BaselineReadiness readiness) {
    state = state.copyWith(baselineReadiness: readiness);
  }

  void setTermsAccepted(bool accepted) {
    state = state.copyWith(hasAcceptedTerms: accepted);
  }

  void setNotificationsEnabled(bool enabled) {
    state = state.copyWith(hasEnabledNotifications: enabled);
  }

  void setHealthConnected(bool connected) {
    state = state.copyWith(hasConnectedHealth: connected);
  }

  void completeOnboarding() {
    state = state.copyWith(isComplete: true);
  }

  void reset() {
    state = const OnboardingState();
  }
}

/// Provider for onboarding state.
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(),
);
