import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:workout_tracker_app/screens/main_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.memory_sharp,
              size: 200,
              color: Colors.limeAccent,
              shadows: const [
                Shadow(
                  blurRadius: 20.0,
                  color: Colors.lime,
                ),
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.lime,
                ),
              ],
            ).animate().fadeIn(duration: const Duration(milliseconds: 300)).scale(),
            Text(
              'INITIALIZING PROTOCOL',
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
                shadows: const [
                  Shadow(
                    blurRadius: 20.0,
                    color: Colors.cyan,
                  ),
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.cyan,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Log your progress, hack your potential.',
              style: GoogleFonts.electrolize(
                fontSize: 16,
                color: Colors.limeAccent,
                shadows: const [
                  Shadow(
                    blurRadius: 15.0,
                    color: Colors.lime,
                  ),
                  Shadow(
                    blurRadius: 7.0,
                    color: Colors.lime,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () async {
                  await Hive.box('settings').put('hasSeenOnboarding', true);
                  HapticFeedback.lightImpact();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  side: const BorderSide(color: Colors.cyanAccent, width: 2),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: Text(
                  'ACTIVATE',
                  style: GoogleFonts.orbitron(
                    fontSize: 18,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
            ).animate().scale(duration: const Duration(milliseconds: 100)),
          ],
        ),
      ),
    );
  }
}
