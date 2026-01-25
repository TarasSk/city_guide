# /add-repository - Add Repository Pattern

## Purpose
Create repository following the project's Clean Architecture pattern with abstract interface + implementation.

## Repository Pattern Structure

```
packages/feature/
├── lib/src/
│   ├── domain/
│   │   └── feature_repository.dart          # Abstract interface
│   └── data/
│       ├── repositories/
│       │   └── feature_repository_impl.dart # Implementation
│       ├── models/
│       │   └── feature_model.dart           # Data models (if needed)
│       └── datasources/
│           └── feature_remote_datasource.dart # API/Firebase (if needed)
```

## Workflow

### 1. Create Domain Repository Interface

**Location**: `packages/feature/lib/src/domain/feature_repository.dart`

```dart
import 'package:dependencies/dependencies.dart';

/// Repository interface for feature operations.
abstract class FeatureRepository {
  /// Fetches feature data.
  ///
  /// Returns feature data on success.
  /// Throws [Exception] on failure.
  Future<FeatureData> getFeatureData();

  /// Saves feature data.
  ///
  /// Returns true on success, false on failure.
  Future<bool> saveFeatureData(FeatureData data);

  /// Deletes feature data by ID.
  Future<void> deleteFeatureData(String id);

  /// Streams feature data changes in real-time.
  Stream<List<FeatureData>> watchFeatureData();
}
```

**Key patterns**:
- Abstract class with descriptive method names
- Future for async operations
- Stream for real-time data
- Clear documentation with `///` comments
- Throw exceptions for errors (handle in BLoC)

### 2. Create Data Models (if needed)

**Location**: `packages/feature/lib/src/data/models/feature_model.dart`

```dart
import 'package:dependencies/dependencies.dart';

/// Data model for feature.
class FeatureModel {
  const FeatureModel({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  final String name;
  final String? description;

  /// Creates FeatureModel from JSON.
  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  /// Converts FeatureModel to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  /// Creates a copy with updated fields.
  FeatureModel copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return FeatureModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
```

### 3. Create Data Source (if needed)

**Location**: `packages/feature/lib/src/data/datasources/feature_remote_datasource.dart`

```dart
import 'package:dependencies/dependencies.dart';
import 'package:feature/src/data/models/feature_model.dart';

/// Remote data source for feature operations.
abstract class FeatureRemoteDataSource {
  Future<List<FeatureModel>> fetchFeatureData();
  Future<void> saveFeatureData(FeatureModel model);
}

/// Implementation using Firebase/HTTP.
class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  FeatureRemoteDataSourceImpl({
    required this.firestore,
  });

  final FirebaseFirestore firestore;

  @override
  Future<List<FeatureModel>> fetchFeatureData() async {
    try {
      final snapshot = await firestore
          .collection('features')
          .get();

      return snapshot.docs
          .map((doc) => FeatureModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch feature data: $e');
    }
  }

  @override
  Future<void> saveFeatureData(FeatureModel model) async {
    try {
      await firestore
          .collection('features')
          .doc(model.id)
          .set(model.toJson());
    } catch (e) {
      throw Exception('Failed to save feature data: $e');
    }
  }
}
```

### 4. Create Repository Implementation

**Location**: `packages/feature/lib/src/data/repositories/feature_repository_impl.dart`

```dart
import 'package:dependencies/dependencies.dart';
import 'package:feature/src/domain/feature_repository.dart';
import 'package:feature/src/data/datasources/feature_remote_datasource.dart';
import 'package:feature/src/data/models/feature_model.dart';

/// Implementation of [FeatureRepository].
class FeatureRepositoryImpl implements FeatureRepository {
  FeatureRepositoryImpl({
    required this.remoteDataSource,
    required this.logger,
  });

  final FeatureRemoteDataSource remoteDataSource;
  final LoggerAbstract logger;

  @override
  Future<FeatureData> getFeatureData() async {
    try {
      logger.info('Fetching feature data');

      final models = await remoteDataSource.fetchFeatureData();

      // Convert models to domain entities if needed
      final data = FeatureData(items: models);

      logger.info('Successfully fetched ${models.length} items');
      return data;
    } catch (e) {
      logger.error('Failed to get feature data', error: e);
      throw Exception('Failed to get feature data: $e');
    }
  }

  @override
  Future<bool> saveFeatureData(FeatureData data) async {
    try {
      logger.info('Saving feature data');

      // Convert domain entity to model
      final model = FeatureModel(
        id: data.id,
        name: data.name,
      );

      await remoteDataSource.saveFeatureData(model);

      logger.info('Successfully saved feature data');
      return true;
    } catch (e) {
      logger.error('Failed to save feature data', error: e);
      return false;
    }
  }

  @override
  Future<void> deleteFeatureData(String id) async {
    try {
      logger.info('Deleting feature data: $id');
      // Implementation
    } catch (e) {
      logger.error('Failed to delete feature data', error: e);
      throw Exception('Failed to delete feature data: $e');
    }
  }

  @override
  Stream<List<FeatureData>> watchFeatureData() {
    // Implementation for real-time updates
    return Stream.value([]);
  }
}
```

