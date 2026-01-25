# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

City Guide App is a Flutter mobile application using **Clean Architecture with package-by-feature modularization**. The project uses a **monorepo structure** managed by Melos with 10 packages, Firebase for authentication and analytics, and follows strict linting rules.

## Development Commands

### Flutter Version Management
This project uses FVM (Flutter Version Manager) with Flutter 3.38.7:
```bash
# Use the correct Flutter version
fvm flutter <command>

# Or if FVM is configured globally
flutter <command>
```

### Dependency Management
```bash
# Install all dependencies (root + all packages)
flutter pub get

# Using Melos to manage all packages
melos bootstrap
```

### Code Generation
Routes use go_router_builder and require code generation:
```bash
# Generate code for all packages
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for development
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Linting and Analysis
```bash
# Format code
dart format .

# Check formatting without modifying files
dart format --output=none --set-exit-if-changed .

# Analyze all packages using Melos
melos analyze
# Or directly:
dart pub global run melos analyze

# Run Dart Code Metrics analysis
dart pub global run dart_code_metrics:metrics analyze lib
```

### Running the App
```bash
# Run on connected device
flutter run

# Run with specific flavor (if configured)
flutter run --flavor dev

# Build release APK (Android)
flutter build apk --release

# Build iOS (no codesign for CI)
flutter build ios --release --no-codesign
```

### Testing
```bash
# Run tests for a specific package
cd packages/auth
flutter test

# Run all tests across packages (using Melos)
melos run test
```

## Architecture

### Package Structure

The project follows a **Modified Clean Architecture** with modularization:

```
city_guide_app/
├── lib/                           # Main app orchestration
│   ├── main.dart                 # Entry point (Firebase, DI, error handling)
│   ├── di/injection_container.dart  # App-level DI setup
│   ├── router/router.dart        # Route composition from features
│   └── src/application/          # Application widget with BLoC providers
└── packages/
    ├── dependencies/             # Central dependency management (exports all external deps)
    ├── core/                     # Shared infrastructure (DI, Logger, SharedPrefs, BLoC observer)
    ├── theme/                    # Shared theme resources
    ├── domain/                   # Shared domain entities (currently minimal)
    ├── data/                     # Shared data implementations (currently minimal)
    ├── presentation/             # Shared UI (SplashPage, MainPage, routing)
    ├── auth/                     # Auth feature (self-contained Clean Architecture)
    ├── login/                    # Login UI feature
    ├── home/                     # Home tab feature
    └── debug/                    # Debug utilities
```

### Key Architectural Principles

1. **Centralized Dependencies**: The `dependencies` package exports ALL external packages (flutter_bloc, go_router, get_it, firebase, etc.). Other packages import from `dependencies` rather than declaring external dependencies directly.

2. **Package Dependency Flow**:
   - `dependencies` is the foundation
   - `core` provides shared infrastructure (depends on `dependencies`)
   - Feature packages (auth, login, home) are relatively independent
   - Main app orchestrates everything via DI and routing

3. **Feature Package Structure** (self-contained Clean Architecture):
   ```
   packages/auth/
   ├── lib/src/
   │   ├── domain/          # Repository interfaces
   │   ├── data/            # Repository implementations, models
   │   └── presentation/    # BLoCs, events, states
   ```

4. **State Management**: BLoC pattern (flutter_bloc 9.0.0)
   - Global BLoCs: `AuthBloc` (auth state), `ThemeBloc` (theme mode)
   - BLoC Observer (`AppBlocObserver`) logs all transitions to console and Firebase Analytics
   - Uses sealed classes for events and states with Equatable

5. **Dependency Injection**: GetIt service locator
   - Main DI setup in `lib/di/injection_container.dart`
   - Three-phase initialization: app dependencies → repositories → global BLoCs
   - Core DI in `packages/core/lib/src/di/injection_container.dart`
   - Global `injector` instance used throughout

6. **Routing**: Type-safe routing with go_router + go_router_builder
   - Each feature package defines routes with `@TypedGoRoute` annotations
   - Routes are code-generated (*.g.dart files)
   - Main app composes routes in `lib/router/router.dart`
   - Auth guard via global redirect logic
   - StatefulShellRoute for bottom navigation (Home/Map/Profile tabs)

### Code Generation Files

These files are generated and should not be edited manually:
- `**/*.g.dart` - go_router_builder routes
- `**/*.gr.dart` - Auto_route (if used)
- `**/*.freezed.dart` - Freezed models (if used)
- `**/*.mocks.dart` - Test mocks

### Important Conventions

1. **Package Imports**: Always use `package:` imports (enforced by `always_use_package_imports` lint)

2. **BLoC Structure**:
   - Sealed classes for events and states
   - Factory constructors with const for events
   - States extend Equatable for comparison
   - Part files for event/state definitions

3. **Naming Conventions**:
   - Packages: snake_case (auth, home, login)
   - Classes: PascalCase (AuthBloc, LoginPage)
   - Files: snake_case (auth_bloc.dart, login_routes.dart)
   - Repository implementations: *Impl suffix (AuthRepositoryImpl)

4. **Route Definitions**:
   - Each feature package exports a static Routes class
   - Example: `LoginRoutes.login` contains the path string
   - Type-safe route classes generated from `@TypedGoRoute` annotations

5. **Abstraction Pattern**: Use abstract interfaces for services (LoggerAbstract, SharedPreferencesAbstract, AuthRepository) with *Impl implementations

### Strict Linting

This project uses **very strict linting rules** (see analysis_options.yaml):
- `require_trailing_commas: true` - All multi-line constructs must have trailing commas
- `prefer_single_quotes: true` - Use single quotes for strings
- `avoid_print: true` - Use logger instead of print
- `always_declare_return_types: true` - All functions must declare return types
- `prefer_final_locals: true` - Prefer final for local variables
- `prefer_const_constructors: true` - Use const constructors where possible
- Dart Code Metrics enforced with strict limits (max 4 parameters, max 160 lines, max 5 nesting levels)

Generated files are excluded from analysis.

## Firebase Setup

The app uses Firebase for:
- Authentication (Google Sign-In)
- Analytics (navigation tracking, state transitions)

Firebase configuration is in `lib/firebase_options.dart` (generated by FlutterFire CLI).

## Migration in Progress

The project is migrating from a monolithic structure to modular packages:
- Old code exists in `lib/features/` directory
- New modular structure in `packages/`
- Both structures currently coexist

## Development Workflow Commands

Custom command templates are available in `.claude/commands/` to guide common workflows:

### Feature Development
- **`/add-feature`** - Create new feature package with complete Clean Architecture structure
- **`/add-bloc`** - Add BLoC following sealed class patterns with events/states/tests
- **`/add-repository`** - Add repository following abstract interface + implementation pattern
- **`/plan`** - Plan implementation considering architecture and dependencies

### Code Quality
- **`/tdd`** - Test-driven development workflow for BLoCs and repositories
- **`/code-review`** - Comprehensive quality review checklist (linting, architecture, testing)
- **`/refactor-clean`** - Safely identify and remove dead code
- **`/format`** - Quick format and lint check before commits
- **`/generate`** - Run code generation for routes and update generated files

### Build & Testing
- **`/build-fix`** - Systematic build error diagnosis (dependencies, generation, native builds)
- **`/e2e`** - Create integration tests for complete user flows

### Dependency Management
- **`/update-deps`** - Safe dependency updates for Melos monorepo (bootstrap, Flutter version, package updates)

See `.claude/commands/README.md` for detailed usage of each command.
