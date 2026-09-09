import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sleep_app_frontend/features/onboarding/domain/entities/assessment_answer.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/entities/assessment_requirement.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/entities/daily_sleep_score.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/entities/questionnaire_question.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/entities/sleep_assessment.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/entities/sleep_metrics.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/services/sleep_scoring_service.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/usecases/check_required_assessment.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/usecases/get_active_question.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/usecases/submit_sleep_assessment.dart';

import 'questionnaire_event.dart';
import 'questionnaire_state.dart';

class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  final CheckRequiredAssessment checkRequiredAssessment;
  final GetActiveQuestions getActiveQuestions;
  final SubmitSleepAssessment submitSleepAssessment;
  final SleepScoringService scoringService;

  QuestionnaireBloc({
    required this.checkRequiredAssessment,
    required this.getActiveQuestions,
    required this.submitSleepAssessment,
    required this.scoringService,
  }) : super(const QuestionnaireState()) {
    on<QuestionnaireStarted>(_onStarted);
    on<QuestionnaireAnswerChanged>(_onAnswerChanged);
    on<QuestionnaireSubmitted>(_onSubmitted);
  }

  Future<void> _onStarted(
    QuestionnaireStarted event,
    Emitter<QuestionnaireState> emit,
  ) async {
    emit(
      state.copyWith(
        status: QuestionnaireStatus.loading,
        answers: const {},
        clearError: true,
      ),
    );

    final requirementResult = await checkRequiredAssessment();

    await requirementResult.match(
      (failure) async {
        emit(
          state.copyWith(
            status: QuestionnaireStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (requirement) async {
        final canDoFull =
            requirement == AssessmentRequirement.baselineFull ||
            requirement == AssessmentRequirement.repeatFull;

        if (!canDoFull) {
          emit(
            state.copyWith(
              status: QuestionnaireStatus.failure,
              requirement: requirement,
              errorMessage: 'Hôm nay người dùng không cần làm khảo sát đầy đủ.',
            ),
          );
          return;
        }

        final questionsResult = await getActiveQuestions(
          questionnaireCode: 'FULL_PSQI',
        );

        questionsResult.match(
          (failure) {
            emit(
              state.copyWith(
                status: QuestionnaireStatus.failure,
                requirement: requirement,
                errorMessage: failure.message,
              ),
            );
          },
          (questions) {
            emit(
              state.copyWith(
                status: QuestionnaireStatus.ready,
                requirement: requirement,
                questions: questions,
                answers: const {},
                clearError: true,
              ),
            );
          },
        );
      },
    );
  }

  void _onAnswerChanged(
    QuestionnaireAnswerChanged event,
    Emitter<QuestionnaireState> emit,
  ) {
    final updatedAnswers = Map<String, Object?>.from(state.answers);

    final isEmptyString =
        event.value is String && (event.value as String).trim().isEmpty;

    if (event.value == null || isEmptyString) {
      updatedAnswers.remove(event.questionId);
    } else {
      updatedAnswers[event.questionId] = event.value;
    }

    emit(
      state.copyWith(
        status: QuestionnaireStatus.ready,
        answers: updatedAnswers,
        clearError: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    QuestionnaireSubmitted event,
    Emitter<QuestionnaireState> emit,
  ) async {
    if (!state.isComplete) {
      emit(
        state.copyWith(
          status: QuestionnaireStatus.failure,
          errorMessage: 'Vui lòng trả lời đầy đủ các câu bắt buộc.',
        ),
      );
      return;
    }

    final requirement = state.requirement;

    if (requirement != AssessmentRequirement.baselineFull &&
        requirement != AssessmentRequirement.repeatFull) {
      emit(
        state.copyWith(
          status: QuestionnaireStatus.failure,
          errorMessage: 'Loại khảo sát không hợp lệ.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: QuestionnaireStatus.submitting, clearError: true),
    );

    try {
      final answersByCode = _createAnswersByCode();

      final scoreResult = scoringService.calculateFullAssessment(answersByCode);

      final now = DateTime.now();
      final assessmentDate = DateTime(now.year, now.month, now.day);

      final assessmentType = requirement == AssessmentRequirement.baselineFull
          ? 'baseline_full'
          : 'repeat_full';

      final assessmentAnswers = _createAssessmentAnswers(answeredAt: now);

      final assessment = SleepAssessment(
        assessmentType: assessmentType,
        assessmentDate: assessmentDate,
        status: 'completed',
        rawTotalScore: scoreResult.psqiRawScore,
        normalizedScore: scoreResult.psqiNormalizedScore,
        qualityLevel: scoreResult.psqiQualityLevel,
        scoringDetails: scoreResult.scoringDetails,
        startedAt: now,
        completedAt: now,
      );

      final dailyDurationHours = _numberByCode(
        answersByCode,
        'D_SLEEP_DURATION',
      );

      final metrics = SleepMetrics(
        bedtime: _stringByCode(answersByCode, 'D_BEDTIME'),
        wakeTime: _stringByCode(answersByCode, 'D_WAKE_TIME'),
        sleepLatencyMinutes: _numberByCode(
          answersByCode,
          'D_SLEEP_LATENCY',
        ).round(),
        sleepDurationMinutes: (dailyDurationHours * 60).round(),
        awakeningsCount: _numberByCode(
          answersByCode,
          'D_AWAKENINGS_COUNT',
        ).round(),
        sleepEfficiencyPercent: scoreResult.dailySleepEfficiency,
        subjectiveQualityScore: _numberByCode(answersByCode, 'D_SLEEP_QUALITY'),
      );

      final dailyDetails = Map<String, dynamic>.from(
        scoreResult.scoringDetails['daily'] as Map,
      );

      final dailyScore = DailySleepScore(
        scoreDate: assessmentDate,
        score: scoreResult.dailyScore,
        qualityLevel: scoreResult.dailyQualityLevel,
        sourceType: assessmentType,
        scoringDetails: dailyDetails,
      );

      final submitResult = await submitSleepAssessment(
        assessment: assessment,
        answers: assessmentAnswers,
        metrics: metrics,
        dailyScore: dailyScore,
      );

      submitResult.match(
        (failure) {
          emit(
            state.copyWith(
              status: QuestionnaireStatus.failure,
              errorMessage: failure.message,
            ),
          );
        },
        (savedAssessment) {
          emit(
            state.copyWith(
              status: QuestionnaireStatus.success,
              savedAssessment: savedAssessment,
              dailyScore: dailyScore,
              clearError: true,
            ),
          );
        },
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: QuestionnaireStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Map<String, Object?> _createAnswersByCode() {
    final result = <String, Object?>{};

    for (final question in state.questions) {
      if (state.answers.containsKey(question.id)) {
        result[question.questionCode] = state.answers[question.id];
      }
    }

    return result;
  }

  List<AssessmentAnswer> _createAssessmentAnswers({
    required DateTime answeredAt,
  }) {
    final answers = <AssessmentAnswer>[];

    for (final question in state.questions) {
      if (!state.answers.containsKey(question.id)) {
        continue;
      }

      final value = state.answers[question.id];

      answers.add(
        AssessmentAnswer(
          questionId: question.id,
          answerValue: value,
          answerScore: _findAnswerScore(question, value),
          answeredAt: answeredAt,
        ),
      );
    }

    return answers;
  }

  double? _findAnswerScore(QuestionnaireQuestion question, Object? answer) {
    for (final option in question.options) {
      if (option.value == answer) {
        return option.score;
      }
    }

    return null;
  }

  double _numberByCode(Map<String, Object?> answers, String code) {
    final value = answers[code];

    if (value is num) {
      return value.toDouble();
    }

    final parsed = double.tryParse(value?.toString() ?? '');

    if (parsed == null) {
      throw StateError('Câu trả lời $code không hợp lệ.');
    }

    return parsed;
  }

  String _stringByCode(Map<String, Object?> answers, String code) {
    final value = answers[code];

    if (value == null || value.toString().isEmpty) {
      throw StateError('Câu trả lời $code không hợp lệ.');
    }

    return value.toString();
  }
}