**Key patterns**:
- `*Impl` suffix for implementation
- Inject dependencies via constructor
- Use logger for debugging
- Convert between models and domain entities
- Proper error handling and logging

### 5. Export in Package Library

**Location**: `packages/feature/lib/feature.dart`

```dart
library feature;

// Domain
export 'src/domain/feature_repository.dart';

// Data
export 'src/data/repositories/feature_repository_impl.dart';
export 'src/data/models/feature_model.dart';
export 'src/data/datasources/feature_remote_datasource.dart';
```

### 6. Register in Dependency Injection

**Location**: `lib/di/injection_container.dart`

```dart
import 'package:feature/feature.dart';

Future<void> _initializeRepositories() async {
  // Register data source
  injector.registerLazySingleton<FeatureRemoteDataSource>(
    () => FeatureRemoteDataSourceImpl(
      firestore: injector<FirebaseFirestore>(),
    ),
  );

  // Register repository
  injector.registerLazySingleton<FeatureRepository>(
    () => FeatureRepositoryImpl(
      remoteDataSource: injector<FeatureRemoteDataSource>(),
      logger: injector<LoggerAbstract>(),
    ),
  );
}
```

### 7. Create Repository Tests

**Location**: `packages/feature/test/data/repositories/feature_repository_impl_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:feature/feature.dart';
import 'package:core/core.dart';

@GenerateMocks([FeatureRemoteDataSource, LoggerAbstract])
import 'feature_repository_impl_test.mocks.dart';

void main() {
  late FeatureRepositoryImpl repository;
  late MockFeatureRemoteDataSource mockRemoteDataSource;
  late MockLoggerAbstract mockLogger;

  setUp(() {
    mockRemoteDataSource = MockFeatureRemoteDataSource();
    mockLogger = MockLoggerAbstract();
    repository = FeatureRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      logger: mockLogger,
    );
  });

  group('getFeatureData', () {
    final testModels = [
      FeatureModel(id: '1', name: 'Test 1'),
      FeatureModel(id: '2', name: 'Test 2'),
    ];

    test('returns data when remote source succeeds', () async {
      // Arrange
      when(mockRemoteDataSource.fetchFeatureData())
          .thenAnswer((_) async => testModels);

      // Act
      final result = await repository.getFeatureData();

      // Assert
      expect(result.items, hasLength(2));
      verify(mockRemoteDataSource.fetchFeatureData()).called(1);
      verify(mockLogger.info(any)).called(2);
    });

    test('throws exception when remote source fails', () async {
      // Arrange
      when(mockRemoteDataSource.fetchFeatureData())
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => repository.getFeatureData(),
        throwsA(isA<Exception>()),
      );
      verify(mockLogger.error(any, error: anyNamed('error'))).called(1);
    });
  });

  group('saveFeatureData', () {
    final testData = FeatureData(id: '1', name: 'Test');

    test('returns true when save succeeds', () async {
      // Arrange
      when(mockRemoteDataSource.saveFeatureData(any))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.saveFeatureData(testData);

      // Assert
      expect(result, true);
      verify(mockRemoteDataSource.saveFeatureData(any)).called(1);
    });

    test('returns false when save fails', () async {
      // Arrange
      when(mockRemoteDataSource.saveFeatureData(any))
          .thenThrow(Exception('Save error'));

      // Act
      final result = await repository.saveFeatureData(testData);

      // Assert
      expect(result, false);
      verify(mockLogger.error(any, error: anyNamed('error'))).called(1);
    });
  });
}
```

### 8. Generate Mocks and Verify

```bash
# Generate mocks for tests
cd packages/feature
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Return to root
cd ../..
```

## Common Patterns

### With Local Cache
```dart
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;
  final FeatureLocalDataSource localDataSource;

  @override
  Future<FeatureData> getFeatureData() async {
    try {
      // Try remote first
      final data = await remoteDataSource.fetchFeatureData();
      // Cache locally
      await localDataSource.cacheFeatureData(data);
      return data;
    } catch (e) {
      // Fallback to cache
      return await localDataSource.getCachedFeatureData();
    }
  }
}
```

### With Result Type
```dart
// Using Either from dartz package
Future<Either<Failure, FeatureData>> getFeatureData() async {
  try {
    final data = await remoteDataSource.fetchFeatureData();
    return Right(data);
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

## Best Practices

1. **Single Responsibility**: Repository handles data operations only
2. **Dependency Injection**: Inject all dependencies via constructor
3. **Error Handling**: Catch exceptions and log errors
4. **Logging**: Log all operations for debugging
5. **Testing**: Mock all dependencies, test success and failure cases
6. **Type Safety**: Use strong typing, avoid dynamic
7. **Documentation**: Document all public methods
8. **Naming**: Use descriptive names (get, save, delete, watch)

## Checklist

- [ ] Abstract repository interface created in domain layer
- [ ] Implementation created in data layer with `*Impl` suffix
- [ ] Data models created if needed (with fromJson/toJson)
- [ ] Data source created if needed (remote/local)
- [ ] All dependencies injected via constructor
- [ ] Proper error handling and logging
- [ ] Exported in package library file
- [ ] Registered in DI container
- [ ] Unit tests created with mocks
- [ ] Tests passing
- [ ] No linting errors
