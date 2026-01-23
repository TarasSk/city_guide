# /add-bloc - Add New BLoC

## Purpose
Create a new BLoC following the sealed class pattern used in this project.

## Workflow

1. **Create BLoC Directory Structure**
   ```
   lib/src/presentation/blocs/feature_name/
   ├── feature_name_bloc.dart
   ├── feature_name_event.dart
   └── feature_name_state.dart
   ```

2. **Create State File** (`feature_name_state.dart`)
   ```dart
   part of 'feature_name_bloc.dart';

   sealed class FeatureNameState extends Equatable {
     const FeatureNameState();

     const factory FeatureNameState.initial() = FeatureNameInitial;
     const factory FeatureNameState.loading() = FeatureNameLoading;
     const factory FeatureNameState.success(Data data) = FeatureNameSuccess;
     const factory FeatureNameState.error(String message) = FeatureNameError;
   }

   final class FeatureNameInitial extends FeatureNameState {
     const FeatureNameInitial();

     @override
     List<Object?> get props => [];
   }

   final class FeatureNameLoading extends FeatureNameState {
     const FeatureNameLoading();

     @override
     List<Object?> get props => [];
   }

   final class FeatureNameSuccess extends FeatureNameState {
     const FeatureNameSuccess(this.data);

     final Data data;

     @override
     List<Object?> get props => [data];
   }

   final class FeatureNameError extends FeatureNameState {
     const FeatureNameError(this.message);

     final String message;

     @override
     List<Object?> get props => [message];
   }
   ```

3. **Create Event File** (`feature_name_event.dart`)
   ```dart
   part of 'feature_name_bloc.dart';

   sealed class FeatureNameEvent extends Equatable {
     const FeatureNameEvent();

     const factory FeatureNameEvent.started() = FeatureNameStarted;
     const factory FeatureNameEvent.dataRequested() = FeatureNameDataRequested;
     const factory FeatureNameEvent.reset() = FeatureNameReset;
   }

   final class FeatureNameStarted extends FeatureNameEvent {
     const FeatureNameStarted();

     @override
     List<Object?> get props => [];
   }

   final class FeatureNameDataRequested extends FeatureNameEvent {
     const FeatureNameDataRequested();

     @override
     List<Object?> get props => [];
   }

   final class FeatureNameReset extends FeatureNameEvent {
     const FeatureNameReset();

     @override
     List<Object?> get props => [];
   }
   ```

4. **Create BLoC File** (`feature_name_bloc.dart`)
   ```dart
   import 'package:dependencies/dependencies.dart';

   part 'feature_name_event.dart';
   part 'feature_name_state.dart';

   class FeatureNameBloc extends Bloc<FeatureNameEvent, FeatureNameState> {
     FeatureNameBloc({
       required Repository repository,
     })  : _repository = repository,
           super(const FeatureNameState.initial()) {
       on<FeatureNameStarted>(_onStarted);
       on<FeatureNameDataRequested>(_onDataRequested);
       on<FeatureNameReset>(_onReset);
     }

     final Repository _repository;

     Future<void> _onStarted(
       FeatureNameStarted event,
       Emitter<FeatureNameState> emit,
     ) async {
       emit(const FeatureNameState.loading());
       try {
         final data = await _repository.getData();
         emit(FeatureNameState.success(data));
       } catch (e) {
         emit(FeatureNameState.error(e.toString()));
       }
     }

     Future<void> _onDataRequested(
       FeatureNameDataRequested event,
       Emitter<FeatureNameState> emit,
     ) async {
       // Handle event
     }

     void _onReset(
       FeatureNameReset event,
       Emitter<FeatureNameState> emit,
     ) {
       emit(const FeatureNameState.initial());
     }
   }
   ```

5. **Register in DI** (if global BLoC)
   ```dart
   // In lib/di/injection_container.dart
   injector.registerLazySingleton(
     () => FeatureNameBloc(
       repository: injector(),
     ),
   );
   ```

6. **Provide to Widget Tree** (if needed)
   ```dart
   BlocProvider(
     create: (context) => FeatureNameBloc(repository: injector()),
     child: FeaturePage(),
   )
   ```

7. **Use in UI**
   ```dart
   BlocBuilder<FeatureNameBloc, FeatureNameState>(
     builder: (context, state) {
       return switch (state) {
         FeatureNameInitial() => const InitialWidget(),
         FeatureNameLoading() => const LoadingWidget(),
         FeatureNameSuccess(:final data) => SuccessWidget(data: data),
         FeatureNameError(:final message) => ErrorWidget(message: message),
       };
     },
   )
   ```

8. **Write Tests**
   ```dart
   blocTest<FeatureNameBloc, FeatureNameState>(
     'emits [loading, success] when started event succeeds',
     build: () => FeatureNameBloc(repository: mockRepository),
     act: (bloc) => bloc.add(const FeatureNameEvent.started()),
     expect: () => [
       const FeatureNameState.loading(),
       FeatureNameState.success(testData),
     ],
   );
   ```

## Key Patterns

- Always use sealed classes for events and states
- Use const factory constructors for event creation
- Extend Equatable for proper comparison
- Use final classes for concrete implementations
- Include props override for Equatable
- Use switch expressions (Dart 3) for exhaustive state handling
