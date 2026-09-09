import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/usecases/get_active_question.dart';

import '../../../domain/entities/assessment_answer.dart';
import '../../../domain/entities/daily_sleep_score.dart';
import '../../../domain/entities/questionnaire_question.dart';
import '../../../domain/entities/sleep_assessment.dart';
import '../../../domain/entities/sleep_metrics.dart';
import '../../../domain/usecases/submit_sleep_assessment.dart';

import 'daily_short_event.dart';
import 'daily_short_state.dart';

class DailyShortBloc extends Bloc<DailyShortEvent, DailyShortState> {
  final GetActiveQuestions getActiveQuestions;
  final SubmitSleepAssessment submitSleepAssessment;

  DateTime? _startedAt;

  DailyShortBloc({
    required this.getActiveQuestions,
    required this.submitSleepAssessment,
  }) : super(const DailyShortState()) {
    on<DailyShortStarted>(_onStarted);
    on<DailyShortAnswerChanged>(_onAnswerChanged);
    on<DailyShortSubmitted>(_onSubmitted);
  }

  Future<void> _onStarted(
    DailyShortStarted event,
    Emitter<DailyShortState> emit,
  ) async {
    emit(state.copyWith(status: DailyShortStatus.loading, clearError: true));

    final result = await getActiveQuestions(
      questionnaireCode: 'DAILY_SLEEP_CHECKIN',
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DailyShortStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (questions) {
        _startedAt = DateTime.now();

        emit(
          DailyShortState(status: DailyShortStatus.ready, questions: questions),
        );
      },
    );
  }

