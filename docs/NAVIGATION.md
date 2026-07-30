# Navigation

## App Shell
- Root shell contains bottom or side navigation for primary modules depending on device form factor.
- The app should use a persistent command surface and modal overlays for mission and system panels.

## Routes
- /splash
- /onboarding
- /auth
- /home
- /missions
- /training
- /recovery
- /progress
- /inventory
- /profile
- /settings
- /achievement/:id
- /title/:id
- /skill-tree
- /boss/:id
- /notifications

## Deep Links
- Mission detail links by mission id.
- Achievement detail links by achievement id.
- Title and skill links from notifications and rewards.

## Guards
- Authentication required for all protected routes.
- Onboarding required before home access.
- Restore previous route after re-authentication.

## Back Behavior
- Android back button closes transient overlays first, then returns to previous shell tab.
- iOS swipe back is supported for stack-based flows.

## Transitions
- Shell tab changes use holographic projection transitions.
- Modal windows use materialize and scan reveal animations.
- Full-page routes use panel-style entrance animations.
