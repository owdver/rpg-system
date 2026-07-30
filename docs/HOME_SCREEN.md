# Home Screen

## Purpose
Serve as the central command surface for the user’s current state, mission, recovery, and recommendations.

## User Flow
1. User lands on the home console.
2. System displays mission, recovery, energy, XP, and notifications.
3. User can open mission, training, progress, or inventory from home.

## UI Layout
- Full-screen holographic dashboard with layered panels and dynamic background.
- Primary panels: mission, recovery, objective list, progress summary, AI message.

## State Management
- Home provider aggregates mission status, recovery, progress, notifications, and AI state.

## Data Model
- Current mission, readiness score, XP, level, rank, title, notification queue.

## API Interaction
- Fetch latest mission state and user metrics.
- Sync new events and refresh mission recommendations.

## Offline Behavior
- Uses cached mission and recent metrics; offline indicators appear when data is stale.

## Error Handling
- Sync failure, missing mission data, invalid metrics.

## Loading States
- Skeleton for panels and shimmer-based system scan.

## Empty States
- No current mission or no notifications available.

## Edge Cases
- No connection, stale health data, mission expired.

## Animation
- Panel projection, particle drift, energy pulses.

## Sound
- Ambient system hum and micro-success cues.

## Haptics
- Soft tap and state-change pulses.

## Accessibility
- Screen-reader summaries and focus navigation between panels.

## Performance Considerations
- Lazy load lower-priority panels and keep background particles light.

## Acceptance Criteria
- The home screen is readable, responsive, and updates with refreshed state.
