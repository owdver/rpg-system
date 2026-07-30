# API Specification

## Integration Scope
System integrates with Firebase services for authentication, document storage, notifications, and media handling, while local persistence supports offline behavior.

## Core API Surface
- POST /sessions: create or complete a workout session.
- GET /missions: fetch current and upcoming missions.
- POST /metrics: submit health-derived metrics.
- GET /progress: retrieve XP, stat, and achievement information.
- POST /sync: queue and reconcile local state.
- GET /notifications: fetch pending system and mission alerts.

## Contract Principles
- Versioned payloads.
- Explicit timestamps.
- Idempotent operations.
- Conflict-aware sync.
- Minimal health data exposure.
