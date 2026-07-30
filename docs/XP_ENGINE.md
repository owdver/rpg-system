# XP Engine

## Purpose
Translate user effort into progression currency and visible system reward.

## User Flow
1. Workout or mission completes.
2. Engine calculates XP using effort, quality, and consistency.
3. XP is displayed and stored.
4. Threshold crossing triggers level progression.

## UI Layout
- XP bar, overflow burst view, and recent reward summary.

## State Management
- XP provider stores total XP, progression toward next level, and reward history.

## Data Model
- XP event records with source, amount, multiplier, timestamp, and related mission or workout id.

## API Interaction
- Sync XP events and progression updates to Firestore.

## Offline Behavior
- Accumulate XP locally and reconcile on sync.

## Error Handling
- Invalid reward calculation, duplicate events, sync conflict.

## Loading States
- Reward calculation shimmer.

## Empty States
- No XP history yet.

## Edge Cases
- XP overflow, level edge case, negative adjustments.

## Animation
- XP overflow, count-up, energy sweep, burst.

## Sound
- Reward chime and level-up resonance.

## Haptics
- Reward pulse and level-up impact.

## Accessibility
- Announce gain as a change in state and provide numeric totals.

## Performance Considerations
- Keep XP reward logic deterministic and cache recent totals.

## Acceptance Criteria
- The system awards XP correctly and updates displayed progression state.
