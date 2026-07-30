# Mission Engine

## Purpose
Generate and manage missions that align with the user’s current state, goals, and readiness.

## User Flow
1. System evaluates readiness and activity history.
2. Engine creates a new mission or selects a queued mission.
3. User completes or fails it.
4. Rewards and progression state are updated.

## UI Layout
- Mission briefing window and status panel with difficulty, reward, and objective details.

## State Management
- Mission provider caches current mission, mission history, reward state, and completion status.

## Data Model
- Mission entity with type, goal, difficulty, reward, status, start/end times, and evaluation metadata.

## API Interaction
- Pull mission templates and generate personalized variants based on server rules and local history.

## Offline Behavior
- Keep the currently active mission cached locally and allow completion offline.

## Error Handling
- Mission generation failure, missing dependencies, overdue missions.

## Loading States
- Mission generation skeleton and loading overlay.

## Empty States
- No active mission; show system-generated fallback.

## Edge Cases
- Mission expires, user skips mission, conflicting objectives.

## Animation
- Mission materialization, scan reveal, reward burst.

## Sound
- Mission assignment chime and completion fanfare.

## Haptics
- Mission accepted and completed pulses.

## Accessibility
- Clear objective labels and non-visual status equivalents.

## Performance Considerations
- Keep mission generation lightweight and deterministic.

## Acceptance Criteria
- Missions are generated and resolved correctly without contradicting user state.
