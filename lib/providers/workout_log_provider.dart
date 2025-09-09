import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workout_tracker_app/models/set_log.dart';
import 'package:workout_tracker_app/models/workout_log.dart';
import 'package:workout_tracker_app/repositories/workout_repository.dart';

part 'workout_log_provider.g.dart';

@Riverpod(keepAlive: true)
class WorkoutLogList extends _$WorkoutLogList {
  final WorkoutRepository _repository = WorkoutRepository();

  @override
  Future<List<WorkoutLog>> build() async {
    return _repository.getAllWorkoutLogs();
  }

  Future<void> addWorkoutLog(WorkoutLog log) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addWorkoutLog(log);
      state = AsyncValue.data(await _repository.getAllWorkoutLogs());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateWorkoutLog(WorkoutLog log) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateWorkoutLog(log);
      state = AsyncValue.data(await _repository.getAllWorkoutLogs());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteWorkoutLog(String logId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteWorkoutLog(logId);
      state = AsyncValue.data(await _repository.getAllWorkoutLogs());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

@Riverpod(keepAlive: true)
Future<List<WorkoutLog>> logsForWorkout(LogsForWorkoutRef ref, String workoutId) async {
  final repository = WorkoutRepository();
  return repository.getLogsForWorkout(workoutId);
}

@Riverpod(keepAlive: true)
class ActiveWorkoutSession extends _$ActiveWorkoutSession {
  @override
  WorkoutLog? build() => null;

  void startSession(WorkoutLog log) {
    state = log;
  }

  void updateSet(
      String exerciseId,
      int setIndex, {
        int? reps,
        double? weight,
        bool? completed,
        int? restTime,
        int? rpe,
      }) {
    if (state == null) return;

    final updatedExercises = state!.exercises.map((exercise) {
      if (exercise.id != exerciseId) return exercise;

      final updatedSets = exercise.sets.asMap().entries.map((entry) {
        final index = entry.key;
        final set = entry.value;
        if (index != setIndex) return set;

        return set.copyWith(
          reps: reps ?? set.reps,
          weight: weight ?? set.weight,
          completed: completed ?? set.completed,
          restTime: restTime ?? set.restTime,
          rpe: rpe ?? set.rpe,
        );
      }).toList();

      return exercise.copyWith(sets: updatedSets);
    }).toList();

    state = state!.copyWith(exercises: updatedExercises);
  }

  Future<void> saveSession() async {
    if (state == null) return;
    final repository = WorkoutRepository();
    await repository.addWorkoutLog(state!);
    state = null;
  }

  void endSession() {
    state = null;
  }

}
