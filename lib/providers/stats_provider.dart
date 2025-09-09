import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:workout_tracker_app/models/exercises.dart';
import 'package:workout_tracker_app/models/set_log.dart';
import 'package:workout_tracker_app/models/workout_log.dart';
import 'package:workout_tracker_app/providers/workout_log_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stats_provider.g.dart';

extension DateTimeNormalization on DateTime {
  DateTime normalize() {
    return DateTime(year, month, day);
  }
}

@Riverpod(keepAlive: true)
class WorkoutStats extends _$WorkoutStats {
  @override
  Future<Map<String, dynamic>> build() async {
    final logs = await ref.watch(workoutLogListProvider.future);
    return _computeStats(logs);
  }

  Map<String, dynamic> _computeStats(List<WorkoutLog> logs) {
    final stats = <String, dynamic>{};

    // Personal Records
    final prs = <String, double>{};
    for (final log in logs) {
      for (final exercise in log.exercises) {
        if (exercise.sets.isNotEmpty) {
          final maxWeight = exercise.sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);
          if (!prs.containsKey(exercise.name) || maxWeight > (prs[exercise.name] ?? 0)) {
            prs[exercise.name] = maxWeight;
          }
        }
      }
    }
    stats['personalRecords'] = prs;

    // Total Volume
    double totalVolume = 0;
    for (final log in logs) {
      for (final exercise in log.exercises) {
        for (final set in exercise.sets) {
          if (set.completed) {
            totalVolume += set.weight * set.reps;
          }
        }
      }
    }
    stats['totalVolume'] = totalVolume;

    // Volume History for Chart (timestamp-based)
    final volumeHistory = logs
        .where((log) => log.loggedAt != null)
        .map((log) {
      final volume = log.exercises.fold<double>(
        0,
            (sum, exercise) => sum + exercise.sets.fold<double>(
          0,
              (setSum, set) => setSum + (set.weight * set.reps),
        ),
      );
      return {
        'date': log.loggedAt.toIso8601String(),
        'timestamp': log.loggedAt.millisecondsSinceEpoch,
        'volume': volume,
      };
    })
        .toList();
    stats['volumeHistory'] = volumeHistory;

    // Streak Calculation
    int streak = 0;
    if (logs.isNotEmpty) {
      final sortedLogs = logs.sorted((a, b) => b.loggedAt.compareTo(a.loggedAt));
      DateTime? lastDate = sortedLogs.first.loggedAt.normalize();
      streak = 1;
      for (int i = 1; i < sortedLogs.length; i++) {
        final currentDate = sortedLogs[i].loggedAt.normalize();
        if (lastDate!.difference(currentDate).inDays == 1) {
          streak++;
        } else {
          break;
        }
        lastDate = currentDate;
      }
    }
    stats['streak'] = streak;

    // Muscle Group Frequency
    final muscleGroups = <String, int>{};
    for (final log in logs) {
      for (final exercise in log.exercises) {
        if (exercise.muscleGroup != null) {
          muscleGroups[exercise.muscleGroup!] = (muscleGroups[exercise.muscleGroup!] ?? 0) + 1;
        }
      }
    }
    stats['muscleGroups'] = muscleGroups;

    return stats;
  }
}
