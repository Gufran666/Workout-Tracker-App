import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:workout_tracker_app/screens/home_screen.dart';
import 'package:workout_tracker_app/screens/main_screen.dart';
import 'package:workout_tracker_app/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      final hasSeenOnboarding = Hive.box('settings').get('hasSeenOnboarding', defaultValue: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => hasSeenOnboarding ? const MainScreen() : const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.track_changes,
              size: 150,
              color: theme.colorScheme.primary,
              shadows: [
                Shadow(
                  blurRadius: 20.0,
                  color: theme.colorScheme.primary.withOpacity(0.7),
                ),
                Shadow(
                  blurRadius: 10.0,
                  color: theme.colorScheme.primary.withOpacity(0.5),
                ),
              ],
            ).animate().scale(duration: const Duration(milliseconds: 500)).fadeIn(),
            const SizedBox(height: 24),
            Text(
              'WORKOUT TRACKER',
              style: GoogleFonts.raleway(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: theme.colorScheme.primary.withOpacity(0.7),
                  ),
                  Shadow(
                    blurRadius: 10.0,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: const Duration(milliseconds: 500)).slideY(),
            const SizedBox(height: 8),
            Text(
              'Your Journey, Your Strength',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white70,
                shadows: [
                  Shadow(
                    blurRadius: 15.0,
                    color: theme.colorScheme.secondary.withOpacity(0.7),
                  ),
                  Shadow(
                    blurRadius: 7.0,
                    color: theme.colorScheme.secondary.withOpacity(0.5),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: const Duration(milliseconds: 500)).slideY(),
          ],
        ),
      ),
    );
  }
}
