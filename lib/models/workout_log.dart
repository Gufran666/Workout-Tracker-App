import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker_app/models/exercises.dart';

part 'workout_log.g.dart';

@HiveType(typeId: 3)
class WorkoutLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String workoutId; // References Workout

  @HiveField(2)
  final List<Exercise> exercises; // Snapshot of exercises at log time

  @HiveField(3)
  final DateTime loggedAt;

  @HiveField(4)
  final String? notes;

  WorkoutLog({
    String? id,
    required this.workoutId,
    required this.exercises,
    DateTime? loggedAt,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        loggedAt = loggedAt ?? DateTime.now();

  WorkoutLog copyWith({
    String? id,
    String? workoutId,
    List<Exercise>? exercises,
    DateTime? loggedAt,
    String? notes,
  }) {
    return WorkoutLog(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exercises: exercises ?? this.exercises,
      loggedAt: loggedAt ?? this.loggedAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workoutId': workoutId,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'loggedAt': loggedAt.toIso8601String(),
        'notes': notes,
      };

  static WorkoutLog fromJson(Map<String, dynamic> json) => WorkoutLog(
        id: json['id'] as String,
        workoutId: json['workoutId'] as String,
        exercises: (json['exercises'] as List<dynamic>)
            .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList(),
        loggedAt: DateTime.parse(json['loggedAt'] as String),
        notes: json['notes'] as String?,
      );
}