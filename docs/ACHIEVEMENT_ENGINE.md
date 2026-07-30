# Achievement Engine

## Purpose
Track milestone accomplishments and unlock reward artifacts.

## User Flow
1. User reaches conditions such as streaks, session counts, or mastery milestones.
2. Engine evaluates unlock condition.
3. Achievement is displayed with reveal animation and reward.

## UI Layout
- Achievement reveal modal and progress list.

## State Management
- Achievement provider tracks progress, unlocked state, and completion order.

## Data Model
- Achievement definitions, progress values, unlock timestamps, and reward metadata.

## API Interaction
- Read achievement catalog and sync unlocked states.

## Offline Behavior
- Evaluate unlocks locally from cached stats and queue completion sync.

## Error Handling
- Missing definitions, progress anomalies, duplicate unlocks.

## Loading States
- Progress skeleton and reveal placeholder.

## Empty States
- No achievements unlocked yet.

## Edge Cases
- Retroactive unlocks, progress reset, secret achievements.

## Animation
- Achievement reveal, particle burst, scanline flare.

## Sound
- Rare artifact reveal and completion tone.

## Haptics
- Success vibration and rare-item pulse.

## Accessibility
- Semantic announcement for unlock, with clear reward description.

## Performance Considerations
- Evaluate achievements incrementally and avoid heavy recomputation on every event.

## Acceptance Criteria
- Achievements unlock when criteria are met and are displayed correctly.
