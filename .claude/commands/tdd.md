# /tdd - Test-Driven Development for Flutter

## Purpose
Guide test-driven development for this Flutter project following BLoC patterns and Clean Architecture.

## Workflow

1. **Understand Requirements**
   - Clarify what functionality needs to be added
   - Identify which layer (domain/data/presentation) the change affects
   - Determine if this is a feature package or shared package change

2. **Write Tests First**
   - For **BLoCs**: Test events trigger correct state transitions
   - For **Repositories**: Test both success and error cases with mocked data sources
   - For **UI**: Test widget rendering and user interactions
   - Follow existing test patterns in `packages/*/test/`

3. **Test Structure**
   ```dart
   void main() {
     group('FeatureBloc', () {
       late FeatureBloc bloc;
       late MockRepository mockRepository;

       setUp(() {
         mockRepository = MockRepository();
         bloc = FeatureBloc(repository: mockRepository);
       });

       tearDown(() {
         bloc.close();
       });

       test('initial state is correct', () {
         expect(bloc.state, equals(const FeatureState.initial()));
       });

       blocTest<FeatureBloc, FeatureState>(
         'emits [loading, success] when event succeeds',
         build: () => bloc,
         act: (bloc) => bloc.add(const FeatureEvent.started()),
         expect: () => [
           const FeatureState.loading(),
           const FeatureState.success(data),
         ],
       );
     });
   }
   ```

4. **Run Tests**
   ```bash
   # Run tests for specific package
   cd packages/package_name
   flutter test

   # Run with coverage
   flutter test --coverage
   ```

5. **Implement Minimal Code**
   - Write just enough code to make tests pass
   - Follow sealed class patterns for BLoC events/states
   - Use dependency injection via constructor parameters

6. **Refactor**
   - Ensure code follows linting rules (trailing commas, single quotes, etc.)
   - Run `dart format .`
   - Run `melos analyze` to check for issues

7. **Verify**
   - All tests pass
   - No linting errors
   - Code generation updated if needed (`flutter pub run build_runner build`)

## Key Testing Patterns

- **BLoC Testing**: Use `bloc_test` package
- **Mocking**: Use `mockito` or `mocktail` for dependencies
- **Widget Testing**: Use `testWidgets` for UI components
- **Golden Tests**: For visual regression testing
