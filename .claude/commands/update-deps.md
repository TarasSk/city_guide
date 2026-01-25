# /update-deps - Safe Dependency Updates

## Purpose
Manage dependencies safely across the Melos monorepo, ensuring consistency across all packages.

## Quick Commands

### Bootstrap After Changes
```bash
# After any pubspec.yaml changes
melos bootstrap

# Or manually
flutter pub get  # Root project
melos bootstrap  # All packages
```

### Update All Dependencies
```bash
# Update all packages to latest compatible versions
flutter pub upgrade
melos bootstrap
```

### Update Specific Package
```bash
# Update in specific package
cd packages/package_name
flutter pub upgrade package_name
cd ../..
melos bootstrap
```

## Workflow

### 1. Update External Dependencies

**In `packages/dependencies/pubspec.yaml`**:
```yaml
dependencies:
  flutter_bloc: ^9.0.0  # Update version here
  go_router: ^15.0.0
  # ... other deps
```

**Then run**:
```bash
cd packages/dependencies
flutter pub upgrade
cd ../..
melos bootstrap
```

### 2. Update Flutter Version

**Check current version**:
```bash
fvm list
fvm flutter --version
```

**Update FVM Flutter**:
```bash
# Install new Flutter version
fvm install 3.XX.X

# Update .fvmrc
echo "3.XX.X" > .fvmrc

# Update in pubspec.yaml files
# Update environment.sdk in all pubspec.yaml files

# Bootstrap with new version
fvm flutter pub get
melos bootstrap
```

### 3. Verify Compatibility

**Check for issues**:
```bash
# Analyze all packages
melos analyze

# Check for outdated packages
flutter pub outdated

# Run tests
melos run test
```

### 4. Update Internal Package Dependencies

**When updating package versions**:
```yaml
# In packages/feature/pubspec.yaml
dependencies:
  core: ^1.1.0  # Update internal package version
  dependencies: ^1.0.0
```

**Then bootstrap**:
```bash
melos bootstrap
```

## Common Dependency Patterns

### Adding New External Dependency

1. **Add to `packages/dependencies/pubspec.yaml`**:
```yaml
dependencies:
  new_package: ^1.0.0
```

2. **Export in `packages/dependencies/lib/dependencies.dart`**:
```dart
export 'package:new_package/new_package.dart';
```

3. **Bootstrap**:
```bash
cd packages/dependencies
flutter pub get
cd ../..
melos bootstrap
```

4. **Use in other packages**:
```dart
import 'package:dependencies/dependencies.dart';
// new_package is now available
```

### Adding New Internal Package

1. **Create package structure**
2. **Add to `melos.yaml`**:
```yaml
packages:
  - packages/new_package
```

3. **Add to root `pubspec.yaml` workspace**:
```yaml
workspace:
  - packages/new_package
```

4. **Bootstrap**:
```bash
melos bootstrap
```

## Common Issues

### Issue: Version conflict between packages
**Symptoms**:
```
Because package_a depends on dep ^1.0.0 and package_b depends on dep ^2.0.0, version solving failed.
```

**Solution**: Use consistent versions across all packages
```bash
# Check which packages have conflicts
flutter pub deps

# Update to compatible versions in packages/dependencies
cd packages/dependencies
flutter pub upgrade
```

### Issue: "Package doesn't exist" after adding to melos.yaml
**Solution**: Bootstrap the workspace
```bash
melos bootstrap
flutter clean
flutter pub get
```

### Issue: Build runner fails after dependency update
**Solution**: Clean and regenerate
```bash
flutter pub run build_runner clean
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: FVM version mismatch
**Symptoms**:
```
Flutter SDK version mismatch
```

**Solution**: Use FVM consistently
```bash
# Always use fvm prefix
fvm flutter pub get
fvm flutter run

# Or configure global FVM
fvm global 3.38.7
fvm use 3.38.7
```

### Issue: Melos bootstrap hangs or fails
**Solution**: Clean and retry
```bash
# Clean all packages
melos clean

# Remove lock files
find . -name "pubspec.lock" -delete

# Bootstrap fresh
melos bootstrap
```

## Best Practices

### Version Management
- Pin exact versions for critical packages in `dependencies` package
- Use caret (^) notation for flexible updates
- Keep all internal packages in sync (same version)
- Document breaking changes in CHANGELOG.md

### Update Strategy
1. Update `dependencies` package first
2. Run `melos analyze` to check for breaking changes
3. Fix compilation errors in feature packages
4. Run all tests
5. Update documentation if API changes

### Dependency Organization
- **External dependencies**: Only in `packages/dependencies`
- **Internal dependencies**: Feature packages depend on `core` and `dependencies`
- **Dev dependencies**: Can be in individual packages (flutter_test, mockito)

## Pre-commit Checklist

Before committing dependency changes:
```bash
# 1. Bootstrap
melos bootstrap

# 2. Verify compilation
flutter analyze

# 3. Run tests
melos run test

# 4. Check formatting
dart format .

# 5. Verify app runs
flutter run
```

## CI/CD Considerations

In CI pipelines, always:
```bash
# Install FVM Flutter version
fvm install

# Get dependencies
fvm flutter pub get
melos bootstrap

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Build
flutter build apk --release
```

## Useful Commands

```bash
# Show dependency tree
flutter pub deps

# Show outdated packages
flutter pub outdated

# Upgrade to latest compatible
flutter pub upgrade

# Downgrade if needed
flutter pub downgrade

# Clean everything
melos clean
flutter clean

# Full reset
melos clean
find . -name "pubspec.lock" -delete
rm -rf .dart_tool
melos bootstrap
```
