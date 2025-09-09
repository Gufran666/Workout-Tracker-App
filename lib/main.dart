import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_tracker_app/screens/splash_screen.dart';
import 'hive_init.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  try {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request permissions
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  } catch (e) {
    debugPrint('🔔 Notification setup failed: $e');
  }

  runApp(const ProviderScope(child: WorkoutTrackerApp()));
}

class WorkoutTrackerApp extends ConsumerWidget {
  const WorkoutTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Workout Tracker',
      debugShowCheckedModeBanner: false,
      theme: _buildSoftGlowTheme(GoogleFonts.poppinsTextTheme()),
      home: const SplashScreen(),
    );
  }

  ThemeData _buildSoftGlowTheme(TextTheme textTheme) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.lightBlue.shade200,
      brightness: Brightness.dark,
    ).copyWith(
      primary: Colors.lightBlue.shade200,
      secondary: Colors.purple.shade200,
      surface: const Color(0xFF1E1E2E),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.raleway(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
          shadows: [
            Shadow(
              color: colorScheme.primary.withOpacity(0.5),
              blurRadius: 10,
            ),
          ],
        ),
      ),
      textTheme: textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ).copyWith(
        headlineLarge: GoogleFonts.raleway(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: colorScheme.primary.withOpacity(0.5),
              blurRadius: 15,
            ),
          ],
        ),
        titleLarge: GoogleFonts.raleway(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          shadows: [
            Shadow(
              color: colorScheme.primary.withOpacity(0.5),
              blurRadius: 10,
            ),
          ],
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white70,
        ),
        labelLarge: GoogleFonts.raleway(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colorScheme.secondary,
          shadows: [
            Shadow(
              color: colorScheme.secondary.withOpacity(0.5),
              blurRadius: 8,
            ),
          ],
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.surface,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: colorScheme.primary.withOpacity(0.5), width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.primary.withOpacity(0.5), width: 1),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
