# Architecture

## Technical Stack
- Flutter latest stable
- Dart
- Riverpod for state and dependency injection
- go_router for navigation
- Firebase Authentication for identity
- Cloud Firestore for cloud data
- Firebase Storage for media and artifacts
- Firebase Cloud Messaging for push notifications
- Health Connect for Android health data
- Apple HealthKit for iOS health data
- Hive or Isar for local offline persistence

## Architectural Style
System uses Clean Architecture, MVVM, feature-first modularization, and repository-based abstraction to keep core business logic independent from Flutter and platform services.

## Layered Structure
### Presentation Layer
- Screens, widgets, route handlers, controllers, and view models
- Responsible for rendering state and translating user interaction into domain actions

### Domain Layer
- Entities, value objects, use cases, domain services, and progression rules
- Contains all gameplay logic, AI recommendation logic, stat calculations, and mission generation rules

### Data Layer
- Repositories, remote data sources, local data sources, mappers, and caching adapters
- Handles Firestore, Firebase Storage, Health Connect, Apple HealthKit, Hive/Isar, and sync reconciliation

### Infrastructure Layer
- Platform integrations, network clients, push delivery, analytics hooks, permissions management, and background sync services

## Feature-First Folder Structure
The app should be organized around capabilities and user workflows, not page-by-page UI only. A scalable structure should follow this pattern:

lib/
  core/
    shared/
    services/
    utils/
    theme/
    routing/
    analytics/
  features/
    authentication/
    onboarding/
    home/
    training/
    missions/
    workout/
    recovery/
    progress/
    achievements/
    inventory/
    profile/
    settings/

Each feature contains:
- data/
- domain/
- presentation/
- widgets/
- providers/
- models/
- repositories/

## State Management
Riverpod should manage UI state, domain state, and infrastructure state with explicit providers for authentication, missions, workout sessions, sync state, recovery state, and progression state.

## Navigation
go_router should be used for shell navigation, deep linking, and route-level transitions between mission views, progress views, and system screens.

## Data Flow
1. Health or user input enters the app through a platform integration adapter.
2. The domain layer transforms raw data into readiness, recovery, and performance signals.
3. The AI recommendation engine generates mission updates and progression state.
4. The repository layer persists state locally and queues remote sync.
5. UI reacts to updated providers through a reactive event stream.

## Security and Privacy
- Firebase Authentication manages account identity.
- Health data access is explicit, consent-based, and scoped to the current session or feature.
- Local storage should minimize sensitive data and apply encryption where supported.
- Sync operations should include audit metadata and conflict-aware reconciliation.

## Scalability and Extensibility
The architecture should support the future addition of new features, new AI systems, richer progression mechanics, and expanded integrations without creating tight coupling between presentation and core logic.
