import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:workout_tracker_app/models/workout.dart';
import 'package:workout_tracker_app/models/workout_log.dart';
import 'package:workout_tracker_app/providers/providers.dart';
import 'package:workout_tracker_app/screens/add_edit_workout_screen.dart';
import 'package:workout_tracker_app/screens/workout_logging_screen.dart';
import 'package:workout_tracker_app/widgets/stats_card.dart';
import 'package:workout_tracker_app/widgets/workout_card.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'QUICK STATS',
                  style: GoogleFonts.raleway(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                    shadows: [
                      Shadow(
                        color: theme.colorScheme.primary.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const StatsCard(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'YOUR WORKOUTS',
                  style: GoogleFonts.raleway(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                    shadows: [
                      Shadow(
                        color: theme.colorScheme.primary.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              workoutsAsync.when(
                data: (workouts) => workouts.isEmpty
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No workouts found. Tap the button below to add your first workout.',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: const Duration(milliseconds: 300)),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return WorkoutCard(
                      workout: workout,
                      onStart: () {
                        final log = WorkoutLog(
                          id: const Uuid().v4(),
                          workoutId: workout.id,
                          loggedAt: DateTime.now(),
                          exercises: workout.exercises
                              .map((e) => e.copyWith(
                            sets: e.sets.map((s) => s.copyWith(completed: false)).toList(),
                          ))
                              .toList(),
                        );
                        ref.read(activeWorkoutSessionProvider.notifier).startSession(log);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutLoggingScreen(initialLog: log),
                          ),
                        );
                      },
                      onDelete: () {
                        ref.read(workoutListProvider.notifier).deleteWorkout(workout.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${workout.name} DELETED',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            backgroundColor: Colors.red.shade400.withOpacity(0.8),
                          ),
                        );
                      },
                    );
                  },
                ),
                loading: () => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),
                  ),
                ),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Error: Could not load workouts.',
                      style: GoogleFonts.poppins(color: Colors.red.shade400),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditWorkoutScreen(),
            ),
          );
        },
        label: Text(
          'ADD WORKOUT',
          style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        icon: Icon(
          Icons.add_circle_outline,
          color: theme.colorScheme.primary,
        ),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5), width: 1.5),
        ),
      ).animate().scale(duration: const Duration(milliseconds: 100)),
    );
  }
}
