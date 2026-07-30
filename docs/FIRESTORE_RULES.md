# Firestore Rules

## Principles
- Only authenticated users can access their own data.
- All writes must validate structure and ownership.
- Sensitive health-related documents must be private by default.

## Example Rules
- Users can read and write their own profile document.
- Workouts can be created/updated by the owning user only.
- Sync queue entries must be scoped to the current authenticated user.
- Admin-only access for analytics and moderation collections.
