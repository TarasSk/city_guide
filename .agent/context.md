# City Guide App - Project Context

> This file provides context about the project structure, conventions, and important information for AI assistants.

## Overview

**City Guide App** - A Flutter mobile application for discovering and exploring city locations/points of interest.

## Tech Stack

- **Framework**: Flutter (Dart SDK >=3.0.0 <4.0.0)
- **State Management**: flutter_bloc (BLoC pattern)
- **Dependency Injection**: GetIt (`injector<T>()` pattern in `core` package)
- **Backend**: Firebase
- **Build System**: Melos (monorepo management)
- **Platforms**: iOS, Android, Web

## Architecture

This project follows a **modular monorepo architecture** with feature-based separation:

```
city_guide/
├── lib/                    # Main app entry & feature implementations
│   ├── main.dart           # App entry point, Firebase init, DI setup
│   ├── features/           # Feature modules (auth, home, login, debug, map)
│   ├── presentation/       # Shared presentation layer
│   └── src/                # Application core (application, shared)
│
├── packages/               # Modular packages
│   ├── core/               # Core utilities, DI, logging, common abstractions
│   ├── data/               # Data layer (repositories implementations, APIs)
│   ├── domain/             # Domain layer (entities, use cases, repository interfaces)
│   ├── presentation/       # Shared presentation utilities
│   ├── theme/              # App theming & design system
│   ├── auth/               # Authentication feature
│   ├── login/              # Login feature
│   ├── home/               # Home feature
│   └── debug/              # Debug utilities
```

### Layer Responsibilities

| Package | Responsibility |
|---------|----------------|
| `core` | DI container (`init()`, `injector`), logging, base classes |
| `domain` | Business entities, use cases, repository contracts |
| `data` | Repository implementations, API clients, data sources |
| `presentation` | Shared widgets, UI utilities |
| `theme` | Colors, typography, design tokens |
| Feature packages (`auth`, `login`, `home`) | Feature-specific BLoCs, screens, widgets |

## Conventions

### Dependency Injection
- Register dependencies in `core` package using `init()` function
- Access dependencies via `injector<T>()` pattern
- BLoC observer registered globally: `Bloc.observer = injector<AppBlocObserver>()`

### Logging
- Use `injector<LoggerAbstract>()` for logging
- Available methods: `.fatal()`, `.error()`, `.warning()`, `.info()`, `.debug()`

### State Management
- Use BLoC/Cubit pattern for state management
- BLoCs live in their respective feature packages

### Routing
- **Library**: `go_router` with `go_router_builder` for code generation.
- **Structure**: Decentralized. Each feature package (`home`, `login`, `presentation`) defines its own routes using `@TypedGoRoute`.
- **Main Router**: `lib/router/router.dart` composes the main `GoRouter` using these feature modules.
- **Generation**: Run `dart run build_runner build` in feature packages to generate route code.

### Code Analysis
- Custom analysis rules in `analysis_options.yaml`
- Dart Code Metrics integration for quality checks
- Run analysis: `melos run analyze`

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run Melos commands
melos bootstrap    # Bootstrap all packages
melos run analyze  # Run code analysis

# Generate routes (in a feature package)
dart run build_runner build

# iOS specific
cd ios && pod install
```

## Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/router/router.dart` | Main App Router configuration |
| `lib/firebase_options.dart` | Firebase configuration |
| `melos.yaml` | Melos monorepo configuration |
| `packages/core/` | Core DI and utilities |
| `packages/*/lib/src/routes/` | Feature-specific route definitions |

---

## Project-Specific Notes

<!-- Add any project-specific notes, decisions, or constraints below -->

### TODO: Add your notes here
- [ ] Document API endpoints and data models
- [x] Document navigation/routing approach
- [ ] Document testing strategy
- [ ] Add any environment-specific configurations
