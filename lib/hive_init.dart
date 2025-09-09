import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_tracker_app/models/exercises.dart';
import 'package:workout_tracker_app/models/set_log.dart';
import 'package:workout_tracker_app/models/workout.dart';
import 'package:workout_tracker_app/models/workout_log.dart';

Future<void> initHive() async {
  try {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(WorkoutAdapter());
    Hive.registerAdapter(ExerciseAdapter());
    Hive.registerAdapter(SetLogAdapter());
    Hive.registerAdapter(WorkoutLogAdapter());


    await Hive.openBox<Workout>('workouts');
    await Hive.openBox<WorkoutLog>('workout_logs');
    await Hive.openBox('settings');
  } catch (e) {
    print('Hive initialization failed: $e');
    rethrow;
  }
}