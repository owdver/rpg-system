# RPG System

An AI-native fitness operating system that transforms workouts into an immersive RPG experience. Built with Flutter, this app makes users feel as though they've awakened a sophisticated system that observes, evaluates, and guides their physical development.

## Features

- **Adaptive Mission Engine** — AI-generated missions tailored to your fitness level and goals
- **Biometric Evaluation** — Health Connect (Android) and Apple HealthKit (iOS) integration
- **XP & Progression Systems** — Level up, unlock skill trees, and earn titles
- **Achievement System** — Complete challenges and track seasonal milestones
- **Offline-First Architecture** — Your progress is always saved, even without connectivity
- **Holographic UI** — Futuristic interface with glassmorphism, animations, and dynamic lighting

## Technical Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter |
| Language | Dart |
| State Management | Riverpod |
| Navigation | go_router |
| Backend | Firebase (Auth, Firestore, Cloud Messaging, Storage) |
| Local Storage | Hive / Drift (SQLite) |
| Health Data | Health Connect, Apple HealthKit |

## Project Structure

The codebase follows a feature-first Clean Architecture pattern:

```text
lib/
├── app/              # App entry point, routing, theme
├── core/             # Shared services, utilities, constants
└── features/
    ├── authentication/
    ├── onboarding/
    ├── home/
    ├── training/
    ├── missions/
    ├── workout/
    ├── recovery/
    ├── progress/
    ├── achievements/
    ├── inventory/
    ├── profile/
    └── settings/
```

Each feature module contains its own `data/`, `domain/`, and `presentation/` layers.

## Getting Started

### Prerequisites

- Flutter SDK 3.5.4 or higher
- Dart SDK 3.5.4 or higher
- iOS simulator or Android emulator (or physical device for full functionality)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/your-org/rpg-system.git
cd rpg-system
```

2. Install dependencies:

```bash
flutter pub get
```

3. Configure Firebase:

   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android and iOS apps to your project
   - Download the configuration files:
     - `android/app/google-services.json` for Android
     - `ios/Runner/GoogleService-Info.plist` for iOS
   - Enable Authentication, Firestore, and Cloud Messaging

4. Run the app:

```bash
flutter run
```

### Code Generation

Some files require code generation. Run the build runner after modifying model files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Documentation

Detailed documentation is available in the [`docs/`](docs/) directory:

| Document | Description |
|----------|-------------|
| [VISION.md](docs/VISION.md) | Product vision and design philosophy |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Technical architecture and data flow |
| [FOLDER_STRUCTURE.md](docs/FOLDER_STRUCTURE.md) | Codebase organization |
| [DEVELOPMENT_RULES.md](DEVELOPMENT_RULES.md) | Engineering standards and guidelines |
| [STATE_MANAGEMENT.md](docs/STATE_MANAGEMENT.md) | State management approach |
| [NAVIGATION.md](docs/NAVIGATION.md) | Navigation and routing |
| [DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md) | UI components and design tokens |
| [ANIMATION_SYSTEM.md](docs/ANIMATION_SYSTEM.md) | Animation guidelines |
| [ACCESSIBILITY.md](docs/ACCESSIBILITY.md) | Accessibility features |
| [OFFLINE_MODE.md](docs/OFFLINE_MODE.md) | Offline functionality |
| [SECURITY.md](docs/SECURITY.md) | Security considerations |

## Testing

Run the test suite:

```bash
flutter test
```

Run with coverage:

```bash
flutter test --coverage
```

## Design Philosophy

Every screen should feel like interacting with a futuristic AI system:

- **Glassmorphism** — Frosted glass effects with depth
- **Dynamic lighting** — Bloom and energy effects
- **Intentional motion** — Smooth, meaningful transitions
- **Reduced motion support** — Respects user accessibility preferences

See [DEVELOPMENT_RULES.md](DEVELOPMENT_RULES.md) for the complete set of UI and engineering standards.

## License

This project is proprietary. All rights reserved.
