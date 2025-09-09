import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class RestTimer extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback? onTimerComplete;

  const RestTimer({
    super.key,
    this.initialSeconds = 60,
    this.onTimerComplete,
  });

  @override
  State<RestTimer> createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> {
  late int _seconds;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialSeconds;
  }

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
      });
      HapticFeedback.lightImpact();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
          } else {
            timer.cancel();
            _isRunning = false;
            HapticFeedback.heavyImpact();
            _showNotification();
            widget.onTimerComplete?.call();
          }
        });
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _seconds = widget.initialSeconds;
    });
    HapticFeedback.lightImpact();
  }

  Future<void> _showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'rest_timer_channel',
      'Rest Timer',
      channelDescription: 'Notifications for rest timer completion',
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
        0,
        'Rest Timer Completed',
        'Your rest period is over. Time for the next set!',
        notificationDetails,
      );
    } catch (e) {
      debugPrint('🔔 Failed to show notification: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    final theme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 8,
      color: theme.surface,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: theme.primary.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rest Timer: $minutes:$seconds',
              style: GoogleFonts.electrolize(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.limeAccent,
                shadows: const [
                  Shadow(blurRadius: 10, color: Colors.lime),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _isRunning ? _stopTimer : _startTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.surface,
                foregroundColor: theme.primary,
                side: BorderSide(color: theme.primary),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                _isRunning ? 'STOP' : 'START',
                style: GoogleFonts.orbitron(fontSize: 16),
              ),
            ).animate().scale(duration: const Duration(milliseconds: 100)),
          ],
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 100));
  }
}
