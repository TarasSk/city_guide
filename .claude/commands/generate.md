# /generate - Run Code Generation

## Purpose
Run code generation for routes and other code-generated files in this project.

## Quick Commands

### Generate All Files
```bash
# Generate code for all packages
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on file changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Clean and Regenerate
```bash
# If generation is stuck or has conflicts
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Generate for Specific Package
```bash
cd packages/package_name
flutter pub run build_runner build --delete-conflicting-outputs
cd ../..
```

## What Gets Generated

### Route Files (go_router_builder)
**Pattern**: `*_routes.g.dart`

**Trigger**: Changes to files with `@TypedGoRoute` annotations

**Example**:
```dart
// lib/src/routes/feature_routes.dart
@TypedGoRoute<FeatureRoute>(path: '/feature')
class FeatureRoute extends GoRouteData {
  // ...
}

// Generated: lib/src/routes/feature_routes.g.dart
// Contains extension methods like .go(), .push()
```

### Other Potential Generated Files
- `*.gr.dart` - Auto_route (if used)
- `*.freezed.dart` - Freezed models (if used)
- `*.g.dart` - JSON serialization (if used)
- `*.mocks.dart` - Mockito mocks (for tests)

## When to Run Generation

### Must Run After:
1. **Adding new routes** with `@TypedGoRoute`
2. **Modifying route parameters** (path, query params)
3. **Changing route class names**
4. **Adding new feature packages with routes**

### Should Run After:
- Pulling changes from git that include route changes
- Switching branches with route modifications
- Merging branches with route conflicts

## Verification

After generation, check:
```bash
# Verify no compilation errors
dart analyze

# Verify generated files exist
find . -name "*.g.dart" -not -path "*/.*"

# Try to build
flutter build apk --debug
```

## Common Issues

### Issue: "Conflicting outputs"
**Solution**: Use `--delete-conflicting-outputs` flag
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Generation hangs or stuck
**Solution**: Clean and rebuild
```bash
flutter pub run build_runner clean
rm -rf .dart_tool/build
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Generated files not found
**Solution**: Check `part` directive matches generated file name
```dart
// feature_routes.dart
part 'feature_routes.g.dart'; // Must match generated file name
```

### Issue: Import errors in generated files
**Solution**: Ensure all required imports are in source file
```dart
import 'package:dependencies/dependencies.dart'; // Provides go_router
import 'package:feature/src/presentation/pages/feature_page.dart';
```

### Issue: Routes not registering
**Solution**: Add generated route to router
```dart
// lib/router/router.dart
routes: [
  $featureRoute, // Exported from generated file
]
```

## CI/CD Considerations

In CI pipelines, always run generation before building:
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --release
```

## Watch Mode for Development

For active development with frequent route changes:
```bash
# In separate terminal
flutter pub run build_runner watch --delete-conflicting-outputs

# Make changes to routes
# Generated files update automatically
```

## Generated File Management

### Version Control
- Generated files (`.g.dart`) are in `.gitignore`
- Each developer runs generation locally
- CI/CD runs generation during builds

### Exclusions
Generated files are excluded from:
- Git (in `.gitignore`)
- Linting (in `analysis_options.yaml`)
- Code metrics (in `dart_code_metrics` config)

**Never manually edit generated files** - they will be overwritten on next generation.
