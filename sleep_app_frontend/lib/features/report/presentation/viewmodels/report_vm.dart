import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/report/data/sources/report_source.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportSource _source = ReportSource();

  bool _disposed = false;

  bool isLoading = true;

  double avgDurationHours = 0;

  List<double> weeklyData = List.filled(
    7,
    0.0,
  );

  List<FlSpot> weeklySpots = [];
  List<FlSpot> monthlySpots = [];

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> loadReportData() async {
    if (_disposed) return;

    isLoading = true;
    _safeNotifyListeners();

    try {
      final now = DateTime.now();

      final startDate = now.subtract(
        const Duration(days: 27),
      );

      final startDateMidnight = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );

      final assessments = await _source.getAssessmentsAndMetrics(
        startDateMidnight,
      );

      // Trong lúc await, ViewModel có thể đã bị dispose
      if (_disposed) return;

      double totalHours = 0;
      int count = 0;

      final List<double> weekDuration = List.filled(
        7,
        0.0,
      );

      final List<double?> thisWeekScores = List.filled(
        7,
        null,
      );

      final List<List<double>> weeklyScoresGroups = [
        [],
        [],
        [],
        [],
      ];

      for (final a in assessments) {
        if (_disposed) return;

        if (a['completed_at'] == null) {
          continue;
        }

        final date = DateTime.parse(
          a['completed_at'],
        ).toLocal();

        final daysAgo = now.difference(date).inDays;

        if (daysAgo >= 0 && daysAgo < 28) {
          double? score;

          if (a['normalized_score'] != null) {
            score = (a['normalized_score'] as num).toDouble();
          }

          if (score != null) {
            final weekGroup = daysAgo ~/ 7;

            if (weekGroup >= 0 && weekGroup < 4) {
              weeklyScoresGroups[weekGroup].add(
                score,
              );
            }

            if (daysAgo < 7) {
              final index = date.weekday - 1;

              thisWeekScores[index] = score;
            }
          }
        }

        final metrics = a['assessment_sleep_metrics'];

        if (metrics != null &&
            metrics is List &&
            metrics.isNotEmpty) {
          final durationMins =
              metrics[0]['sleep_duration_minutes'];

          if (durationMins != null) {
            final hours =
                (durationMins as num).toDouble() / 60.0;

            if (daysAgo >= 0 && daysAgo < 7) {
              totalHours += hours;
              count++;

              final index = date.weekday - 1;

              weekDuration[index] = hours;
            }
          }
        }
      }

      if (_disposed) return;

      weeklyData = weekDuration;

      avgDurationHours =
          count > 0 ? totalHours / count : 0;

      weeklySpots = [];

      for (int i = 0; i < 7; i++) {
        final score = thisWeekScores[i];

        if (score != null) {
          weeklySpots.add(
            FlSpot(
              i.toDouble(),
              score,
            ),
          );
        }
      }

      monthlySpots = [];

      for (int i = 0; i < 4; i++) {
        final weekGroup = 3 - i;

        final scores =
            weeklyScoresGroups[weekGroup];

        if (scores.isEmpty) {
          continue;
        }

        double sum = 0;

        for (final score in scores) {
          sum += score;
        }

        final avg = sum / scores.length;

        monthlySpots.add(
          FlSpot(
            (i + 1).toDouble(),
            avg,
          ),
        );
      }
    } catch (e) {
      if (!_disposed) {
        debugPrint(
          'Error loading report data: $e',
        );
      }
    } finally {
      if (!_disposed) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}