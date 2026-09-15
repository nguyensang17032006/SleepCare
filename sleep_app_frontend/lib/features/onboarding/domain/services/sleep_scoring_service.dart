class FullSleepScoreResult {
  final double psqiRawScore;
  final double psqiNormalizedScore;
  final String psqiQualityLevel;

  final double dailyScore;
  final String dailyQualityLevel;

  final double monthlySleepEfficiency;
  final double dailySleepEfficiency;

  final Map<String, dynamic> scoringDetails;

  const FullSleepScoreResult({
    required this.psqiRawScore,
    required this.psqiNormalizedScore,
    required this.psqiQualityLevel,
    required this.dailyScore,
    required this.dailyQualityLevel,
    required this.monthlySleepEfficiency,
    required this.dailySleepEfficiency,
    required this.scoringDetails,
  });
}

class SleepScoringService {
  const SleepScoringService();

  FullSleepScoreResult calculateFullAssessment(Map<String, Object?> answers) {
    // Dữ liệu PSQI trong một tháng.
    final monthlyBedtime = _requiredTime(answers, 'Q1_BEDTIME');

    final monthlyLatency = _requiredNumber(answers, 'Q2_SLEEP_LATENCY');

    final monthlyWakeTime = _requiredTime(answers, 'Q3_WAKE_TIME');

    final monthlyDurationHours = _requiredNumber(answers, 'Q4_SLEEP_DURATION');

    final subjectiveQuality = _requiredNumber(
      answers,
      'Q9_SUBJECTIVE_QUALITY',
    ).round();

    // Thành phần 1: chất lượng giấc ngủ chủ quan.
    final component1 = subjectiveQuality.clamp(0, 3);

    // Thành phần 2: thời gian đi vào giấc ngủ.
    final latencyScore = _latencyScore(monthlyLatency);

    final cannotSleepScore = _requiredNumber(
      answers,
      'Q5A_CANNOT_SLEEP',
    ).round();

    final component2 = _combinedComponentScore(latencyScore + cannotSleepScore);

    // Thành phần 3: thời lượng ngủ.
    final component3 = _durationComponent(monthlyDurationHours);

    // Thành phần 4: hiệu suất giấc ngủ.
    final monthlyTimeInBed = _minutesBetween(monthlyBedtime, monthlyWakeTime);

    final monthlySleepEfficiency = monthlyTimeInBed == 0
        ? 0.0
        : ((monthlyDurationHours * 60) / monthlyTimeInBed * 100)
              .clamp(0, 100)
              .toDouble();

    final component4 = _efficiencyComponent(monthlySleepEfficiency);

    // Thành phần 5: các nguyên nhân gây gián đoạn giấc ngủ.
    final disturbanceCodes = [
      'Q5B_WAKE_NIGHT',
      'Q5C_BATHROOM',
      'Q5D_BREATHING',
      'Q5E_COUGH_SNORE',
      'Q5F_COLD',
      'Q5G_HOT',
      'Q5H_BAD_DREAMS',
      'Q5I_PAIN',
      'Q5J_OTHER_FREQUENCY',
    ];

    var disturbanceTotal = 0;

    for (final code in disturbanceCodes) {
      disturbanceTotal += _optionalNumber(answers, code).round();
    }

    final component5 = _disturbanceComponent(disturbanceTotal);

    // Thành phần 6: sử dụng thuốc ngủ.
    final component6 = _requiredNumber(
      answers,
      'Q6_SLEEP_MEDICATION',
    ).round().clamp(0, 3);

    // Thành phần 7: ảnh hưởng hoạt động ban ngày.
    final daytimeSleepiness = _requiredNumber(
      answers,
      'Q7_DAYTIME_SLEEPINESS',
    ).round();

    final enthusiasmDifficulty = _requiredNumber(
      answers,
      'Q8_ENTHUSIASM',
    ).round();

    final component7 = _combinedComponentScore(
      daytimeSleepiness + enthusiasmDifficulty,
    );

    final psqiRawScore =
        (component1 +
                component2 +
                component3 +
                component4 +
                component5 +
                component6 +
                component7)
            .toDouble();

    // Điểm mức độ PSQI: càng cao càng xấu.
    final psqiNormalizedScore = (psqiRawScore / 21 * 100)
        .clamp(0, 100)
        .toDouble();

    final psqiQualityLevel = psqiRawScore <= 5 ? 'good_sleep' : 'poor_sleep';

    // Dữ liệu riêng của đêm gần nhất.
    final dailyBedtime = _requiredTime(answers, 'D_BEDTIME');

    final dailyWakeTime = _requiredTime(answers, 'D_WAKE_TIME');

    final dailyDurationHours = _requiredNumber(answers, 'D_SLEEP_DURATION');

    final dailyLatencyMinutes = _requiredNumber(answers, 'D_SLEEP_LATENCY');

    final awakeningsCount = _requiredNumber(answers, 'D_AWAKENINGS_COUNT');

    final dailySubjectiveQuality = _requiredNumber(answers, 'D_SLEEP_QUALITY');

    final dailyTimeInBed = _minutesBetween(dailyBedtime, dailyWakeTime);

    final dailySleepEfficiency = dailyTimeInBed == 0
        ? 0.0
        : ((dailyDurationHours * 60) / dailyTimeInBed * 100)
              .clamp(0, 100)
              .toDouble();

    /*
     * Điểm ngày:
     * - Thời lượng ngủ: tối đa 40 điểm.
     * - Hiệu suất ngủ: tối đa 30 điểm.
     * - Chất lượng chủ quan: tối đa 30 điểm.
     */
    final durationDailyScore = (dailyDurationHours / 8 * 40)
        .clamp(0, 40)
        .toDouble();

    final efficiencyDailyScore = (dailySleepEfficiency / 100 * 30)
        .clamp(0, 30)
        .toDouble();

    final qualityDailyScore = (dailySubjectiveQuality / 5 * 30)
        .clamp(0, 30)
        .toDouble();

    final dailyScore =
        (durationDailyScore + efficiencyDailyScore + qualityDailyScore)
            .clamp(0, 100)
            .toDouble();

    final dailyQualityLevel = _dailyQualityLevel(dailyScore);

    return FullSleepScoreResult(
      psqiRawScore: psqiRawScore,
      psqiNormalizedScore: psqiNormalizedScore,
      psqiQualityLevel: psqiQualityLevel,
      dailyScore: dailyScore,
      dailyQualityLevel: dailyQualityLevel,
      monthlySleepEfficiency: monthlySleepEfficiency,
      dailySleepEfficiency: dailySleepEfficiency,
      scoringDetails: {
        'psqi': {
          'raw_score': psqiRawScore,
          'normalized_severity': psqiNormalizedScore,
          'score_direction': 'higher_is_worse',
          'components': {
            'subjective_quality': component1,
            'sleep_latency': component2,
            'sleep_duration': component3,
            'sleep_efficiency': component4,
            'sleep_disturbances': component5,
            'sleep_medication': component6,
            'daytime_dysfunction': component7,
          },
        },
        'daily': {
          'score': dailyScore,
          'score_direction': 'higher_is_better',
          'quality_level': dailyQualityLevel,
          'duration_score': durationDailyScore,
          'efficiency_score': efficiencyDailyScore,
          'subjective_quality_score': qualityDailyScore,
          'sleep_latency_minutes': dailyLatencyMinutes,
          'awakenings_count': awakeningsCount,
        },
      },
    );
  }

