import 'package:flutter/material.dart';
import '../data/sources/onboarding_sources.dart';

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

  Future<bool> submitDailySurvey() async {
    if (!isValid()) return false;
    
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

      final assessmentData = {
        'assessment_type': 'daily_short',
        'status': 'completed',
        'scoring_details': {
          'q1': formatTime(bedtime),
          'q2': sleepLatencyMinutes,
          'q3': formatTime(wakeUpTime),
          'q4': hoursSlept,
          'q9': sleepQuality,
        }
      };

      final metricsData = {
        'bedtime': formatTime(bedtime),
        'wake_time': formatTime(wakeUpTime),
        'sleep_latency_minutes': sleepLatencyMinutes,
        'sleep_duration_minutes': (hoursSlept! * 60).toInt(),
        'awakenings_count': awakeningsCount,
        'sleep_efficiency_percent': efficiency,
        'subjective_quality_score': sleepQuality,
      };

      await source.saveSleepAssessment(
        assessmentData: assessmentData,
        metricsData: metricsData,
      );

      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}
