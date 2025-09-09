import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker_app/models/workout_log.dart';
import 'package:workout_tracker_app/providers/workout_log_provider.dart';
import 'package:workout_tracker_app/providers/stats_provider.dart';

class HistoryProgressScreen extends ConsumerWidget {
  const HistoryProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(workoutLogListProvider);
    final statsAsync = ref.watch(workoutStatsProvider);
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(workoutLogListProvider);
            ref.invalidate(workoutStatsProvider);
          },
          color: theme.primary,
          backgroundColor: theme.surface,
          child: logsAsync.when(
            data: (logs) {
              final recentLogs = logs.take(20).toList();
              final excessLogs = logs.skip(20).toList();

              // Delete older logs from storage
              for (final log in excessLogs) {
                ref.read(workoutLogListProvider.notifier).deleteWorkoutLog(log.id);
              }

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        Text(
                          'PROGRESS',
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: theme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AspectRatio(
                          aspectRatio: 1.6,
                          child: statsAsync.when(
                            data: (stats) {
                              final rawVolume = stats['volumeHistory'];
                              if (rawVolume == null || rawVolume is! List) {
                                return Center(
                                  child: Text(
                                    'No progress data available.',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: theme.secondary,
                                    ),
                                  ),
                                );
                              }

                              final volumeData = rawVolume.cast<Map<String, dynamic>>();
                              final parsed = volumeData
                                  .where((e) => e['volume'] is num && e['date'] != null)
                                  .map((e) {
                                final date = DateTime.tryParse(e['date']);
                                if (date == null) return null;
                                return {
                                  'date': date,
                                  'volume': (e['volume'] as num).toDouble(),
                                };
                              })
                                  .whereType<Map<String, dynamic>>()
                                  .toList();

                              if (parsed.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No valid data points to display.',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: theme.secondary,
                                    ),
                                  ),
                                );
                              }

                              parsed.sort((a, b) => a['date'].compareTo(b['date']));
                              final baseDate = parsed.first['date'] as DateTime;
                              final spots = parsed.map((e) {
                                final offset = e['date'].difference(baseDate).inDays.toDouble();
                                return FlSpot(offset, e['volume']);
                              }).toList();

                              final minX = spots.map((e) => e.x).reduce((a, b) => a < b ? a : b);
                              final maxX = spots.map((e) => e.x).reduce((a, b) => a > b ? a : b);
                              final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
                              final intervalY = (maxY / 5).ceilToDouble();

                              return LineChart(
                                LineChartData(
                                  minY: 0,
                                  maxY: (maxY + intervalY).ceilToDouble(),
                                  minX: minX,
                                  maxX: maxX,
                                  gridData: const FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        interval: intervalY,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()} kg',
                                            style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              color: theme.secondary,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final date = baseDate.add(Duration(days: value.toInt()));
                                          return Text(
                                            DateFormat('MM/dd').format(date),
                                            style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              color: theme.secondary,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(color: theme.primary.withOpacity(0.5)),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: spots,
                                      isCurved: true,
                                      curveSmoothness: 0.15,
                                      preventCurveOverShooting: true,
                                      color: theme.secondary,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                          radius: 4,
                                          color: theme.secondary,
                                          strokeWidth: 2,
                                          strokeColor: theme.surface,
                                        ),
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: theme.secondary.withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            loading: () => Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                              ),
                            ),
                            error: (e, _) => Center(
                              child: Text(
                                'ERROR LOADING PROGRESS: DATA CORRUPTION DETECTED.\n$e',
                                style: GoogleFonts.roboto(
                                  color: Colors.redAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'WORKOUT HISTORY',
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: theme.primary,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  recentLogs.isEmpty
                      ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'NO LOGS DETECTED. START A WORKOUT TO BEGIN.',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: theme.secondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                      : SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final log = recentLogs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 4,
                          color: theme.surface,
                          child: ListTile(
                            title: Text(
                              'LOGGED ON ${DateFormat('yyyy-MM-dd').format(log.loggedAt)}',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              '${log.exercises.length} EXERCISES',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: theme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: const Duration(milliseconds: 100));
                      },
                      childCount: recentLogs.length,
                    ),
                  ),
                ],
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
              ),
            ),
            error: (e, _) => Center(
              child: Text(
                'ERROR LOADING HISTORY: $e',
                style: GoogleFonts.roboto(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
