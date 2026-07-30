# Sync Strategy

## Sync Approach
Sync is resilient, conflict-aware, and idempotent. Local changes are preserved and replayed when the network is available.

## Sync Rules
- Batch changes when possible.
- Prioritize user-generated actions.
- Reconcile state using timestamps and deterministic rules.
