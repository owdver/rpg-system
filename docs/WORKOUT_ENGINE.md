# Workout Engine

## Purpose
Interpret workouts into structured exercise and performance data that feed the progression system.

## User Flow
1. User starts a workout.
2. Engine receives events from training screen or health integration.
3. It calculates exercise progress, pace, and effort.
4. It produces a performance summary and XP reward.

## UI Layout
- Inputs from the training HUD and summary overlay after completion.

## State Management
- Workout engine provider tracks active workout, exercise progress, metrics, and completion state.

## Data Model
- Workout session, exercise segments, metrics, effort score, quality score, and completion summary.

## API Interaction
- Save workout summaries to local cache and queue remote sync.

## Offline Behavior
- Record events and finalize session locally.

## Error Handling
- Invalid exercise ordering, missing metrics, interrupted sync.

## Loading States
- Session initialization skeleton.

## Empty States
- No workout history yet.

## Edge Cases
- Late health data arrival, duplicate events, sensor gap.

## Animation
- Circular HUD transitions and stat update pulses.

## Sound
- Exercise checkpoint and completion cues.

## Haptics
- Subtle pulse on segment completion; stronger impact on workout finish.

## Accessibility
- Clear mode changes and spoken updates.

## Performance Considerations
- Keep event processing efficient and debounce repeated updates.

## Acceptance Criteria
- Workout sessions are recorded and converted into meaningful performance data.
