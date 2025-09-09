import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_tracker_app/providers/stats_provider.dart';

class StatsCard extends ConsumerWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(workoutStatsProvider);
    final theme = Theme.of(context).colorScheme;

    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 500)),
        ScaleEffect(
          begin: Offset(0.95, 0.95),
          end: Offset(1.0, 1.0),
          duration: Duration(milliseconds: 500),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: statsAsync.when(
            data: (stats) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(
                  title: 'STREAK',
                  value: '${stats['streak'] ?? 0} DAYS',
                  icon: Icons.local_fire_department,
                ),
                StatItem(
                  title: 'TOTAL VOLUME',
                  value: '${(stats['totalVolume'] as double?)?.toStringAsFixed(0) ?? '0'} KG',
                  icon: Icons.fitness_center,
                ),
              ],
            ),
            loading: () => Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
              ),
            ),
            error: (e, _) => Text(
              'ERROR LOADING STATS: $e',
              style: GoogleFonts.electrolize(
                color: Colors.red,
                shadows: const [
                  Shadow(blurRadius: 15, color: Colors.red),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Semantics(
      label: '$title: $value',
      child: Column(
        children: [
          Icon(icon, color: theme.secondary, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.primary,
              shadows: const [
                Shadow(blurRadius: 10, color: Colors.cyan),
              ],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.electrolize(
              fontSize: 14,
              color: Colors.limeAccent,
              shadows: const [
                Shadow(blurRadius: 10, color: Colors.lime),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
