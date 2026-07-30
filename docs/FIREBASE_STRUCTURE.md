# Firebase Structure

## Authentication
- Firebase Authentication with email/password and optional OAuth providers.

## Firestore Collections
- users
- profiles
- workouts
- missions
- recoveryReports
- achievements
- inventory
- titles
- skillTrees
- events
- notifications
- syncQueue
- analyticsEvents

## Storage Buckets
- avatars
- cosmetics
- artifacts
- media

## Cloud Messaging
- FCM topics for mission updates, recovery alerts, and seasonal events.

## Security Rules
- User documents only readable/writable by authenticated owner.
- Server-side validation for critical writes.
- Restricted access to analytics and admin collections.
