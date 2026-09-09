import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../../domain/entities/assessment_answer.dart';
import '../../domain/entities/assessment_requirement.dart';
import '../../domain/entities/daily_sleep_score.dart';
import '../../domain/entities/questionnaire_question.dart';
import '../../domain/entities/sleep_assessment.dart';
import '../../domain/entities/sleep_metrics.dart';
import '../../domain/repositories/onboarding_repository.dart';

import '../datasources/onboarding_remote_datasource.dart';
import '../model/assessment_answer_model.dart';
import '../model/daily_sleep_score_model.dart';
import '../model/sleep_assessment_model.dart';
import '../model/sleep_metrics_model.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;

  const OnboardingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AssessmentRequirement>>
  checkRequiredAssessment() async {
    try {
      final result = await remoteDataSource.checkRequiredAssessment();

      return right(result);
    } catch (error) {
      return left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QuestionnaireQuestion>>> getActiveQuestions({
    required String questionnaireCode,
  }) async {
    try {
      final models = await remoteDataSource.getActiveQuestions(
        questionnaireCode: questionnaireCode,
      );

      final questions = models.map((model) => model.toEntity()).toList();

      return right(questions);
    } catch (error) {
      return left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, SleepAssessment>> submitSleepAssessment({
    required SleepAssessment assessment,
    required List<AssessmentAnswer> answers,
    required SleepMetrics metrics,
    required DailySleepScore dailyScore,
  }) async {
    try {
      final assessmentModel = SleepAssessmentModel.fromEntity(assessment);

      final answerModels = answers
          .map(AssessmentAnswerModel.fromEntity)
          .toList();

      final metricsModel = SleepMetricsModel.fromEntity(metrics);

      final dailyScoreModel = DailySleepScoreModel.fromEntity(dailyScore);

      final savedModel = await remoteDataSource.submitSleepAssessment(
        assessment: assessmentModel,
        answers: answerModels,
        metrics: metricsModel,
        dailyScore: dailyScoreModel,
      );

      return right(savedModel.toEntity());
    } catch (error) {
      return left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DailySleepScore>>> getDailySleepScores({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final models = await remoteDataSource.getDailySleepScores(
        startDate: startDate,
        endDate: endDate,
      );

      final scores = models.map((model) => model.toEntity()).toList();

      return right(scores);
    } catch (error) {
      return left(ServerFailure(error.toString()));
    }
  }
}
