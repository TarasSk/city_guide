# /e2e - End-to-End Test Generation

## Purpose
Create integration tests for complete user flows in this Flutter application.

## Setup Integration Tests

### 1. Create Integration Test Directory
```bash
mkdir -p integration_test
```

### 2. Add Integration Test Dependencies

Add to root `pubspec.yaml`:
```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
```

### 3. Run Integration Tests
```bash
# Run all integration tests
flutter test integration_test

# Run specific test
flutter test integration_test/auth_flow_test.dart

# Run on specific device
flutter test integration_test --device-id=<device_id>
```

## Test Structure

### Basic Integration Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:city_guide_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Feature Flow E2E Tests', () {
    testWidgets('User completes feature flow', (tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Test steps
      // ...

      // Verify outcome
      expect(find.text('Success'), findsOneWidget);
    });
  });
}
```

## Common Test Flows

### Authentication Flow Test

```dart
// integration_test/auth_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:city_guide_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('User can login with Google', (tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();

      // Should show splash screen
      expect(find.byType(SplashPage), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should navigate to login if not authenticated
      expect(find.byType(LoginPage), findsOneWidget);

      // Tap Google sign-in button
      final googleButton = find.byKey(const Key('google_sign_in_button'));
      expect(googleButton, findsOneWidget);
      await tester.tap(googleButton);
      await tester.pumpAndSettle();

      // Note: Actual Google sign-in requires mock or test account
      // For now, verify button tap triggers loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('User can logout', (tester) async {
      // Assuming user is logged in
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile (assuming bottom nav)
      final profileTab = find.byIcon(Icons.person);
      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      // Tap logout button
      final logoutButton = find.byKey(const Key('logout_button'));
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      // Should navigate back to login
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
```

### Navigation Flow Test

```dart
// integration_test/navigation_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:city_guide_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation Flow', () {
    testWidgets('User can navigate between tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Assuming authenticated and on main page
      expect(find.byType(MainPage), findsOneWidget);

      // Verify home tab is active
      expect(find.byType(HomePage), findsOneWidget);

      // Tap map tab
      await tester.tap(find.text('Map'));
      await tester.pumpAndSettle();
      expect(find.byType(MapPage), findsOneWidget);

      // Tap profile tab
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.byType(ProfilePage), findsOneWidget);

      // Return to home tab
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
```

### Feature Flow Test

```dart
// integration_test/feature_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:city_guide_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Feature Flow', () {
    testWidgets('User completes feature workflow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Navigate to feature
      await tester.tap(find.text('Feature'));
      await tester.pumpAndSettle();

      // 2. Interact with feature
      await tester.enterText(
        find.byKey(const Key('input_field')),
        'Test input',
      );
      await tester.pumpAndSettle();

      // 3. Submit
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pumpAndSettle();

      // 4. Verify result
      expect(find.text('Success'), findsOneWidget);
    });
  });
}
```

## Test Utilities

### Create Test Helpers

```dart
// integration_test/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestHelpers {
  /// Wait for loading to complete
  static Future<void> waitForLoading(WidgetTester tester) async {
    await tester.pumpAndSettle();
    while (tester.any(find.byType(CircularProgressIndicator))) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// Scroll until widget is visible
  static Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder finder,
    Finder scrollable,
  ) async {
    await tester.dragUntilVisible(
      finder,
      scrollable,
      const Offset(0, -250),
    );
  }

  /// Enter text and submit
  static Future<void> enterAndSubmit(
    WidgetTester tester,
    Key fieldKey,
    String text,
    Key submitKey,
  ) async {
    await tester.enterText(find.byKey(fieldKey), text);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(submitKey));
    await tester.pumpAndSettle();
  }

  /// Verify navigation
  static void verifyRoute(String routePath) {
    // Implementation depends on how routing is exposed
  }
}
```

## Mocking for Integration Tests

### Mock Firebase Auth (if needed)

```dart
// integration_test/mocks/mock_firebase_auth.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class MockFirebaseAuth {
  static Future<void> setupMocks() async {
    // Use Firebase emulator or mock
    await Firebase.initializeApp();

    // Or set up test account
    // final auth = FirebaseAuth.instance;
    // await auth.signInWithEmailAndPassword(
    //   email: 'test@example.com',
    //   password: 'testpassword',
    // );
  }
}
```

## Running Tests

### Local Testing
```bash
# Run all integration tests
flutter test integration_test

# Run with specific flavor
flutter test integration_test --flavor dev

# Run on real device
flutter devices
flutter test integration_test --device-id=<device_id>
```

### CI/CD Integration

Add to `.github/workflows/build_and_test.yml`:
```yaml
integration_tests:
  name: Integration Tests
  runs-on: macos-latest

  steps:
    - uses: actions/checkout@v4

    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.38.7'

    - name: Install dependencies
      run: flutter pub get

    - name: Start iOS Simulator
      run: |
        xcrun simctl boot "iPhone 14" || true

    - name: Run integration tests
      run: flutter test integration_test
```

## Best Practices

1. **Keep tests independent** - Each test should set up its own state
2. **Use test keys** - Add `Key` to widgets for easy finding
3. **Handle async operations** - Use `pumpAndSettle()` appropriately
4. **Test happy and error paths** - Cover both success and failure scenarios
5. **Mock external services** - Don't rely on real APIs in tests
6. **Use descriptive test names** - Make it clear what's being tested
7. **Clean up after tests** - Reset state between tests
8. **Test on real devices** - Simulators don't catch everything
9. **Keep tests fast** - Avoid unnecessary waits
10. **Group related tests** - Use `group()` for organization

## Common Patterns

### Pattern: Authenticated Flow
```dart
Future<void> loginTestUser(WidgetTester tester) async {
  // Implement login flow
  // This becomes a reusable helper
}
```

### Pattern: Feature Setup
```dart
Future<void> setupFeatureData(WidgetTester tester) async {
  // Set up required data for feature testing
}
```

### Pattern: Verify State
```dart
void verifyFeatureState(WidgetTester tester, String expectedState) {
  expect(find.byKey(Key('state_$expectedState')), findsOneWidget);
}
```

## Debugging Integration Tests

```bash
# Run with verbose logging
flutter test integration_test --verbose

# Take screenshots during test failures
# Add to test: await tester.takeScreenshot('failure_state');

# Use debug mode
flutter test integration_test --debug
```
