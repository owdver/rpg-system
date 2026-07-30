# Streak Engine

## Purpose
Track consecutive behavior and reward continuity over time.

## User Flow
1. System records daily or weekly engagement.
2. Engine updates streak state and reward eligibility.
3. UI displays current streak and milestone.

## UI Layout
- Streak card and milestone list.

## State Management
- Streak provider tracks current streak, longest streak, freeze status, and recent activity.

## Data Model
- Streak record with start date, last active date, length, medal, and pause state.

## API Interaction
- Sync streak updates and history.

## Offline Behavior
- Maintain local streak state and reconcile after reconnect.

## Error Handling
- Time zone issues, missing activity days, duplicate entries.

## Loading States
- Compact loading placeholder.

## Empty States
- No streak history yet.

## Edge Cases
- Missed day, restore logic, streak freeze usage.

## Animation
- Streak pulse, milestone flash, ribbon reveal.

## Sound
- Soft streak milestone chime.

## Haptics
- Brief pulse on streak milestones.

## Accessibility
- Announce streak progression.

## Performance Considerations
- Streak logic should use date-based normalization and local caches.

## Acceptance Criteria
- Streak state updates correctly and rewards are consistent.
