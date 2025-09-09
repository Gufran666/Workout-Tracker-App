import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_tracker_app/models/workout.dart';
import 'package:workout_tracker_app/screens/add_edit_workout_screen.dart';

import '../utils/feedbacks.dart';

class WorkoutCard extends ConsumerWidget {
  final Workout workout;
  final VoidCallback onStart;
  final VoidCallback onDelete;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onStart,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;

    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 300)),
        SlideEffect(
          begin: Offset(0, 0.1),
          end: Offset.zero,
          duration: Duration(milliseconds: 300),
        ),
      ],
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 8,
        color: theme.surface,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: theme.primary.withOpacity(0.5)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            workout.name.toUpperCase(),
            style: GoogleFonts.orbitron(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.primary,
              shadows: const [
                Shadow(blurRadius: 10, color: Colors.cyan),
              ],
            ),
          ),
          subtitle: Text(
            '${workout.exercises.length} EXERCISES',
            style: GoogleFonts.electrolize(
              fontSize: 14,
              color: theme.secondary,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: theme.secondary),
                onPressed: () {
                  AppHaptics.light();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditWorkoutScreen(workout: workout),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                onPressed: () {
                  AppHaptics.medium();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: theme.surface,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: theme.primary),
                      ),
                      title: Text(
                        'DELETE PROTOCOL?',
                        style: GoogleFonts.orbitron(
                          fontWeight: FontWeight.bold,
                          color: theme.primary,
                        ),
                      ),
                      content: Text(
                        'This action is irreversible.',
                        style: GoogleFonts.electrolize(color: Colors.limeAccent),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'CANCEL',
                            style: GoogleFonts.electrolize(color: theme.primary),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'DELETE',
                            style: GoogleFonts.electrolize(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          onTap: () {
            AppHaptics.light();
            onStart();
          },
        ),
      ),
    );
  }
}
