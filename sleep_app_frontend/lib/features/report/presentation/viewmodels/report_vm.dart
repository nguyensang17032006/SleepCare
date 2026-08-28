import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/report/data/sources/report_source.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportSource _source = ReportSource();

  bool isLoading = true;

  double avgDurationHours = 0;
  List<double> weeklyData = List.filled(7, 0.0); // Mon-Sun sleep hours
  
  List<FlSpot> weeklySpots = [];
  List<FlSpot> monthlySpots = [];

  Future<void> loadReportData() async {
    isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      // Get data for the last 28 days
      final startDate = now.subtract(const Duration(days: 27));
      final startDateMidnight = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );

      final assessments = await _source.getAssessmentsAndMetrics(
        startDateMidnight,
      );

      double totalHours = 0;
      int count = 0;
      List<double> weekDuration = List.filled(7, 0.0);
      
      // For Line Chart
      List<double?> thisWeekScores = List.filled(7, null);
      
      // For Monthly Line Chart (4 weeks)
      List<List<double>> weeklyScoresGroups = [[], [], [], []];

      for (var a in assessments) {
        if (a['completed_at'] != null) {
          final date = DateTime.parse(a['completed_at']).toLocal();
          final daysAgo = now.difference(date).inDays;
          
          if (daysAgo >= 0 && daysAgo < 28) {
            double? score;
            if (a['normalized_score'] != null) {
              score = (a['normalized_score'] as num).toDouble();
            }

            if (score != null) {
              // Group into 4 weeks (0 = newest week, 3 = oldest week)
              int weekGroup = daysAgo ~/ 7;
              if (weekGroup >= 0 && weekGroup < 4) {
                weeklyScoresGroups[weekGroup].add(score);
              }
              
              // If within the last 7 days, add to weeklySpots
              if (daysAgo < 7) {
                int index = date.weekday - 1; // 0=Mon, 6=Sun
                thisWeekScores[index] = score;
              }
            }
          }

          final metrics = a['assessment_sleep_metrics'];
          if (metrics != null && metrics is List && metrics.isNotEmpty) {
            final durationMins = metrics[0]['sleep_duration_minutes'];
            if (durationMins != null) {
              final hours = durationMins / 60.0;

              // Only calculate average duration for the last 7 days
              if (daysAgo < 7) {
                totalHours += hours;
                count++;
                int index = date.weekday - 1;
                weekDuration[index] = hours;
              }
            }
          }
        }
      }

      weeklyData = weekDuration;
      avgDurationHours = count > 0 ? (totalHours / count) : 0;
      
      // Populate weekly spots
      weeklySpots = [];
      for (int i = 0; i < 7; i++) {
        if (thisWeekScores[i] != null) {
          weeklySpots.add(FlSpot(i.toDouble(), thisWeekScores[i]!));
        }
      }
      
      // Populate monthly spots (Week 1 = oldest, Week 4 = newest)
      monthlySpots = [];
      for (int i = 0; i < 4; i++) {
        // weekGroup 0 is newest, weekGroup 3 is oldest.
        // We want X=1 to be weekGroup 3, X=4 to be weekGroup 0.
        int weekGroup = 3 - i; 
        if (weeklyScoresGroups[weekGroup].isNotEmpty) {
          double sum = 0;
          for (var s in weeklyScoresGroups[weekGroup]) { sum += s; }
          double avg = sum / weeklyScoresGroups[weekGroup].length;
          monthlySpots.add(FlSpot((i + 1).toDouble(), avg));
        }
      }

    } catch (e) {
      debugPrint('Error loading report data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
