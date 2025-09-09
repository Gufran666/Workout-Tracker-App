// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutByIdHash() => r'b9e53e738a78114f373d3513352e4bf6455c21ca';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [workoutById].
@ProviderFor(workoutById)
const workoutByIdProvider = WorkoutByIdFamily();

/// See also [workoutById].
class WorkoutByIdFamily extends Family<AsyncValue<Workout?>> {
  /// See also [workoutById].
  const WorkoutByIdFamily();

  /// See also [workoutById].
  WorkoutByIdProvider call(
    String workoutId,
  ) {
    return WorkoutByIdProvider(
      workoutId,
    );
  }

  @override
  WorkoutByIdProvider getProviderOverride(
    covariant WorkoutByIdProvider provider,
  ) {
    return call(
      provider.workoutId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workoutByIdProvider';
}

/// See also [workoutById].
class WorkoutByIdProvider extends FutureProvider<Workout?> {
  /// See also [workoutById].
  WorkoutByIdProvider(
    String workoutId,
  ) : this._internal(
          (ref) => workoutById(
            ref as WorkoutByIdRef,
            workoutId,
          ),
          from: workoutByIdProvider,
          name: r'workoutByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workoutByIdHash,
          dependencies: WorkoutByIdFamily._dependencies,
          allTransitiveDependencies:
              WorkoutByIdFamily._allTransitiveDependencies,
          workoutId: workoutId,
        );

  WorkoutByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workoutId,
  }) : super.internal();

  final String workoutId;

  @override
  Override overrideWith(
    FutureOr<Workout?> Function(WorkoutByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkoutByIdProvider._internal(
        (ref) => create(ref as WorkoutByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workoutId: workoutId,
      ),
    );
  }

  @override
  FutureProviderElement<Workout?> createElement() {
    return _WorkoutByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutByIdProvider && other.workoutId == workoutId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workoutId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WorkoutByIdRef on FutureProviderRef<Workout?> {
  /// The parameter `workoutId` of this provider.
  String get workoutId;
}

class _WorkoutByIdProviderElement extends FutureProviderElement<Workout?>
    with WorkoutByIdRef {
  _WorkoutByIdProviderElement(super.provider);

  @override
  String get workoutId => (origin as WorkoutByIdProvider).workoutId;
}

String _$workoutListHash() => r'028f461fbb0542d5989bb178bbf19ab51d8301ae';

/// See also [WorkoutList].
@ProviderFor(WorkoutList)
final workoutListProvider =
    AsyncNotifierProvider<WorkoutList, List<Workout>>.internal(
  WorkoutList.new,
  name: r'workoutListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$workoutListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorkoutList = AsyncNotifier<List<Workout>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
