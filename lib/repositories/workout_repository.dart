import 'package:hive/hive.dart';
import 'package:workout_tracker_app/models/workout.dart';
import 'package:workout_tracker_app/models/workout_log.dart';

class WorkoutRepository {
  static const String _workoutBoxName = 'workouts';
  static const String _logBoxName = 'logs';

  Box<Workout>? _workoutBoxInstance;
  Box<WorkoutLog>? _logBoxInstance;

  WorkoutRepository() {
    if (!Hive.isAdapterRegistered(WorkoutAdapter().typeId)) {
      throw Exception('Workout Hive adapter not registered. Ensure Hive is initialized with WorkoutAdapter in hive_init.dart.');
    }
    if (!Hive.isAdapterRegistered(WorkoutLogAdapter().typeId)) {
      throw Exception('WorkoutLog Hive adapter not registered. Ensure Hive is initialized with WorkoutLogAdapter in hive_init.dart.');
    }
  }

  Future<Box<Workout>> _getWorkoutBox() async {
    if (_workoutBoxInstance == null || !_workoutBoxInstance!.isOpen) {
      _workoutBoxInstance = await Hive.openBox<Workout>(_workoutBoxName);
    }
    return _workoutBoxInstance!;
  }

  Future<Box<WorkoutLog>> _getLogBox() async {
    if (_logBoxInstance == null || !_logBoxInstance!.isOpen) {
      _logBoxInstance = await Hive.openBox<WorkoutLog>(_logBoxName);
    }
    return _logBoxInstance!;
  }

  Future<void> addWorkout(Workout workout) async {
    final box = await _getWorkoutBox();
    await box.put(workout.id, workout);
  }

  Future<void> updateWorkout(Workout workout) async {
    final box = await _getWorkoutBox();
    if (box.containsKey(workout.id)) {
      await box.put(workout.id, workout);
    } else {
      throw Exception('Workout with ID ${workout.id} not found');
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    final box = await _getWorkoutBox();
    if (box.containsKey(workoutId)) {
      await box.delete(workoutId);
    } else {
      throw Exception('Workout with ID $workoutId not found');
    }
  }

  Future<List<Workout>> getAllWorkouts() async {
    final box = await _getWorkoutBox();
    return box.values.toList();
  }

  Future<Workout?> getWorkoutById(String workoutId) async {
    final box = await _getWorkoutBox();
    return box.get(workoutId);
  }

  Future<void> addWorkoutLog(WorkoutLog log) async {
    final box = await _getLogBox();
    await box.put(log.id, log);
  }

  Future<void> updateWorkoutLog(WorkoutLog log) async {
    final box = await _getLogBox();
    if (box.containsKey(log.id)) {
      await box.put(log.id, log);
    } else {
      throw Exception('WorkoutLog with ID ${log.id} not found');
    }
  }

  Future<void> deleteWorkoutLog(String logId) async {
    final box = await _getLogBox();
    if (box.containsKey(logId)) {
      await box.delete(logId);
    } else {
      throw Exception('WorkoutLog with ID $logId not found');
    }
  }

  Future<List<WorkoutLog>> getAllWorkoutLogs() async {
    final box = await _getLogBox();
    return box.values.toList();
  }

  Future<List<WorkoutLog>> getLogsForWorkout(String workoutId) async {
    final box = await _getLogBox();
    return box.values.where((log) => log.workoutId == workoutId).toList();
  }

  Future<void> close() async {
    if (_workoutBoxInstance != null && _workoutBoxInstance!.isOpen) {
      await _workoutBoxInstance!.close();
      _workoutBoxInstance = null;
    }
    if (_logBoxInstance != null && _logBoxInstance!.isOpen) {
      await _logBoxInstance!.close();
      _logBoxInstance = null;
    }
  }
}
