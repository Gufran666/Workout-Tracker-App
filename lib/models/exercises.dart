import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'set_log.dart';
part 'exercises.g.dart';

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name; 

  @HiveField(2)
  final List<SetLog> sets;

  @HiveField(3)
  final String? muscleGroup; 

  @HiveField(4)
  final String? notes;

  Exercise({
    String? id,
    required this.name,
    required this.sets,
    this.muscleGroup,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  Exercise copyWith({
    String? id,
    String? name,
    List<SetLog>? sets,
    String? muscleGroup,
    String? notes,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sets': sets.map((s) => s.toJson()).toList(),
        'muscleGroup': muscleGroup,
        'notes': notes,
      };

  static Exercise fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'] as String,
        name: json['name'] as String,
        sets: (json['sets'] as List<dynamic>)
            .map((s) => SetLog.fromJson(s as Map<String, dynamic>))
            .toList(),
        muscleGroup: json['muscleGroup'] as String?,
        notes: json['notes'] as String?,
      );
}