# Folder Structure

## Proposed Flutter Structure
```text
lib/
  app/
    app.dart
    router.dart
    theme/
    providers/
  core/
    constants/
    errors/
    extensions/
    network/
    services/
    utils/
    widgets/
    shared/
  features/
    authentication/
      data/
      domain/
      presentation/
      providers/
      widgets/
    onboarding/
      data/
      domain/
      presentation/
      providers/
      widgets/
    home/
      data/
      domain/
      presentation/
      providers/
      widgets/
    training/
      data/
      domain/
      presentation/
      providers/
      widgets/
    missions/
      data/
      domain/
      presentation/
      providers/
      widgets/
    workout/
      data/
      domain/
      presentation/
      providers/
      widgets/
    recovery/
      data/
      domain/
      presentation/
      providers/
      widgets/
    progress/
      data/
      domain/
      presentation/
      providers/
      widgets/
    achievements/
      data/
      domain/
      presentation/
      providers/
      widgets/
    inventory/
      data/
      domain/
      presentation/
      providers/
      widgets/
    profile/
      data/
      domain/
      presentation/
      providers/
      widgets/
    settings/
      data/
      domain/
      presentation/
      providers/
      widgets/
  shared/
    models/
    repositories/
    services/
    widgets/
```

## Architecture Principles
- Feature-first organization.
- Clear separation between data, domain, and presentation layers.
- Shared abstractions only at the core boundary.
- Providers and repositories kept close to the feature they support.
- The structure should scale to new modules such as seasons, boss challenges, and advanced AI evaluation features.
