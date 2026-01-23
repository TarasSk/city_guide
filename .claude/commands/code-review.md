# /code-review - Code Quality Review

## Purpose
Perform comprehensive code quality review following this project's strict linting rules and architectural patterns.

## Review Checklist

### 1. Linting Compliance
Run analysis and verify:
```bash
dart format --output=none --set-exit-if-changed .
melos analyze
dart pub global run dart_code_metrics:metrics analyze lib
```

**Critical Rules to Check:**
- [ ] All strings use single quotes
- [ ] All multi-line constructs have trailing commas
- [ ] No `print()` statements (use logger instead)
- [ ] All functions have explicit return types
- [ ] Package imports used (not relative imports)
- [ ] `const` constructors used where possible
- [ ] Local variables are `final` where possible
- [ ] No magic numbers in UI (consider extracting to theme/constants)

### 2. Architecture Compliance

**Package Structure:**
- [ ] Feature code is in appropriate package (not in lib/features/)
- [ ] Dependencies declared via `dependencies` package
- [ ] Domain interfaces separated from data implementations
- [ ] Presentation layer uses BLoCs for state management

**Clean Architecture:**
- [ ] Domain layer has no Flutter dependencies
- [ ] Data layer depends only on domain layer
- [ ] Presentation layer uses BLoCs, not direct repository access
- [ ] Repository interfaces in domain, implementations in data

### 3. BLoC Pattern Compliance
- [ ] Events use sealed classes with factory constructors
- [ ] States use sealed classes with Equatable
- [ ] State classes are final (not abstract)
- [ ] BLoC registered in DI container
- [ ] BLoC has proper tests using `bloc_test`

### 4. Dependency Injection
- [ ] Services registered in appropriate DI container
- [ ] Constructor injection used (not service locator pattern in classes)
- [ ] Dependencies are interfaces, not concrete implementations
- [ ] Lazy singletons used for stateless services
- [ ] Factories used for stateful instances

### 5. Routing
- [ ] Routes defined with `@TypedGoRoute` annotations
- [ ] Route paths stored as constants in Routes class
- [ ] Code generation run after route changes
- [ ] Routes registered in main router
- [ ] Navigation uses type-safe route methods (`.go()`, `.push()`)

### 6. Code Quality

**Performance:**
- [ ] No unnecessary rebuilds (const widgets where possible)
- [ ] Expensive operations cached or memoized
- [ ] Lists use proper keys
- [ ] Async operations properly handled with error cases

**Readability:**
- [ ] Functions are focused and single-purpose
- [ ] Max 4 parameters per function (extract parameter objects if needed)
- [ ] Max 160 lines per file (split if needed)
- [ ] Max 5 levels of nesting
- [ ] Meaningful variable and function names

**Error Handling:**
- [ ] Try-catch blocks around async operations
- [ ] Errors properly logged with stack traces
- [ ] User-friendly error messages in UI
- [ ] Error states in BLoCs

### 7. Testing
- [ ] Unit tests for BLoCs cover all events
- [ ] Repository implementations have tests
- [ ] Widget tests for key UI components
- [ ] Test coverage > 80% (run `flutter test --coverage`)

### 8. Code Generation
- [ ] All `.g.dart` files are up to date
- [ ] No manual edits to generated files
- [ ] Generated files excluded from version control (in .gitignore)

### 9. Documentation
- [ ] Public APIs have dartdoc comments (if `public_member_api_docs` enabled)
- [ ] Complex logic has inline comments
- [ ] TODOs follow flutter_style_todos format

### 10. Security
- [ ] No hardcoded credentials or API keys
- [ ] Sensitive data not logged
- [ ] User input validated
- [ ] Network requests use HTTPS

## Common Issues to Fix

1. **Missing trailing commas**: Add to all multi-line constructs
2. **Using `print()`**: Replace with `logger.d()` or appropriate level
3. **Double quotes**: Change to single quotes
4. **Relative imports**: Convert to package imports
5. **Missing const**: Add const to constructor calls where possible
6. **Non-final locals**: Make variables final if not reassigned
7. **Missing return types**: Add explicit return type to all functions
8. **Large files**: Split into smaller, focused files
9. **Too many parameters**: Extract parameter objects or use named parameters

## Quick Fix Commands

```bash
# Auto-format code
dart format .

# Fix some linting issues automatically
dart fix --apply

# Regenerate code
flutter pub run build_runner build --delete-conflicting-outputs
```
