# /plan - Implementation Planning

## Purpose
Create detailed implementation plans for features following this project's Clean Architecture and modular package structure.

## Planning Process

### 1. Understand Requirements
- What feature/change is being requested?
- Which packages are affected?
- Is this a new feature package or modification to existing?
- What are the acceptance criteria?

### 2. Architecture Assessment

**Determine Scope:**
- [ ] New feature package required?
- [ ] Modification to existing package?
- [ ] Shared functionality (core, domain, data)?
- [ ] UI-only change (presentation)?
- [ ] Cross-cutting concern (affects multiple packages)?

**Identify Layers:**
- [ ] Domain layer changes (entities, repository interfaces)
- [ ] Data layer changes (repository implementations, API calls, local storage)
- [ ] Presentation layer changes (BLoCs, pages, widgets)
- [ ] Routing changes (new routes, parameters)

### 3. Dependencies Analysis

**Required Packages:**
- Which existing packages are needed?
- Are new external dependencies required?
- Need to add to `dependencies` package?
- Version compatibility check needed?

**DI Registration:**
- Which new services/repositories/BLoCs need registration?
- Where to register (main app DI vs. package-specific)?
- Singleton or factory pattern?

### 4. Implementation Steps Template

#### For New Feature Package:

1. **Setup Package Structure**
   - Create package directory
   - Create `pubspec.yaml`
   - Add to workspace configuration
   - Run `melos bootstrap`

2. **Domain Layer** (if needed)
   - Define repository interfaces
   - Define entities/models
   - No external dependencies except Dart SDK

3. **Data Layer** (if needed)
   - Implement repositories
   - Create data models
   - Add API clients or data sources
   - Handle errors and edge cases

4. **Presentation Layer**
   - Create BLoC with events/states
   - Create pages/screens
   - Create reusable widgets
   - Follow sealed class pattern

5. **Routing**
   - Define routes with `@TypedGoRoute`
   - Create Routes constants class
   - Generate route code
   - Register in main router

6. **Dependency Injection**
   - Register repositories
   - Register BLoCs
   - Provide to widget tree

7. **Testing**
   - Unit tests for BLoCs
   - Repository tests with mocks
   - Widget tests for UI

8. **Integration**
   - Add navigation from existing screens
   - Update main router
   - Test end-to-end flow

#### For Existing Package Modification:

1. **Analyze Current Structure**
   - Review existing code
   - Understand current patterns
   - Identify what changes

2. **Plan Changes**
   - Domain changes (if any)
   - Data changes (if any)
   - Presentation changes (if any)
   - Maintain consistency with existing code

3. **Update Tests**
   - Modify existing tests
   - Add new test cases
   - Ensure coverage maintained

4. **Verify Integration**
   - Test with dependent packages
   - Verify no breaking changes
   - Update documentation

### 5. Testing Strategy

**Unit Tests:**
- [ ] BLoC event/state transitions
- [ ] Repository implementations
- [ ] Business logic
- [ ] Utilities and helpers

**Widget Tests:**
- [ ] Page rendering
- [ ] User interactions
- [ ] State updates in UI
- [ ] Error states

**Integration Tests:**
- [ ] Complete user flows
- [ ] Navigation paths
- [ ] Authentication flow
- [ ] API integration

### 6. Code Quality Checklist

- [ ] Follows linting rules (trailing commas, single quotes, etc.)
- [ ] Follows architectural patterns (Clean Architecture, BLoC)
- [ ] Follows naming conventions
- [ ] Code is formatted (`dart format`)
- [ ] Analysis passes (`melos analyze`)
- [ ] All tests pass
- [ ] Code generation updated (if routes changed)
- [ ] No security issues (secrets, API keys)
- [ ] Error handling implemented
- [ ] Loading states handled
- [ ] Edge cases considered

### 7. Migration Considerations

If touching old code in `lib/features/`:
- [ ] Can this be migrated to packages/ structure?
- [ ] Create new package or add to existing?
- [ ] Remove old code after migration?
- [ ] Update imports across codebase?

### 8. Documentation Updates

- [ ] Update CLAUDE.md if architecture changes
- [ ] Add dartdoc comments to public APIs
- [ ] Update README if user-facing changes
- [ ] Add TODO comments for future work

## Planning Output Format

Structure plan as:

```
## Feature: [Name]

### Overview
[Brief description]

### Affected Packages
- package_name: [what changes]
- package_name: [what changes]

### Implementation Steps

#### Phase 1: [Phase Name]
1. [Step]
2. [Step]

#### Phase 2: [Phase Name]
1. [Step]
2. [Step]

### New Files to Create
- path/to/file.dart: [purpose]
- path/to/file.dart: [purpose]

### Files to Modify
- path/to/file.dart: [what changes]
- path/to/file.dart: [what changes]

### Dependencies to Add
- package_name: version (reason)

### DI Registrations
- ClassName: [singleton/factory] in [location]

### Routes
- /route-path: RouteClass (description)

### Testing Plan
- [Test scenario]
- [Test scenario]

### Risks/Considerations
- [Risk or consideration]
- [Risk or consideration]

### Estimated Complexity
[Low/Medium/High] - [reasoning]
```

## Example Use Cases

### Example 1: Add Profile Feature
```
## Feature: User Profile

### Overview
Add user profile view with edit capabilities

### Affected Packages
- NEW: packages/profile
- packages/presentation: Add profile tab to bottom nav
- main app: Add route, DI registration

### Implementation Steps

#### Phase 1: Create Package
1. Create packages/profile with Clean Architecture structure
2. Add to melos.yaml and pubspec.yaml workspace
3. Run melos bootstrap

#### Phase 2: Domain Layer
1. Create UserProfile entity
2. Create ProfileRepository interface

#### Phase 3: Data Layer
1. Implement ProfileRepositoryImpl with Firebase
2. Create data models
3. Add error handling

#### Phase 4: Presentation
1. Create ProfileBloc with edit/save events
2. Create ProfilePage with view mode
3. Create ProfileEditPage with form
4. Create reusable profile widgets

#### Phase 5: Routing
1. Define @TypedGoRoute for /profile
2. Generate routes
3. Add to main router

#### Phase 6: Integration
1. Register in DI
2. Add to bottom nav (already has placeholder)
3. Add navigation from other screens
4. Test complete flow

### Testing Plan
- ProfileBloc state transitions
- Repository with mock Firebase
- Widget tests for ProfilePage
- Integration test for edit flow
```

## After Planning

1. **Review Plan** - Check for gaps or issues
2. **Get Approval** - Confirm approach with team/user
3. **Create Tasks** - Break down into actionable tasks
4. **Estimate** - Complexity assessment
5. **Begin Implementation** - Follow the plan
