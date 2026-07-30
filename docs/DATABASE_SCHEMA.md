# Database Schema

## Core Collections
### users
- id
- displayName
- email
- createdAt
- preferences
- profileMetrics
- currentLevel
- currentRank
- currentTitle
- inventoryIds
- skillTreeState

### workouts
- id
- userId
- startedAt
- completedAt
- source
- durationSeconds
- exerciseSummaries
- performanceScore
- recoveryScore
- xpAwarded

### missions
- id
- userId
- type
- difficulty
- targetMetrics
- status
- assignedAt
- expiresAt
- rewardSummary

### achievements
- id
- userId
- achievementId
- unlockedAt
- progressValue

### recoveryReports
- id
- userId
- generatedAt
- readinessScore
- fatigueScore
- sleepSummary
- recommendedAction

### syncEvents
- id
- userId
- entityType
- operation
- createdAt
- pending

## Local Storage
Hive or Isar stores recent sessions, mission state, pending sync events, and cached reports for offline use.