  int _latencyScore(double minutes) {
    if (minutes <= 15) return 0;
    if (minutes <= 30) return 1;
    if (minutes <= 60) return 2;
    return 3;
  }

  int _durationComponent(double hours) {
    if (hours > 7) return 0;
    if (hours >= 6) return 1;
    if (hours >= 5) return 2;
    return 3;
  }

  int _efficiencyComponent(double efficiency) {
    if (efficiency >= 85) return 0;
    if (efficiency >= 75) return 1;
    if (efficiency >= 65) return 2;
    return 3;
  }

  int _disturbanceComponent(int total) {
    if (total == 0) return 0;
    if (total <= 9) return 1;
    if (total <= 18) return 2;
    return 3;
  }

  int _combinedComponentScore(int total) {
    if (total == 0) return 0;
    if (total <= 2) return 1;
    if (total <= 4) return 2;
    return 3;
  }

  String _dailyQualityLevel(double score) {
    if (score >= 85) return 'very_good';
    if (score >= 70) return 'good';
    if (score >= 50) return 'average';
    if (score >= 30) return 'bad';
    return 'very_bad';
  }

  double _requiredNumber(Map<String, Object?> answers, String code) {
    final value = answers[code];

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      final parsed = double.tryParse(value);

      if (parsed != null) {
        return parsed;
      }
    }

    throw StateError('Câu trả lời $code không hợp lệ');
  }

  double _optionalNumber(Map<String, Object?> answers, String code) {
    final value = answers[code];

    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  int _requiredTime(Map<String, Object?> answers, String code) {
    final value = answers[code];

    if (value is! String) {
      throw StateError('Thời gian $code không hợp lệ');
    }

    final parts = value.split(':');

    if (parts.length != 2) {
      throw StateError('Thời gian $code không hợp lệ');
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      throw StateError('Thời gian $code không hợp lệ');
    }

    return hour * 60 + minute;
  }

  int _minutesBetween(int bedtimeMinutes, int wakeTimeMinutes) {
    var adjustedWakeTime = wakeTimeMinutes;

    if (adjustedWakeTime <= bedtimeMinutes) {
      adjustedWakeTime += 24 * 60;
    }

    return adjustedWakeTime - bedtimeMinutes;
  }
}
