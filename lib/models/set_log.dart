import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'set_log.g.dart';

@HiveType(typeId: 2)
class SetLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int reps;

  @HiveField(2)
  final double weight; // In kg

  @HiveField(3)
  final bool completed;

  @HiveField(4)
  final int? restTime; // Seconds, optional

  @HiveField(5)
  final int? rpe; // Rate of Perceived Exertion (1-10)

  SetLog({
    String? id,
    required this.reps,
    required this.weight,
    this.completed = false,
    this.restTime,
    this.rpe,
  }) : id = id ?? const Uuid().v4();

  SetLog copyWith({
    String? id,
    int? reps,
    double? weight,
    bool? completed,
    int? restTime,
    int? rpe,
  }) {
    return SetLog(
      id: id ?? this.id,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      completed: completed ?? this.completed,
      restTime: restTime ?? this.restTime,
      rpe: rpe ?? this.rpe,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reps': reps,
        'weight': weight,
        'completed': completed,
        'restTime': restTime,
        'rpe': rpe,
      };

  static SetLog fromJson(Map<String, dynamic> json) => SetLog(
        id: json['id'] as String,
        reps: json['reps'] as int,
        weight: json['weight'] as double,
        completed: json['completed'] as bool,
        restTime: json['restTime'] as int?,
        rpe: json['rpe'] as int?,
      );
}