import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:workout_tracker_app/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Text(
                'PREFERENCES',
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
              const SizedBox(height: 24),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: Text(
                  'DARK MODE',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                value: settings.isDarkMode,
                onChanged: (value) {
                  settingsNotifier.toggleDarkMode(value);
                  HapticFeedback.lightImpact();
                },
                activeColor: theme.colorScheme.secondary,
                activeTrackColor: theme.colorScheme.secondary.withOpacity(0.5),
              ).animate().fadeIn(duration: const Duration(milliseconds: 100)),
              const SizedBox(height: 32),
              Text(
                'REST TIMER DURATION',
                style: GoogleFonts.raleway(
                  fontSize: 16,
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
              const SizedBox(height: 12),
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                child: DropdownButtonFormField<int>(
                  value: settings.timerDuration,
                  dropdownColor: theme.colorScheme.surface,
                  style: GoogleFonts.poppins(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'SECONDS',
                    labelStyle: GoogleFonts.poppins(color: theme.colorScheme.onSurface),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.onSurface),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [30, 60, 90, 120]
                      .map((seconds) => DropdownMenuItem(
                    value: seconds,
                    child: Text('$seconds seconds', style: GoogleFonts.poppins()),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settingsNotifier.setTimerDuration(value);
                      HapticFeedback.lightImpact();
                    }
                  },
                ).animate().fadeIn(duration: const Duration(milliseconds: 100)),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  settingsNotifier.exportWorkoutLogs(context);
                  HapticFeedback.heavyImpact();
                },
                icon: Icon(
                  Icons.share,
                  color: theme.colorScheme.primary,
                ),
                label: Text(
                  'SHARE LOGS',
                  style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.surface,
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5), width: 1.5),
                  ),
                ),
              ).animate().scale(duration: const Duration(milliseconds: 100)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
