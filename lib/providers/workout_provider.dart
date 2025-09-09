import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workout_tracker_app/models/workout.dart';
import 'package:workout_tracker_app/repositories/workout_repository.dart';

part 'workout_provider.g.dart';

@Riverpod(keepAlive: true)
class WorkoutList extends _$WorkoutList {
  final WorkoutRepository _repository = WorkoutRepository();

  @override
  Future<List<Workout>> build() async {
    return _repository.getAllWorkouts();
  }

  Future<void> addWorkout(Workout workout) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addWorkout(workout);
      state = AsyncValue.data(await _repository.getAllWorkouts());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateWorkout(Workout workout) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateWorkout(workout);
      state = AsyncValue.data(await _repository.getAllWorkouts());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteWorkout(workoutId);
      state = AsyncValue.data(await _repository.getAllWorkouts());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

@Riverpod(keepAlive: true)
Future<Workout?> workoutById(WorkoutByIdRef ref, String workoutId) async {
  final repository = WorkoutRepository();
  return repository.getWorkoutById(workoutId);
}
