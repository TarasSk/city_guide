# /refactor-clean - Dead Code Removal

## Purpose
Identify and remove dead code, unused imports, and deprecated patterns while maintaining architectural integrity.

## Detection Phase

### 1. Find Unused Code

**Unused imports**:
```bash
# Dart analyzer shows unused imports
dart analyze

# Or use IDE (VS Code / Android Studio)
# Warnings appear on unused imports
```

**Unused classes/functions**:
```bash
# Enable unreachable_from_main lint
# Already enabled in analysis_options.yaml

# Look for unused code warnings
melos analyze | grep "unused"
```

**Dead files**:
```bash
# Find files not imported anywhere
dart pub global activate orphan
dart pub global run orphan
```

### 2. Identify Migration Artifacts

Look for old code being migrated:
- Check `lib/features/` directory (old monolithic structure)
- Compare with `packages/` structure (new modular structure)
- Find duplicate functionality

### 3. Find TODO Comments
```bash
# Find cleanup TODOs
grep -r "TODO.*remove" --include="*.dart" lib/ packages/
grep -r "TODO.*delete" --include="*.dart" lib/ packages/
grep -r "FIXME" --include="*.dart" lib/ packages/
```

## Safe Removal Process

### Step 1: Verify It's Actually Unused

Before removing:
```bash
# Search for references across codebase
grep -r "ClassName" --include="*.dart" lib/ packages/

# Check for dynamic usage (e.g., reflection, string-based)
# Less common in Flutter but possible
```

### Step 2: Check Tests
```bash
# Ensure no tests depend on it
grep -r "ClassName" --include="*.dart" test/
find packages -name "*_test.dart" -exec grep -l "ClassName" {} \;
```

### Step 3: Remove Incrementally

**For unused imports**:
1. Remove the import
2. Run `dart analyze` to verify no errors
3. Run tests: `flutter test`

**For unused classes/functions**:
1. Comment out the code (don't delete yet)
2. Run `dart analyze`
3. Run `flutter test`
4. Try to build: `flutter build apk --debug`
5. If all passes, delete the code

**For migration artifacts**:
1. Verify new implementation works
2. Remove old implementation
3. Update any documentation/comments
4. Delete old files/directories

### Step 4: Clean Up Imports

After removing code:
```bash
# Remove unused imports automatically
dart fix --apply

# Format code
dart format .
```

## Specific Cleanup Scenarios

### Scenario: Old Feature in lib/features/

The project is migrating from `lib/features/` to `packages/`:

1. **Verify new package works**:
   ```bash
   # Test new package
   cd packages/feature_name
   flutter test
   ```

2. **Check for references to old code**:
   ```bash
   grep -r "lib/features/feature_name" --include="*.dart" .
   ```

3. **Update imports** if any:
   ```dart
   // Old
   import 'package:city_guide_app/features/feature_name/feature.dart';

   // New
   import 'package:feature_name/feature_name.dart';
   ```

4. **Remove old directory**:
   ```bash
   rm -rf lib/features/feature_name
   ```

### Scenario: Unused BLoC or State

1. **Check for BlocProvider**:
   ```bash
   grep -r "FeatureBloc" --include="*.dart" lib/ packages/
   ```

2. **Check DI registration**:
   ```bash
   grep -r "registerLazySingleton.*FeatureBloc" lib/di/
   ```

3. **Remove in order**:
   - Remove from widget tree (BlocProvider)
   - Remove from DI registration
   - Remove BLoC files
   - Remove tests

### Scenario: Unused Routes

1. **Check route registration**:
   ```bash
   grep -r "featureRoute" lib/router/
   ```

2. **Check navigation calls**:
   ```bash
   grep -r "FeatureRoute" --include="*.dart" lib/ packages/
   grep -r "'/feature'" --include="*.dart" lib/ packages/
   ```

3. **Remove**:
   - Remove from router configuration
   - Remove route definition file
   - Regenerate routes: `flutter pub run build_runner build`

### Scenario: Unused Package

1. **Verify package is unused**:
   ```bash
   # Check for imports
   grep -r "package:package_name" --include="*.dart" .

   # Check pubspec dependencies
   grep -r "package_name:" */pubspec.yaml
   ```

2. **Remove**:
   - Remove from root `pubspec.yaml` (workspace and dependencies)
   - Remove from `melos.yaml`
   - Delete package directory
   - Run `melos bootstrap`

## Post-Cleanup Verification

### Run Full Quality Checks
```bash
# Format
dart format .

# Analyze
melos analyze

# Test
flutter test
melos run test  # if configured

# Build
flutter build apk --debug
```

### Verify No Regressions
```bash
# Run app
flutter run

# Test key user flows
# - Authentication
# - Navigation
# - Core features
```

### Check CI
```bash
# Push to branch and verify CI passes
git checkout -b cleanup/dead-code-removal
git add .
git commit -m "refactor: Remove unused code and imports"
git push -u origin cleanup/dead-code-removal
```

## Common Dead Code Patterns

1. **Commented out code** - Delete it (git history preserves it)
2. **Unused imports** - Auto-fixed by `dart fix`
3. **Unused parameters** - Remove or prefix with `_` if required by interface
4. **Empty constructors** - Remove if default constructor works
5. **Unused variables** - Delete or prefix with `_` if temporarily unused
6. **Old API versions** - Remove after migration complete
7. **Debug code** - Keep in `debug` package or remove if no longer needed
8. **Placeholder widgets** - Remove if feature implemented
9. **Duplicate utilities** - Keep one, remove others

## Important Notes

- **Never remove code you don't understand** - Ask or research first
- **Keep debug utilities** in the `debug` package even if not actively used
- **Preserve abstractions** even if only one implementation exists (for testing)
- **Don't remove TODOs without completing them** - Fix or keep the TODO
- **Check git history** before removing seemingly unused code - it might be seasonal/conditional
