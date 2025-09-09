import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_tracker_app/screens/history_progress_screen.dart';
import 'package:workout_tracker_app/screens/home_screen.dart';
import 'package:workout_tracker_app/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    HistoryProgressScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _screens[_selectedIndex].animate().fadeIn(duration: const Duration(milliseconds: 200)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.colorScheme.surface.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'WORKOUT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'STATS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'CONFIG',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: GoogleFonts.raleway(
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: theme.colorScheme.primary.withOpacity(0.8),
              blurRadius: 10,
            ),
          ],
        ),
        unselectedLabelStyle: GoogleFonts.poppins(),
        onTap: _onItemTapped,
      ).animate().slideY(begin: 1.0, end: 0.0, duration: const Duration(milliseconds: 300)),
    );
  }
}
