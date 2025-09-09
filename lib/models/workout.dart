import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker_app/models/exercises.dart';

part 'workout.g.dart'; 

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name; 

  @HiveField(2)
  final List<Exercise> exercises;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String? notes; 

  Workout({
    String? id,
    required this.name,
    required this.exercises,
    DateTime? createdAt,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Workout copyWith({
    String? id,
    String? name,
    List<Exercise>? exercises,
    DateTime? createdAt,
    String? notes,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'notes': notes,
      };

  static Workout fromJson(Map<String, dynamic> json) => Workout(
        id: json['id'] as String,
        name: json['name'] as String,
        exercises: (json['exercises'] as List<dynamic>)
            .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        notes: json['notes'] as String?,
      );
}