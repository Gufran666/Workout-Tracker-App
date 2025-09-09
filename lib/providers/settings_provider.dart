import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:workout_tracker_app/providers/workout_log_provider.dart';
import 'package:intl/intl.dart';

class Settings {
  final bool isDarkMode;
  final int timerDuration;

  Settings({required this.isDarkMode, required this.timerDuration});

  Settings copyWith({bool? isDarkMode, int? timerDuration}) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      timerDuration: timerDuration ?? this.timerDuration,
    );
  }
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(this.ref)
      : super(Settings(isDarkMode: false, timerDuration: 60)) {
    _loadSettings();
  }

  final Ref ref;

  Future<void> _loadSettings() async {
    final box = await Hive.openBox('settings');
    final isDarkMode = box.get('isDarkMode', defaultValue: false) as bool;
    final timerDuration = box.get('timerDuration', defaultValue: 60) as int;
    state = Settings(isDarkMode: isDarkMode, timerDuration: timerDuration);
  }

  void toggleDarkMode(bool value) {
    state = state.copyWith(isDarkMode: value);
    Hive.box('settings').put('isDarkMode', value);
  }

  void setTimerDuration(int seconds) {
    state = state.copyWith(timerDuration: seconds);
    Hive.box('settings').put('timerDuration', seconds);
  }

  Future<void> exportWorkoutLogs(BuildContext context) async {
    try {
      final logs = ref.read(workoutLogListProvider).value ?? [];
      final List<List<dynamic>> csvData = [
        ['Workout ID', 'Date', 'Exercise', 'Reps', 'Weight', 'Completed'],
        ...logs.expand((log) => log.exercises.expand((exercise) => exercise.sets.map((set) => [
          log.workoutId,
          DateFormat('yyyy-MM-dd').format(log.loggedAt),
          exercise.name,
          set.reps,
          set.weight,
          set.completed,
        ]))),
      ];

      final csvString = const ListToCsvConverter().convert(csvData);
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/workout_logs.csv';
      final file = await File(path).writeAsString(csvString);

      await Share.shareXFiles([XFile(path)], text: 'Workout Logs Export');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout logs exported successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting logs: $e')),
      );
    }
  }

  Future<bool> downloadWorkoutLogsAsCsv() async {
    try {
      final logs = ref.read(workoutLogListProvider).value ?? [];
      if (logs.isEmpty) return false;

      final List<List<dynamic>> csvData = [
        ['Workout ID', 'Date', 'Exercise', 'Reps', 'Weight', 'Completed'],
        ...logs.expand((log) => log.exercises.expand((exercise) => exercise.sets.map((set) => [
          log.workoutId,
          DateFormat('yyyy-MM-dd').format(log.loggedAt),
          exercise.name,
          set.reps,
          set.weight,
          set.completed,
        ]))),
      ];

      final csvString = const ListToCsvConverter().convert(csvData);
      final directory = await getExternalStorageDirectory();
      if (directory == null) return false;

      final path = '${directory.path}/workout_logs.csv';
      final file = await File(path).writeAsString(csvString);

      return await file.exists();
    } catch (_) {
      return false;
    }
  }

  Future<String> getDownloadedCsvPath() async {
    final directory = await getExternalStorageDirectory();
    return '${directory!.path}/workout_logs.csv';
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
      (ref) => SettingsNotifier(ref),
);
