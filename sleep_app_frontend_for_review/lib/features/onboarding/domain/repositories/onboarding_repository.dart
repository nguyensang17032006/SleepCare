import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/assessment_answer.dart';
import '../entities/assessment_requirement.dart';
import '../entities/daily_sleep_score.dart';
import '../entities/questionnaire_question.dart';
import '../entities/sleep_assessment.dart';
import '../entities/sleep_metrics.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, AssessmentRequirement>> checkRequiredAssessment();

  Future<Either<Failure, List<QuestionnaireQuestion>>> getActiveQuestions({
    required String questionnaireCode,
  });

  Future<Either<Failure, SleepAssessment>> submitSleepAssessment({
    required SleepAssessment assessment,
    required List<AssessmentAnswer> answers,
    required SleepMetrics metrics,
    required DailySleepScore dailyScore,
  });

  Future<Either<Failure, List<DailySleepScore>>> getDailySleepScores({
    required DateTime startDate,
    required DateTime endDate,
  });
}
