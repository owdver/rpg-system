# Notification System

## Purpose
Surface mission updates, warnings, rewards, and system messages without overwhelming the user.

## User Flow
1. Event occurs.
2. Notification is queued.
3. UI displays it according to priority and context.
4. User taps it and is routed to the relevant screen.

## UI Layout
- In-app notification stack, toast-style windows, and persistent alert center.

## State Management
- Notification provider tracks queue state, dismissals, unread count, and routing targets.

## Data Model
- Notification entity with id, type, severity, title, body, actionRoute, timestamp, and expiration.

## API Interaction
- Local notifications from FCM and remote push sync.

## Offline Behavior
- Cache notifications locally and surface them on next app open.

## Error Handling
- Delivery failures, inaccessible route, expired notifications.

## Loading States
- Notification digest skeleton in the alert center.

## Empty States
- No current notifications.

## Edge Cases
- Notification spam, duplicate delivery, silent mode.

## Animation
- Projection, sweep, and dissolve behaviors.

## Sound
- Priority-appropriate tone.

## Haptics
- Light tap for info, stronger pulse for warnings.

## Accessibility
- Live region and clear heading structure.

## Performance Considerations
- Cap visible notification count and defer low-priority alerts.

## Acceptance Criteria
- Notifications are routed and displayed correctly and do not break the experience.
