# /add-feature - Add New Feature Package

## Purpose
Create a new feature package following the Clean Architecture pattern used in this project.

## Workflow

1. **Create Package Structure**
   ```bash
   mkdir -p packages/feature_name/{lib/src/{domain,data,presentation},test}
   ```

2. **Create pubspec.yaml**
   ```yaml
   name: feature_name
   description: Feature description
   version: 1.0.0
   publish_to: 'none'

   environment:
     sdk: ^3.6.1

   dependencies:
     flutter:
       sdk: flutter
     dependencies: ^1.0.0
     core: ^1.0.0
     # Add other package dependencies as needed

   dev_dependencies:
     flutter_test:
       sdk: flutter
   ```

3. **Create Package Structure**

   **Domain Layer** (`lib/src/domain/`):
   - Repository interfaces
   - Entity models (if needed)
   ```dart
   abstract class FeatureRepository {
     Future<Result> getSomething();
   }
   ```

   **Data Layer** (`lib/src/data/`):
   - Repository implementations
   - Data models
   - API clients or data sources
   ```dart
   class FeatureRepositoryImpl implements FeatureRepository {
     @override
     Future<Result> getSomething() async {
       // Implementation
     }
   }
   ```

   **Presentation Layer** (`lib/src/presentation/`):
   - BLoCs with events/states
   - Pages/Screens
   - Widgets
   ```dart
   // blocs/feature/feature_bloc.dart
   // blocs/feature/feature_event.dart
   // blocs/feature/feature_state.dart
   // pages/feature_page.dart
   ```

4. **Create Routes** (`lib/src/routes/`)
   ```dart
   import 'package:dependencies/dependencies.dart';
   import 'package:feature_name/src/presentation/pages/feature_page.dart';

   part 'feature_routes.g.dart';

   class FeatureRoutes {
     static const String feature = '/feature';
   }

   @TypedGoRoute<FeatureRoute>(path: FeatureRoutes.feature)
   class FeatureRoute extends GoRouteData {
     const FeatureRoute();

     @override
     Widget build(BuildContext context, GoRouterState state) {
       return const FeaturePage();
     }
   }
   ```

5. **Create Main Export File** (`lib/feature_name.dart`)
   ```dart
   library feature_name;

   export 'src/domain/feature_repository.dart';
   export 'src/data/feature_repository_impl.dart';
   export 'src/presentation/blocs/feature/feature_bloc.dart';
   export 'src/presentation/pages/feature_page.dart';
   export 'src/routes/feature_routes.dart';
   ```

6. **Add to Workspace**
   - Add to `melos.yaml` packages list
   - Add to root `pubspec.yaml` workspace and dependencies
   - Run `melos bootstrap`

7. **Register in DI** (`lib/di/injection_container.dart`)
   ```dart
   // Register repository
   injector.registerLazySingleton<FeatureRepository>(
     () => FeatureRepositoryImpl(),
   );

   // Register BLoC if global
   injector.registerLazySingleton(
     () => FeatureBloc(repository: injector()),
   );
   ```

8. **Add Routes to Router** (`lib/router/router.dart`)
   ```dart
   import 'package:feature_name/feature_name.dart';

   // Add to routes list
   $featureRoute,
   ```

9. **Generate Code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

10. **Verify**
    - Package compiles
    - Routes are accessible
    - No linting errors
    - Tests are set up (even if placeholder)
