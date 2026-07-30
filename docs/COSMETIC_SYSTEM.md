# Cosmetic System

## Purpose
Provide visual personalization and prestige without introducing pay-to-win mechanics.

## User Flow
1. User unlocks a cosmetic reward.
2. User previews or applies it.
3. UI updates the active visual theme.

## UI Layout
- Cosmetic card list with preview overlay and selection state.

## State Management
- Cosmetic provider handles active cosmetics, unlocks, and theme application.

## Data Model
- Cosmetic definitions with asset id, rarity, category, unlock criteria, and preview configuration.

## API Interaction
- Fetch cosmetic definitions and sync active selection.

## Offline Behavior
- Apply cached cosmetics locally and queue selection sync.

## Error Handling
- Missing asset, invalid selection, unsupported device theme.

## Loading States
- Preview loading skeleton.

## Empty States
- No cosmetics available.

## Edge Cases
- Incompatible cosmetic combinations, asset fallback.

## Animation
- Preview shimmer, equip pulse, ambient glow.

## Sound
- Subtle preview and equip tones.

## Haptics
- Soft selection feedback.

## Accessibility
- Provide text descriptions and contrast-safe preview state.

## Performance Considerations
- Optimize asset loading and pre-cache common previews.

## Acceptance Criteria
- Cosmetics can be previewed and equipped safely.
