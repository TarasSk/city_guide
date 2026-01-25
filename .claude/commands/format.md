# /format - Quick Format & Lint Check

## Purpose
Fast pre-commit quality check for formatting and linting across the entire project.

## Quick Commands

### Full Quality Check
```bash
# Format code
dart format .

# Analyze all packages
melos analyze

# Run code metrics
dart pub global run dart_code_metrics:metrics analyze lib
```

### Single Command (Recommended)
```bash
# Chain all checks together
dart format . && melos analyze && dart pub global run dart_code_metrics:metrics analyze lib
```

## Individual Commands

### 1. Format Code
```bash
# Format all Dart files
dart format .

# Format specific directory
dart format lib/

# Format specific file
dart format lib/main.dart

# Check without modifying (dry run)
dart format --output=none --set-exit-if-changed .
```

**What it fixes**:
- Indentation (2 spaces)
- Trailing commas
- Line length (80 chars default)
- Whitespace and newlines

### 2. Dart Analyze
```bash
# Analyze all packages using Melos
melos analyze

# Or analyze current package only
dart analyze

# Analyze with verbose output
dart analyze --verbose

# Analyze specific directory
dart analyze lib/
```

**What it checks**:
- Linting rules from analysis_options.yaml
- Type errors
- Unused imports
- Dead code
- Potential bugs

### 3. Code Metrics
```bash
# Run Dart Code Metrics analysis
dart pub global run dart_code_metrics:metrics analyze lib

# Check metrics for specific package
cd packages/feature
dart pub global run dart_code_metrics:metrics analyze lib
cd ../..

# Generate HTML report
dart pub global run dart_code_metrics:metrics analyze lib --reporter=html
```

**What it checks**:
- Cyclomatic complexity
- Lines of code per method
- Number of parameters
- Nesting levels
- Code duplication

## Project-Specific Linting Rules

### Critical Rules (Must Fix)

From `analysis_options.yaml`:

```yaml
require_trailing_commas: true          # Multi-line constructs need commas
prefer_single_quotes: true             # Use 'string' not "string"
avoid_print: true                      # Use logger instead
always_declare_return_types: true      # int foo() not foo()
prefer_final_locals: true              # final x = 1 not var x = 1
prefer_const_constructors: true        # const Widget() when possible
always_use_package_imports: true       # package: imports only
```

### Code Metrics Limits

```yaml
max-parameters: 4                      # Max function parameters
max-lines: 160                         # Max lines per file
max-nesting-level: 5                   # Max nesting depth
```

## Common Issues and Fixes

### Issue: Trailing Comma Required
```dart
// Bad
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Hello'),
      Text('World')  // ❌ Missing trailing comma
    ]
  );
}

// Good
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Hello'),
      Text('World'),  // ✅ Trailing comma
    ],
  );
}
```

### Issue: Single vs Double Quotes
```dart
// Bad
final String name = "John";  // ❌ Double quotes

// Good
final String name = 'John';  // ✅ Single quotes

// Exception: Interpolation or escaping
final String message = "It's John";  // ✅ OK to avoid escape
```

### Issue: Missing Return Types
```dart
// Bad
getUser() async {  // ❌ No return type
  return User();
}

// Good
Future<User> getUser() async {  // ✅ Return type declared
  return User();
}
```

### Issue: Non-const Constructor
```dart
// Bad
return Container(  // ❌ Could be const
  color: Colors.red,
);

// Good
return const Container(  // ✅ Const constructor
  color: Colors.red,
);
```

### Issue: Using print()
```dart
// Bad
print('Debug message');  // ❌ Avoid print

// Good
injector<LoggerAbstract>().info('Debug message');  // ✅ Use logger
```

### Issue: Relative Imports
```dart
// Bad
import '../domain/repository.dart';  // ❌ Relative import

// Good
import 'package:feature/src/domain/repository.dart';  // ✅ Package import
```

## Auto-fix Commands

