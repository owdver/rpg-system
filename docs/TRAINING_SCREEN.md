# Training Screen

## Purpose
Provide a real-time workout control surface for the user while preserving immersion and clarity.

## User Flow
1. User starts training from mission or manual entry.
2. Workout HUD displays timer, reps, heart rate, remaining sets, and XP.
3. User pauses, resumes, or ends the session.
4. Session outcome is evaluated and rewards are generated.

## UI Layout
- Circular HUD center, side panels for current exercise and performance metrics, bottom action strip.

## State Management
- Training controller manages session state, timer, exercise progression, metrics, and completion state.

## Data Model
- Session record, exercise list, elapsed time, metrics, checkpoint events, rewards.

## API Interaction
- Save partial session data locally and sync after completion.
- Merge incoming health metrics and exercise summaries.

## Offline Behavior
- Continue workout entirely offline; queue completion event for sync.

## Error Handling
- Lost sensor data, invalid rep count, session interruption.

## Loading States
- Loading exercise details and preparing HUD.

## Empty States
- No current exercise selected.

## Edge Cases
- Device rotation, app backgrounding, incomplete reps, paused session.

## Animation
- Progress ring sweep, energy ripple, combo pulse.

## Sound
- Subtle rep confirmation and mission completion cues.

## Haptics
- Tap, pulse, and completion-impact patterns based on intensity.

## Accessibility
- Spoken feedback and large touch targets.

## Performance Considerations
- Keep frame updates efficient and avoid unnecessary rebuilds during timers.

## Acceptance Criteria
- The workout HUD can track progress and safely complete or pause a session.
