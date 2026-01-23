# /build-fix - Fix Build Errors

## Purpose
Systematically diagnose and fix build errors in Flutter project.

## Diagnostic Steps

### 1. Identify Error Type

Run build and capture error:
```bash
flutter clean
flutter pub get
flutter build apk --debug 2>&1 | tee build_error.log
```

Common error categories:
- **Dependency errors**: Version conflicts, missing packages
- **Code generation errors**: Outdated or missing `.g.dart` files
- **Dart compilation errors**: Syntax, type errors
- **Native build errors**: Android/iOS specific issues
- **Linting errors**: Analysis errors blocking build

### 2. Dependency Issues

**Symptoms**: "Package not found", version conflicts, import errors

**Solutions**:
```bash
# Clean and reinstall
flutter clean
rm -rf pubspec.lock
rm -rf .dart_tool
flutter pub get

# For workspace projects
melos clean
melos bootstrap

# Check for conflicts
flutter pub deps
flutter pub outdated
```

**Common fixes**:
- Verify all packages in `pubspec.yaml` workspace list
- Check `dependency_overrides` for version pins
- Ensure `dependencies` package exports required packages
- Run `melos bootstrap` after adding new packages

### 3. Code Generation Issues

**Symptoms**: "undefined name", missing `.g.dart` files, route errors

**Solutions**:
```bash
# Clean generated files
find . -name "*.g.dart" -type f -delete
find . -name "*.gr.dart" -type f -delete

# Regenerate
flutter pub run build_runner build --delete-conflicting-outputs

# If stuck, use clean
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

**Common fixes**:
- Check `@TypedGoRoute` annotations are correct
- Verify `part` directives match file names
- Ensure build_runner is in dev_dependencies
- Check for circular dependencies in generated code

### 4. Dart Compilation Errors

**Symptoms**: Type errors, syntax errors, undefined symbols

**Solutions**:
```bash
# Run analyzer for detailed errors
dart analyze

# Check specific file
dart analyze lib/path/to/file.dart

# Fix some issues automatically
dart fix --apply
```

**Common fixes**:
- Missing imports: Add required package imports
- Type mismatches: Fix or cast types appropriately
- Null safety: Add null checks or use `!` operator judiciously
- Sealed class exhaustiveness: Handle all cases in switch expressions

### 5. Android Build Issues

**Symptoms**: Gradle errors, SDK version issues, plugin conflicts

**Solutions**:
```bash
# Clean Android build
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get

# Invalidate caches
rm -rf android/.gradle
rm -rf android/build

# Check Gradle version
cd android
./gradlew --version
```

**Common fixes**:
- Update `android/build.gradle` AGP version (currently 8.1.1)
- Update `android/gradle/wrapper/gradle-wrapper.properties` (currently 8.7)
- Check `minSdkVersion` in `android/app/build.gradle`
- Verify Firebase configuration in `android/app/google-services.json`
- Check ProGuard rules if using release builds

### 6. iOS Build Issues

**Symptoms**: CocoaPods errors, signing issues, Xcode version issues

**Solutions**:
```bash
# Clean iOS build
cd ios
rm -rf Pods
rm Podfile.lock
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get

# Update CocoaPods
sudo gem install cocoapods
```

**Common fixes**:
- Update iOS deployment target in `ios/Podfile` (minimum 11.0 for Firebase)
- Verify Firebase configuration in `ios/Runner/GoogleService-Info.plist`
- Check signing certificates in Xcode
- Update CocoaPods: `pod repo update`

### 7. Linting Errors Blocking Build

**Symptoms**: Analysis errors preventing compilation

**Solutions**:
```bash
# View all issues
melos analyze

# Fix formatting
dart format .

# Auto-fix some issues
dart fix --apply
```

**Common fixes**:
- Add trailing commas to multi-line constructs
- Change double quotes to single quotes
- Add explicit return types
- Replace `print()` with logger
- Add `const` constructors where possible

### 8. Firebase Configuration Issues

**Symptoms**: Firebase initialization errors, missing config files

**Solutions**:
```bash
# Regenerate Firebase configuration
flutterfire configure

# Verify files exist:
# - lib/firebase_options.dart
# - android/app/google-services.json
# - ios/Runner/GoogleService-Info.plist
```

### 9. FVM Flutter Version Issues

**Symptoms**: Flutter SDK version mismatch, command not found

**Solutions**:
```bash
# Use correct Flutter version
fvm use 3.38.7

# Install if not available
fvm install 3.38.7

# Use FVM for all commands
fvm flutter pub get
fvm flutter build apk
```

## Systematic Approach

1. **Read the error message carefully** - Often tells you exactly what's wrong
2. **Check the file path** - Navigate to the file mentioned
3. **Look for recent changes** - What was changed before the error?
4. **Check git diff** - `git diff` to see recent modifications
5. **Isolate the issue** - Comment out code to find the problem
6. **Search error message** - Often others have encountered the same issue
7. **Check dependencies** - Verify all imports and packages are available
8. **Clean and rebuild** - Nuclear option but often works

## Prevention

- Run `melos analyze` before committing
- Run `flutter test` before committing
- Keep dependencies up to date
- Regenerate code after route changes
- Use IDE warnings to catch issues early
