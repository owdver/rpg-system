# Synchronization

## Purpose
Reconcile local changes with remote state safely and deterministically.

## Sync Strategy
- Queue all writes when offline.
- Replay queued changes on reconnect.
- Resolve conflicts using timestamp and ownership rules.
- Keep operations idempotent.

## Sync States
- idle
- syncing
- pending
- conflict
- failed
