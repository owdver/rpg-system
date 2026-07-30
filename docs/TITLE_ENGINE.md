# Title Engine

## Purpose
Manage title progression and identity across the user’s capability profile.

## User Flow
1. User reaches title criteria.
2. Engine evaluates available titles.
3. UI displays a title banner and updated profile state.

## UI Layout
- Title banner, unlock modal, and title collection list.

## State Management
- Title provider tracks active title, unlocked titles, and unlock conditions.

## Data Model
- Title definitions with thresholds, description, icon, rarity, and unlock logic.

## API Interaction
- Retrieve title config and sync unlocked state.

## Offline Behavior
- Maintain cached title state and resolve unlocks locally.

## Error Handling
- Missing title data, conflicting title assignments.

## Loading States
- Title list skeleton.

## Empty States
- No titles unlocked yet.

## Edge Cases
- Multiple qualifying titles, title replacement logic, title expiry.

## Animation
- Title banner scan reveal and glow emission.

## Sound
- Prestige tone on title unlock.

## Haptics
- Distinctive pulse for title unlocks.

## Accessibility
- Announce title unlock and current title clearly.

## Performance Considerations
- Keep title checks lightweight and memoized.

## Acceptance Criteria
- Titles unlock and change properly based on progression rules.