### Fix Formatting Issues
```bash
# Auto-format all files
dart format .

# Format only changed files (Git)
git diff --name-only --diff-filter=ACMR | grep '\.dart$' | xargs dart format
```

### Fix Some Lint Issues
```bash
# Apply available automated fixes
dart fix --apply

# Dry run to see what would be fixed
dart fix --dry-run
```

## Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash

echo "Running format and lint checks..."

# Format code
dart format . --set-exit-if-changed
if [ $? -ne 0 ]; then
  echo "❌ Code formatting failed. Please run: dart format ."
  exit 1
fi

# Analyze code
melos analyze
if [ $? -ne 0 ]; then
  echo "❌ Linting failed. Please fix the errors."
  exit 1
fi

echo "✅ All checks passed!"
exit 0
```

Make executable:
```bash
chmod +x .git/hooks/pre-commit
```

## IDE Integration

### VS Code
Add to `.vscode/settings.json`:
```json
{
  "editor.formatOnSave": true,
  "dart.lineLength": 80,
  "dart.enableLints": true,
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.rulers": [80]
  }
}
```

### Android Studio / IntelliJ
- Settings → Languages & Frameworks → Flutter
- Enable "Format code on save"
- Enable "Organize imports on save"

## CI/CD Integration

In GitHub Actions or similar:
```yaml
- name: Format check
  run: dart format --output=none --set-exit-if-changed .

- name: Analyze
  run: melos analyze

- name: Code metrics
  run: dart pub global activate dart_code_metrics && dart pub global run dart_code_metrics:metrics analyze lib
```

## Quick Reference

### Before Commit
```bash
# One-liner check
dart format . && melos analyze
```

### Before Push
```bash
# Full check including tests
dart format . && melos analyze && melos run test
```

### After Merge
```bash
# Full cleanup
dart format . && dart fix --apply && melos analyze
```

### Clean Slate
```bash
# Nuclear option: clean and rebuild
melos clean
melos bootstrap
dart format .
flutter pub run build_runner build --delete-conflicting-outputs
melos analyze
```

## Ignoring Rules (Use Sparingly)

### Ignore Specific Line
```dart
// ignore: prefer_const_constructors
Widget build(BuildContext context) {
  return Container();
}
```

### Ignore File
```dart
// ignore_for_file: prefer_const_constructors
```

### Ignore in analysis_options.yaml
```yaml
linter:
  rules:
    prefer_const_constructors: false  # Disable rule
```

**Warning**: Only disable rules if absolutely necessary. Project uses strict linting for code quality.

## Performance Tips

### Format Only Changed Files
```bash
# Much faster for large projects
git diff --name-only | grep '\.dart$' | xargs dart format
```

### Parallel Analysis
```bash
# Analyze packages in parallel (if multiple cores)
melos exec -- dart analyze
```

### Skip Analysis for Generated Files
Generated files are already excluded in `analysis_options.yaml`:
```yaml
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.gr.dart"
    - "**/*.freezed.dart"
```

## Troubleshooting

### Format Seems Stuck
```bash
# Kill and retry
pkill -9 dart
dart format .
```

### Analysis Errors Won't Clear
```bash
# Clean analysis cache
rm -rf .dart_tool/
flutter pub get
dart analyze
```

### Conflicting Rules
Check `analysis_options.yaml` for conflicts between enabled rules.

## Success Indicators

You're ready to commit when:
- ✅ `dart format .` outputs "Formatted X files (0 changed)"
- ✅ `melos analyze` shows "No issues found!"
- ✅ No code metric violations
- ✅ All tests pass

## Quick Aliases

Add to `~/.bashrc` or `~/.zshrc`:
```bash
# Flutter project shortcuts
alias ff='dart format .'
alias fa='melos analyze'
alias fcheck='dart format . && melos analyze'
alias ffix='dart format . && dart fix --apply && melos analyze'
```

Then use:
```bash
fcheck  # Quick format + analyze
```
