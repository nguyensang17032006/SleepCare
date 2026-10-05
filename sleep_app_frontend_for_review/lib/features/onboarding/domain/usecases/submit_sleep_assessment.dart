import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/assessment_answer.dart';
import '../entities/daily_sleep_score.dart';
import '../entities/sleep_assessment.dart';
import '../entities/sleep_metrics.dart';
import '../repositories/onboarding_repository.dart';

class SubmitSleepAssessment {
  final OnboardingRepository repository;

  const SubmitSleepAssessment(this.repository);

  Future<Either<Failure, SleepAssessment>> call({
    required SleepAssessment assessment,
    required List<AssessmentAnswer> answers,
    required SleepMetrics metrics,
    required DailySleepScore dailyScore,
  }) {
    return repository.submitSleepAssessment(
      assessment: assessment,
      answers: answers,
      metrics: metrics,
      dailyScore: dailyScore,
    );
  }
}
