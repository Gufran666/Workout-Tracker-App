import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(SetLogAdapter());
  Hive.registerAdapter(WorkOutLogAdapter());

  await Hive.openBox<Workout>('workouts');
  await Hive.openBox<WorkoutLog>('Logs');
}
