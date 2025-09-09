import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker_app/models/exercises.dart';
import 'package:workout_tracker_app/models/set_log.dart';
import 'package:workout_tracker_app/models/workout.dart';
import 'package:workout_tracker_app/providers/workout_provider.dart';

class AddEditWorkoutScreen extends ConsumerStatefulWidget {
  final Workout? workout;

  const AddEditWorkoutScreen({super.key, this.workout});

  @override
  ConsumerState<AddEditWorkoutScreen> createState() => _AddEditWorkoutScreenState();
}

class _AddEditWorkoutScreenState extends ConsumerState<AddEditWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _notesController;
  late List<Exercise> _exercises;
  final List<String> _muscleGroups = [
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workout?.name ?? '');
    _notesController = TextEditingController(text: widget.workout?.notes ?? '');
    _exercises = (widget.workout != null
        ? List<Exercise>.from(widget.workout!.exercises)
        : [
      Exercise(
        id: const Uuid().v4(),
        name: 'New Exercise',
        sets: [SetLog(reps: 10, weight: 0.0)],
        muscleGroup: _muscleGroups.first,
      ),
    ])
        .map((e) => (e.id.isEmpty) ? e.copyWith(id: const Uuid().v4()) : e)
        .toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addExercise() {
    setState(() {
      _exercises.add(
        Exercise(
          id: const Uuid().v4(),
          name: 'New Exercise',
          sets: [SetLog(reps: 10, weight: 0.0)],
          muscleGroup: _muscleGroups.first,
        ),
      );
    });
    HapticFeedback.lightImpact();
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
    HapticFeedback.mediumImpact();
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      final workout = Workout(
        id: widget.workout?.id ?? const Uuid().v4(),
        name: _nameController.text,
        exercises: _exercises,
        createdAt: widget.workout?.createdAt ?? DateTime.now(),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      if (widget.workout == null) {
        ref.read(workoutListProvider.notifier).addWorkout(workout);
      } else {
        ref.read(workoutListProvider.notifier).updateWorkout(workout);
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${workout.name} SAVED',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.workout == null ? 'NEW PROTOCOL' : 'EDIT PROTOCOL',
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.data_saver_on, color: theme.colorScheme.primary),
            onPressed: _saveWorkout,
          ).animate().scale(duration: const Duration(milliseconds: 100)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'WORKOUT NAME',
                  labelStyle: GoogleFonts.poppins(color: theme.colorScheme.primary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'INPUT REQUIRED' : null,
              ).animate().fadeIn(duration: const Duration(milliseconds: 100)),
              const SizedBox(height: 24),
              Text(
                'EXERCISE LOGS',
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _exercises.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exercise = entry.value;
                  return ExerciseForm(
                    key: ValueKey(exercise.id),
                    exercise: exercise,
                    muscleGroups: _muscleGroups,
                    onUpdate: (updatedExercise) {
                      setState(() {
                        _exercises[index] = updatedExercise;
                      });
                    },
                    onDelete: () => _removeExercise(index),
                  );
                }).toList(),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final exercise = _exercises.removeAt(oldIndex);
                    _exercises.insert(newIndex, exercise);
                  });
                  HapticFeedback.lightImpact();
                },
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _addExercise,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5), width: 1.5),
                  foregroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add_box),
                label: Text(
                  'ADD EXERCISE',
                  style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ).animate().scale(duration: const Duration(milliseconds: 100)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _notesController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'NOTES (OPTIONAL)',
                  labelStyle: GoogleFonts.poppins(color: theme.colorScheme.primary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ).animate().fadeIn(duration: const Duration(milliseconds: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseForm extends StatefulWidget {
  final Exercise exercise;
  final List<String> muscleGroups;
  final void Function(Exercise) onUpdate;
  final VoidCallback onDelete;

  const ExerciseForm({
    super.key,
    required this.exercise,
    required this.muscleGroups,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  late Exercise _exercise;

  @override
  void initState() {
    super.initState();
    _exercise = widget.exercise;
  }

  void _updateExercise(Exercise updated) {
    setState(() {
      _exercise = updated;
    });
    widget.onUpdate(updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: theme.colorScheme.surface.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              key: ValueKey('${_exercise.id}_name'),
              initialValue: _exercise.name,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'EXERCISE NAME',
                labelStyle: GoogleFonts.poppins(color: theme.colorScheme.primary),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                _updateExercise(_exercise.copyWith(name: value));
              },
              validator: (value) => value!.isEmpty ? 'INPUT REQUIRED' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: ValueKey('${_exercise.id}_muscle'),
              value: _exercise.muscleGroup,
              dropdownColor: theme.colorScheme.surface,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'MUSCLE GROUP',
                labelStyle: GoogleFonts.poppins(color: theme.colorScheme.primary),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: widget.muscleGroups
                  .map((group) => DropdownMenuItem(
                value: group,
                child: Text(group, style: GoogleFonts.poppins(color: Colors.white)),
              ))
                  .toList(),
              onChanged: (value) {
                _updateExercise(_exercise.copyWith(muscleGroup: value));
              },
            ),
            const SizedBox(height: 16),
            ..._exercise.sets.asMap().entries.map((setEntry) {
              final setIndex = setEntry.key;
              final set = setEntry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: ValueKey('${_exercise.id}_set_${setIndex}_reps'),
                        initialValue: set.reps.toString(),
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'REPS',
                          labelStyle: GoogleFonts.poppins(color: theme.colorScheme.primary),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _updateExercise(
                            _exercise.copyWith(
                              sets: _exercise.sets.asMap().entries.map((e) {
                                if (e.key == setIndex) {
                                  return e.value.copyWith(reps: int.tryParse(value) ?? e.value.reps);
                                }
                                return e.value;
                              }).toList(),
                            ),
                          );
                        },
                        validator: (value) => value!.isEmpty ? 'INPUT REQUIRED' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        key: ValueKey('${_exercise.id}_set_${setIndex}_weight'),
                        initialValue: set.weight.toString(),
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'WEIGHT (KG)',
                          labelStyle: GoogleFonts.poppins(color: theme.colorScheme.primary),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _updateExercise(
                            _exercise.copyWith(
                              sets: _exercise.sets.asMap().entries.map((e) {
                                if (e.key == setIndex) {
                                  return e.value.copyWith(weight: double.tryParse(value) ?? e.value.weight);
                                }
                                return e.value;
                              }).toList(),
                            ),
                          );
                        },
                        validator: (value) => value!.isEmpty ? 'INPUT REQUIRED' : null,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_forever, color: Colors.red.shade400),
                      onPressed: () {
                        _updateExercise(
                          _exercise.copyWith(
                            sets: List.of(_exercise.sets)..removeAt(setIndex),
                          ),
                        );
                        HapticFeedback.mediumImpact();
                      },
                    ),
                  ],
                ),
              );
            }),
            OutlinedButton.icon(
              onPressed: () {
                _updateExercise(
                  _exercise.copyWith(
                    sets: [..._exercise.sets, SetLog(reps: 10, weight: 0.0)],
                  ),
                );
                HapticFeedback.lightImpact();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.5), width: 1.5),
                foregroundColor: theme.colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add),
              label: Text(
                'ADD SET',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.red.shade400),
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
