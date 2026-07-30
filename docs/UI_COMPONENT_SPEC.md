# UI Component Specification

## Overview
This document defines every reusable UI building block required to implement the System experience. Each component must support immersive motion, contextual feedback, and accessibility while remaining modular and themeable.

## Core Components

### 1. XP Bar
- Purpose: Display current XP progress toward the next level.
- Properties: value, maxValue, mode, showGlow, compact, label.
- Internal state: animated progress, overflow pulse, completion state.
- Animations: materialize on mount, overflow burst at threshold, count-up on change.
- Gesture behavior: tap opens progression detail panel.
- Variants: compact, cinematic, full-screen reveal.
- Accessibility: screen reader label, reduced motion support, high contrast mode.
- Responsive behavior: adapts to narrow width by collapsing labels.
- Acceptance criteria: updates smoothly and reveals completion state with system feedback.

### 2. Stat Bar
- Purpose: Display primary capability values such as Strength, Endurance, Recovery, Mobility, Focus, and Precision.
- Properties: label, value, target, color, trend, showSparkline.
- Internal state: current value, delta indicator, highlight state.
- Animations: stat increase pulse, sparkline sweep, glow accent.
- Gesture behavior: long press reveals contextual explanation.
- Variants: compact, detailed, hero mode.
- Accessibility: numeric values announced, trend described.
- Responsive behavior: grid-based layout on larger screens, stacked on narrow screens.
- Acceptance criteria: supports value changes, trend display, and clear visual hierarchy.

### 3. Mission Window
- Purpose: Present active, upcoming, or completed missions.
- Properties: title, objective, difficulty, reward, status, timer.
- Internal state: loading, active, completed, failed.
- Animations: window materialize, scan reveal, particle burst on completion.
- Gesture behavior: tap opens mission detail, swipe dismisses transient alerts.
- Variants: briefing, active, reward, failed.
- Accessibility: focus order, semantic heading, clear status text.
- Responsive behavior: expands to full focus view on tablet.
- Acceptance criteria: mission state is clear and updates with system events.

### 4. Notification Window
- Purpose: Show mission alerts, recovery warnings, achievement reveals, and system messages.
- Properties: severity, title, body, actionLabel, icon, duration.
- Internal state: queued, visible, dismissed, expired.
- Animations: projection in, energy sweep, dissolve out.
- Gesture behavior: tap opens target screen, swipe dismisses.
- Variants: info, warning, success, critical.
- Accessibility: live region support and screen-reader priority.
- Responsive behavior: anchored to bottom or top depending on device width.
- Acceptance criteria: notifications are readable, dismissible, and routed correctly.

### 5. Floating System Window
- Purpose: Create floating surfaces that behave like holographic control panels.
- Properties: title, content, width, height, cornerStyle, anchor, draggable.
- Internal state: focused, pinned, minimized, closed.
- Animations: materialize, scan reveal, particle trail on open/close.
- Gesture behavior: drag, tap, and dismiss interactions.
- Variants: compact panel, modal, diagnostic panel.
- Accessibility: keyboard support, focus trap when modal.
- Responsive behavior: adjusts to safe area and screen size.
- Acceptance criteria: windows remain usable and visually consistent across layouts.

### 6. Skill Card
- Purpose: Display a skill node in the progression tree.
- Properties: title, description, unlockLevel, status, branch, branchColor.
- Internal state: locked, unlocked, active, selected.
- Animations: pulse, branch glow, unlock burst.
- Gesture behavior: tap selects node; long press reveals dependency info.
- Variants: locked, unlocked, active, mastered.
- Accessibility: labels and state announcements.
- Responsive behavior: scales and reflows for small screens.
- Acceptance criteria: unlock state and dependency chain are easy to understand.

### 7. Boss Mission Card
- Purpose: Present high-stakes seasonal or weekly challenges.
- Properties: title, objective, timeWindow, reward, difficulty, status.
- Internal state: pending, active, completed, failed.
- Animations: cinematic reveal, pulse, energy ring.
- Gesture behavior: tap opens challenge detail.
- Variants: upcoming, active, completed.
- Accessibility: clear heading, icons, and focus handling.
- Responsive behavior: uses a stacked card layout on smaller screens.
- Acceptance criteria: the challenge urgency and reward are immediately understandable.

