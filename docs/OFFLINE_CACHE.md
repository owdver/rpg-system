# Offline Cache

## Purpose
Ensure the app remains functional without connectivity.

## Local Storage Strategy
- Hive or Isar for structured local entities.
- Cache recent workouts, missions, recovery reports, notifications, and sync queue.
- Store minimal sensitive data and encrypt where supported.

## Cache Invalidation
- Expire cached data by freshness policy.
- Mark data as stale when older than a configurable threshold.
