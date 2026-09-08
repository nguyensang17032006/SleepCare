import 'package:flutter/material.dart';
import '../data/sources/onboarding_sources.dart';
import '../../../core/services/music_personalization_service.dart';

class DailyShortViewModel extends ChangeNotifier {
  bool isSubmitting = false;

  TimeOfDay? bedtime; // Q1
  int? sleepLatencyMinutes; // Q2
  TimeOfDay? wakeUpTime; // Q3
  double? hoursSlept; // Q4
  int? awakeningsCount; // Số lần thức giấc
  int? sleepQuality; // Q9: 0=Rất tốt, 1=Khá tốt, 2=Khá tệ, 3=Rất tệ

  void updateBedtime(TimeOfDay time) {
    bedtime = time;
    notifyListeners();
  }

  void updateSleepLatency(int minutes) {
    sleepLatencyMinutes = minutes;
    notifyListeners();
  }

  void updateWakeUpTime(TimeOfDay time) {
    wakeUpTime = time;
    notifyListeners();
  }

  void updateHoursSlept(double hours) {
    hoursSlept = hours;
    notifyListeners();
  }

  void updateAwakeningsCount(int count) {
    awakeningsCount = count;
    notifyListeners();
  }

  void updateSleepQuality(int quality) {
    sleepQuality = quality;
    notifyListeners();
  }

  bool isValid() {
    return bedtime != null &&
        sleepLatencyMinutes != null &&
        wakeUpTime != null &&
        hoursSlept != null &&
        awakeningsCount != null &&
        sleepQuality != null;
  }

  Future<String?> submitDailySurvey() async {
    if (!isValid()) return "Please fill all fields.";

    isSubmitting = true;
    notifyListeners();

    try {
      final source = OnboardingRemoteSource();

      String formatTime(TimeOfDay? time) {
        if (time == null) return "00:00:00";
        return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00";
      }

      double bedTimeDecimal = bedtime!.hour + bedtime!.minute / 60.0;
      double wakeTimeDecimal = wakeUpTime!.hour + wakeUpTime!.minute / 60.0;
      double hoursInBed = wakeTimeDecimal - bedTimeDecimal;
      if (hoursInBed < 0) hoursInBed += 24;
      double efficiency = hoursInBed > 0 ? (hoursSlept! / hoursInBed) * 100 : 0;
      efficiency = efficiency.clamp(0.0, 100.0);

      // Calculate a normalized daily sleep score (0-100)
      double score = 0;

      // 1. Duration (max 40 points)
      if (hoursSlept! >= 7 && hoursSlept! <= 9) {
        score += 40;
      } else if (hoursSlept! >= 6 && hoursSlept! < 7) {
        score += 30;
      } else if (hoursSlept! > 9 && hoursSlept! <= 10) {
        score += 30;
      } else if (hoursSlept! >= 5 && hoursSlept! < 6) {
        score += 20;
      } else {
        score += 10;
      }

      // 2. Efficiency (max 30 points)
      score += (efficiency * 0.3);

      // 3. Subjective Quality (max 30 points)
      // sleepQuality: 0=Very good, 1=Fairly good, 2=Fairly bad, 3=Very bad
      if (sleepQuality == 0) {
        score += 30;
      } else if (sleepQuality == 1) {
        score += 20;
      } else if (sleepQuality == 2) {
        score += 10;
      } else {
        score += 0;
      }

      final normalizedScore = score.clamp(0.0, 100.0);

      final assessmentData = {
        'assessment_type': 'daily_short',
        'raw_total_score': 0, // Fallback for schema constraint
        'normalized_score': double.parse(
          normalizedScore.toStringAsFixed(1),
        ), // Calculated score 0-100
        'status': 'completed',
        'completed_at': DateTime.now().toUtc().toIso8601String(),
        'scoring_details': {
          'q1': formatTime(bedtime),
          'q2': sleepLatencyMinutes,
          'q3': formatTime(wakeUpTime),
          'q4': hoursSlept,
          'q5': awakeningsCount,
          'q9': sleepQuality,
        },
      };

      final metricsData = {
        'bedtime': formatTime(bedtime),
        'wake_time': formatTime(wakeUpTime),
        'sleep_latency_minutes': sleepLatencyMinutes,
        'sleep_duration_minutes': (hoursSlept! * 60).toInt(),
        'awakenings_count': awakeningsCount,
        'sleep_efficiency_percent': double.parse(efficiency.toStringAsFixed(2)),
        'subjective_quality_score': sleepQuality,
      };

      await source.saveSleepAssessment(
        assessmentData: assessmentData,
        metricsData: metricsData,
      );

      // Trigger Music Personalization Engine
      await MusicPersonalizationService().processDailySleepScore(sleepQuality!);

      isSubmitting = false;
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('Daily survey submit error: $e');
      isSubmitting = false;
      notifyListeners();
      return e.toString();
    }
  }
}