### 8. Recovery Report
- Purpose: Summarize readiness, fatigue, sleep, and recovery guidance.
- Properties: readinessScore, fatigueScore, sleepSummary, recommendations.
- Internal state: loading, stale, refreshed, warning.
- Animations: scan sweep, pulse ring, diagnostic panel reveal.
- Gesture behavior: horizontal swipe between recovery views.
- Variants: daily, weekly, monthly.
- Accessibility: summary first, details later.
- Responsive behavior: collapses into compact cards on small screens.
- Acceptance criteria: presents actionable insight with readable severity.

### 9. Achievement Reveal
- Purpose: Celebrate milestone unlocks and reward events.
- Properties: title, description, icon, reward, rarity.
- Internal state: revealed, dismissed, queued.
- Animations: particle burst, ring pulse, scanline flare.
- Gesture behavior: tap opens detail view or closes reveal.
- Variants: common, rare, legendary.
- Accessibility: announcements with clear completion language.
- Responsive behavior: centers on screen with safe area margins.
- Acceptance criteria: unlock feels rewarding and noticable without overwhelming the user.

### 10. Inventory Item
- Purpose: Show cosmetic or reward artifacts earned by the user.
- Properties: name, rarity, unlocked, equipped, previewAsset.
- Internal state: selected, equipped, previewing.
- Animations: hover shimmer, equip pulse, ambient glow.
- Gesture behavior: tap preview, double tap equip.
- Variants: cosmetic, badge, title, effect.
- Accessibility: descriptive labels and focus indicators.
- Responsive behavior: grid layout with variable item sizes.
- Acceptance criteria: selection and equip states are crystal clear.

### 11. Circular Workout HUD
- Purpose: Present real-time training state.
- Properties: currentExercise, elapsedTime, remainingSets, progressRatio, heartRate.
- Internal state: active, paused, completed, error.
- Animations: ring sweep, pulse, energy ripple.
- Gesture behavior: tap pause/resume, long press end session.
- Variants: live, paused, complete, warning.
- Accessibility: spoken updates and large touch targets.
- Responsive behavior: scales with safe areas and orientation changes.
- Acceptance criteria: essential workout information is visible without clutter.

### 12. Animated Counter
- Purpose: Display dynamic numeric values such as XP gains, reps, and combo count.
- Properties: value, prefix, suffix, animationStyle.
- Internal state: previous value, current value, animation active.
- Animations: count-up with scalable motion and burst.
- Gesture behavior: none.
- Variants: standard, impact, micro.
- Accessibility: screen-reader announcement when value changes significantly.
- Responsive behavior: adjusts font size and cadence to fit width.
- Acceptance criteria: number changes are readable and legible.

### 13. Combo Indicator
- Purpose: Communicate streak or rhythm performance during a workout.
- Properties: value, level, color, label.
- Internal state: active, maxed, cooling down.
- Animations: pulse, glow, particle trail.
- Gesture behavior: none.
- Variants: low, high, max.
- Accessibility: status label and color independent indication.
- Responsive behavior: reflows vertically in compact layouts.
- Acceptance criteria: indicates performance momentum clearly.

### 14. Rank Badge
- Purpose: Show the user’s current rank or tier.
- Properties: rankName, rankTier, icon, accentColor.
- Internal state: unlocked, highlighted, selected.
- Animations: spin-in or orbit reveal on unlock.
- Gesture behavior: tap opens rank details.
- Variants: standard, prestige, new unlock.
- Accessibility: announced as status and not decorative.
- Responsive behavior: scales down while retaining legibility.
- Acceptance criteria: rank progression is clear and visually distinct.

### 15. Title Banner
- Purpose: Display earned titles and current active title.
- Properties: titleName, description, unlockCondition, active.
- Internal state: active, available, locked.
- Animations: scan reveal and glow emission on unlock.
- Gesture behavior: tap opens title detail.
- Variants: active, locked, newly earned.
- Accessibility: title text and description available to assistive tech.
- Responsive behavior: supports compact and expanded layouts.
- Acceptance criteria: the title communicates identity and progression clearly.
