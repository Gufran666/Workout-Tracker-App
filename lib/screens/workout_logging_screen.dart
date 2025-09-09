import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workout_tracker_app/models/exercises.dart';
import 'package:workout_tracker_app/models/set_log.dart';
import 'package:workout_tracker_app/models/workout_log.dart';
import 'package:workout_tracker_app/providers/workout_log_provider.dart';
import 'package:workout_tracker_app/widgets/rest_timer.dart';

import '../providers/settings_provider.dart';

// Ensure this plugin is initialized in your main.dart
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class WorkoutLoggingScreen extends ConsumerStatefulWidget {
  final WorkoutLog initialLog;

  const WorkoutLoggingScreen({super.key, required this.initialLog});

  @override
  ConsumerState<WorkoutLoggingScreen> createState() => _WorkoutLoggingScreenState();
}

class _WorkoutLoggingScreenState extends ConsumerState<WorkoutLoggingScreen> {
  late WorkoutLog _log;
  final _confettiController = ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    _log = widget.initialLog;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _updateSet(int exerciseIndex, int setIndex, {int? reps, double? weight, bool? completed}) {
    setState(() {
      final updatedSets = List<SetLog>.from(_log.exercises[exerciseIndex].sets);
      updatedSets[setIndex] = updatedSets[setIndex].copyWith(
        reps: reps ?? updatedSets[setIndex].reps,
        weight: weight ?? updatedSets[setIndex].weight,
        completed: completed ?? updatedSets[setIndex].completed,
      );
      final updatedExercises = List<Exercise>.from(_log.exercises);
      updatedExercises[exerciseIndex] = updatedExercises[exerciseIndex].copyWith(sets: updatedSets);
      _log = _log.copyWith(exercises: updatedExercises);
    });
    HapticFeedback.lightImpact();
  }

  Future<void> _showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'workout_completion_channel',
      'Workout Completion',
      channelDescription: 'Notifications for workout completion',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        1,
        'Workout Completed!',
        'Great job! Your workout has been logged.',
        notificationDetails,
      );
    } catch (e) {
      debugPrint('🔔 Failed to show notification: $e');
    }
  }

  void _saveLog() {
    ref.read(workoutLogListProvider.notifier).addWorkoutLog(_log);
    _confettiController.play();
    HapticFeedback.heavyImpact();
    _showNotification();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Workout Completed!',
              style: GoogleFonts.robotoCondensed(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: const Duration(milliseconds: 300)),
            const SizedBox(height: 16),
            Text(
              'Great job! Your workout has been logged.',
              style: GoogleFonts.roboto(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ref.read(activeWorkoutSessionProvider.notifier).endSession();
            },
            child: Text(
              'Done',
              style: GoogleFonts.robotoCondensed(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Log Workout',
              style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveLog,
              ).animate().scale(duration: const Duration(milliseconds: 100)),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RestTimer(
                  initialSeconds: ref.watch(settingsProvider).timerDuration,
                  onTimerComplete: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Rest timer completed!')),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Exercises',
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ..._log.exercises.asMap().entries.map((exerciseEntry) {
                  final exerciseIndex = exerciseEntry.key;
                  final exercise = exerciseEntry.value;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.name,
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...exercise.sets.asMap().entries.map((setEntry) {
                            final setIndex = setEntry.key;
                            final set = setEntry.value;
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: set.reps.toString(),
                                    decoration: InputDecoration(
                                      labelText: 'Reps',
                                      labelStyle: GoogleFonts.roboto(),
                                      border: const OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _updateSet(exerciseIndex, setIndex, reps: int.tryParse(value) ?? set.reps);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: set.weight.toString(),
                                    decoration: InputDecoration(
                                      labelText: 'Weight (kg)',
                                      labelStyle: GoogleFonts.roboto(),
                                      border: const OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _updateSet(exerciseIndex, setIndex, weight: double.tryParse(value) ?? set.weight);
                                    },
                                  ),
                                ),
                                Checkbox(
                                  value: set.completed,
                                  onChanged: (value) {
                                    _updateSet(exerciseIndex, setIndex, completed: value);
                                  },
                                ),
                              ],
                            ).animate().fadeIn(duration: const Duration(milliseconds: 100));
                          }),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
            ],
          ),
        ),
      ],
    );
  }
}