  void _onAnswerChanged(
    DailyShortAnswerChanged event,
    Emitter<DailyShortState> emit,
  ) {
    final updatedAnswers = Map<String, Object?>.from(state.answers);

    updatedAnswers[event.questionId] = event.value;

    emit(
      state.copyWith(
        status: DailyShortStatus.ready,
        answers: updatedAnswers,
        clearError: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    DailyShortSubmitted event,
    Emitter<DailyShortState> emit,
  ) async {
    if (!state.isComplete) {
      emit(
        state.copyWith(
          status: DailyShortStatus.failure,
          errorMessage: 'Vui lòng trả lời đầy đủ các câu hỏi.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: DailyShortStatus.submitting, clearError: true));

    try {
      final bedtime = _answerByCode<String>('BEDTIME');

      final sleepLatency = _answerByCode<num>('SLEEP_LATENCY').toInt();

      final wakeTime = _answerByCode<String>('WAKE_TIME');

      final hoursSlept = _answerByCode<num>('SLEEP_DURATION').toDouble();

      final awakenings = _answerByCode<num>('AWAKENINGS_COUNT').toInt();

      final sleepQuality = _answerByCode<num>('SLEEP_QUALITY').toInt();

      final hoursInBed = _calculateHoursInBed(
        bedtime: bedtime,
        wakeTime: wakeTime,
      );

      final efficiency = hoursInBed > 0
          ? ((hoursSlept / hoursInBed) * 100).clamp(0.0, 100.0).toDouble()
          : 0.0;

      final durationScore = _calculateDurationScore(hoursSlept);

      final efficiencyScore = efficiency * 0.3;

      final qualityScore = _calculateQualityScore(sleepQuality);

      final score = (durationScore + efficiencyScore + qualityScore)
          .clamp(0.0, 100.0)
          .toDouble();

      final roundedScore = double.parse(score.toStringAsFixed(1));

      final qualityLevel = _getQualityLevel(roundedScore);

      final now = DateTime.now();

      final answerEntities = _createAnswerEntities();

      final assessment = SleepAssessment(
        assessmentType: 'daily_short',
        assessmentDate: now,
        status: 'completed',
        rawTotalScore: roundedScore,
        normalizedScore: roundedScore,
        qualityLevel: qualityLevel,
        scoringDetails: {
          'duration_score': durationScore,
          'efficiency_score': double.parse(efficiencyScore.toStringAsFixed(1)),
          'quality_score': qualityScore,
        },
        startedAt: _startedAt ?? now,
        completedAt: now,
      );

      final metrics = SleepMetrics(
        bedtime: _normalizeTime(bedtime),
        wakeTime: _normalizeTime(wakeTime),
        sleepLatencyMinutes: sleepLatency,
        sleepDurationMinutes: (hoursSlept * 60).round(),
        awakeningsCount: awakenings,
        sleepEfficiencyPercent: double.parse(efficiency.toStringAsFixed(2)),
        subjectiveQualityScore: sleepQuality.toDouble(),
      );

      final dailyScore = DailySleepScore(
        scoreDate: now,
        score: roundedScore,
        qualityLevel: qualityLevel,
        sourceType: 'daily_short',
        scoringDetails: {
          'duration_score': durationScore,
          'efficiency_score': double.parse(efficiencyScore.toStringAsFixed(1)),
          'quality_score': qualityScore,
        },
      );

      final result = await submitSleepAssessment(
        assessment: assessment,
        answers: answerEntities,
        metrics: metrics,
        dailyScore: dailyScore,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: DailyShortStatus.failure,
              errorMessage: failure.message,
            ),
          );
        },
        (savedAssessment) {
          emit(
            state.copyWith(
              status: DailyShortStatus.success,
              dailyScore: roundedScore,
              clearError: true,
            ),
          );
        },
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DailyShortStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  T _answerByCode<T>(String questionCode) {
    final question = state.questions.firstWhere(
      (item) => item.questionCode == questionCode,
    );

    final value = state.answers[question.id];

    if (value == null) {
      throw StateError('Chưa trả lời câu hỏi $questionCode.');
    }

    if (value is! T) {
      throw StateError('Câu trả lời $questionCode không đúng kiểu dữ liệu.');
    }

    return value as T;
  }

  List<AssessmentAnswer> _createAnswerEntities() {
    final results = <AssessmentAnswer>[];

    for (final question in state.questions) {
      final value = state.answers[question.id];

      if (value == null) {
        continue;
      }

      results.add(
        AssessmentAnswer(
          questionId: question.id,
          answerValue: value,
          answerScore: _findAnswerScore(question, value),
          answeredAt: DateTime.now(),
        ),
      );
    }

    return results;
  }

  double? _findAnswerScore(QuestionnaireQuestion question, Object value) {
    for (final option in question.options) {
      if (option.value.toString() == value.toString()) {
        return option.score;
      }
    }

    return null;
  }

  double _calculateHoursInBed({
    required String bedtime,
    required String wakeTime,
  }) {
    final bedtimeParts = bedtime.split(':');
    final wakeTimeParts = wakeTime.split(':');

    if (bedtimeParts.length < 2 || wakeTimeParts.length < 2) {
      throw const FormatException('Giờ ngủ hoặc giờ thức dậy không hợp lệ.');
    }

    final bedtimeMinutes =
        int.parse(bedtimeParts[0]) * 60 + int.parse(bedtimeParts[1]);

    final wakeTimeMinutes =
        int.parse(wakeTimeParts[0]) * 60 + int.parse(wakeTimeParts[1]);

    var minutesInBed = wakeTimeMinutes - bedtimeMinutes;

    if (minutesInBed <= 0) {
      minutesInBed += 24 * 60;
    }

    return minutesInBed / 60;
  }

  double _calculateDurationScore(double hoursSlept) {
    if (hoursSlept >= 7 && hoursSlept <= 9) {
      return 40;
    }

    if ((hoursSlept >= 6 && hoursSlept < 7) ||
        (hoursSlept > 9 && hoursSlept <= 10)) {
      return 30;
    }

    if (hoursSlept >= 5 && hoursSlept < 6) {
      return 20;
    }

    return 10;
  }

  double _calculateQualityScore(int sleepQuality) {
    switch (sleepQuality) {
      case 0:
        return 30;
      case 1:
        return 20;
      case 2:
        return 10;
      case 3:
        return 0;
      default:
        throw StateError('Giá trị chất lượng giấc ngủ không hợp lệ.');
    }
  }

  String _getQualityLevel(double score) {
    if (score < 40) {
      return 'very_bad';
    }

    if (score < 60) {
      return 'bad';
    }

    if (score < 70) {
      return 'average';
    }

    if (score < 85) {
      return 'good';
    }

    return 'very_good';
  }

  String _normalizeTime(String value) {
    final parts = value.split(':');

    if (parts.length == 2) {
      return '$value:00';
    }

    return value;
  }
}
