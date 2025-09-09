// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_log_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$logsForWorkoutHash() => r'3b9e64876ca9f2156b0069b93eaeb5d4b85ea11c';

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

/// See also [logsForWorkout].
@ProviderFor(logsForWorkout)
const logsForWorkoutProvider = LogsForWorkoutFamily();

/// See also [logsForWorkout].
class LogsForWorkoutFamily extends Family<AsyncValue<List<WorkoutLog>>> {
  /// See also [logsForWorkout].
  const LogsForWorkoutFamily();

  /// See also [logsForWorkout].
  LogsForWorkoutProvider call(
    String workoutId,
  ) {
    return LogsForWorkoutProvider(
      workoutId,
    );
  }

  @override
  LogsForWorkoutProvider getProviderOverride(
    covariant LogsForWorkoutProvider provider,
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
  String? get name => r'logsForWorkoutProvider';
}

/// See also [logsForWorkout].
class LogsForWorkoutProvider extends FutureProvider<List<WorkoutLog>> {
  /// See also [logsForWorkout].
  LogsForWorkoutProvider(
    String workoutId,
  ) : this._internal(
          (ref) => logsForWorkout(
            ref as LogsForWorkoutRef,
            workoutId,
          ),
          from: logsForWorkoutProvider,
          name: r'logsForWorkoutProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$logsForWorkoutHash,
          dependencies: LogsForWorkoutFamily._dependencies,
          allTransitiveDependencies:
              LogsForWorkoutFamily._allTransitiveDependencies,
          workoutId: workoutId,
        );

  LogsForWorkoutProvider._internal(
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
    FutureOr<List<WorkoutLog>> Function(LogsForWorkoutRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LogsForWorkoutProvider._internal(
        (ref) => create(ref as LogsForWorkoutRef),
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
  FutureProviderElement<List<WorkoutLog>> createElement() {
    return _LogsForWorkoutProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LogsForWorkoutProvider && other.workoutId == workoutId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workoutId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LogsForWorkoutRef on FutureProviderRef<List<WorkoutLog>> {
  /// The parameter `workoutId` of this provider.
  String get workoutId;
}

class _LogsForWorkoutProviderElement
    extends FutureProviderElement<List<WorkoutLog>> with LogsForWorkoutRef {
  _LogsForWorkoutProviderElement(super.provider);

  @override
  String get workoutId => (origin as LogsForWorkoutProvider).workoutId;
}

String _$workoutLogListHash() => r'63278c66a76996f7ad044d07d5e94fbb69917dd3';

/// See also [WorkoutLogList].
@ProviderFor(WorkoutLogList)
final workoutLogListProvider =
    AsyncNotifierProvider<WorkoutLogList, List<WorkoutLog>>.internal(
  WorkoutLogList.new,
  name: r'workoutLogListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutLogListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorkoutLogList = AsyncNotifier<List<WorkoutLog>>;
String _$activeWorkoutSessionHash() =>
    r'e2f06be7a707d5f19e3c0bb045296dcf9e4ac0df';

/// See also [ActiveWorkoutSession].
@ProviderFor(ActiveWorkoutSession)
final activeWorkoutSessionProvider =
    NotifierProvider<ActiveWorkoutSession, WorkoutLog?>.internal(
  ActiveWorkoutSession.new,
  name: r'activeWorkoutSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeWorkoutSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveWorkoutSession = Notifier<WorkoutLog?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
